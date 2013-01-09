import Vector::*;
import Clocks::*;
import FIFO::*;
import FIFOF::*;
import YUV::*;

interface HDMI;
    method Bit#(1) hdmi_vsync;
    method Bit#(1) hdmi_hsync;
    method Bit#(1) hdmi_de;
    method Bit#(16) hdmi_data;
endinterface

typedef union tagged {
    struct {
        Bit#(32) yuv422;
    } PatternColor;
    struct {
        Bool enabled;
    } TestPattern;
} HdmiCommand deriving (Bits);

interface HdmiTestPatternGenerator;
    interface HDMI hdmi;
endinterface

typedef struct {
    Bit#(11) line;
    Bit#(12) pixel;
} LinePixelCount;

typedef struct {
    Bit#(1) vsync;
    Bit#(1) hsync;
    Bool de;
    Rgb888 data;
} Rgb888Stage deriving (Bits);

typedef struct {
    Bit#(1) vsync;
    Bit#(1) hsync;
    Bool de;
    Yuv444Intermediates data;
} Yuv444IntermediatesStage deriving (Bits);

typedef struct {
    Bit#(1) vsync;
    Bit#(1) hsync;
    Bool de;
    Yuv444 data;
} Yuv444Stage deriving (Bits);

typedef struct {
    Bit#(1) vsync;
    Bit#(1) hsync;
    Bool de;
    Bit#(16) data;
} Yuv422Stage deriving (Bits);

module mkHdmiTestPatternGenerator#(SyncFIFOIfc#(HdmiCommand) commandFifo,
                                   SyncFIFOIfc#(Bit#(64)) rgbrgbFifo,
                                   SyncPulseIfc vsyncPulse,
                                   SyncPulseIfc hsyncPulse)(HdmiTestPatternGenerator);
    // 1920 * 1080
    let blankLines = 45;
    let hsyncWidth = 44;
    let dePixelCountMinimum = 192;
    let dePixelCountMaximum = 2112;
    let pixelMidpoint = 1152;
    let vsyncWidth = 5;
    let deLineCountMinimum = 41;
    let deLineCountMaximum = 1121;
    let lineMidpoint = 581;

    let numberOfLines = 1125;
    let numberOfPixels = 2200;
    let blankPixels = 280;
    Reg#(Bit#(11)) lineCount <- mkReg(0);
    Reg#(Bit#(12)) pixelCount <- mkReg(0);

    Reg#(Rgb888Stage) rgb888StageReg <- mkReg(Rgb888Stage { vsync: 0, hsync: 0, de: False, data: unpack(0) });
    Reg#(Yuv444IntermediatesStage) yuv444IntermediatesStageReg <- mkReg(Yuv444IntermediatesStage { vsync: 0, hsync: 0, de: False, data: unpack(0) });
    Reg#(Yuv444Stage) yuv444StageReg <- mkReg(Yuv444Stage { vsync: 0, hsync: 0, de: False, data: unpack(0) });
    Reg#(Yuv422Stage) yuv422StageReg <- mkReg(Yuv422Stage { vsync: 0, hsync: 0, de: False, data: unpack(0) });
    Reg#(Bool) evenOddPixelReg <- mkReg(False);

    Reg#(Bit#(1)) vsyncReg <- mkReg(0);
    Reg#(Bit#(1)) hsyncReg <- mkReg(0);
    Reg#(Bit#(22)) dataCount <- mkReg(0);
    Reg#(Bit#(32)) patternReg0 <- mkReg(32'h00FFFFFF); // white
    PulseWire sofPulse <- mkPulseWire;

    Vector#(4, Reg#(Bit#(32))) patternRegs <- replicateM(mkReg(0));

    Reg#(Bool) shadowTestPatternEnabled <- mkReg(True);
    Reg#(Bool) testPatternEnabled <- mkReg(True);

    FIFOF#(Bit#(64)) dataFifo <- mkUGSizedFIFOF(32);

    let vsync = (lineCount < vsyncWidth) ? 1 : 0;
    let hsync = (pixelCount < hsyncWidth) ? 1 : 0;

    let dataEnable = (pixelCount >= dePixelCountMinimum && pixelCount < dePixelCountMaximum
                      && lineCount >= deLineCountMinimum && lineCount < deLineCountMaximum);

    function LinePixelCount newCounts(Bit#(11) lc, Bit#(12) pc);
        let newLineCount = lc;
        let newPixelCount = pc;
        if (pc == numberOfPixels-2)
        begin
           newPixelCount = 0; 
           if (lc == numberOfLines-2)
           begin
               newLineCount = 0;
           end
           else
               newLineCount = lc+1;
        end
        else
        begin
            newPixelCount = pc + 1;
        end
        return LinePixelCount { line: newLineCount, pixel: newPixelCount };
    endfunction


    rule updatePatternReg0 if (commandFifo.first matches tagged PatternColor .x);
        patternReg0 <= x.yuv422;
        commandFifo.deq;
    endrule

    rule updateTestPatternEnabledReg if (commandFifo.first matches tagged TestPattern .x);
        shadowTestPatternEnabled <= x.enabled;
        commandFifo.deq;
    endrule

    // vsyncPulse is a SyncHandshake to a slow clock domain
    // so it is not ready every cycle.
    // Therefore, we send to it from a different rule so it does not block the fbRule
    rule sendVsyncPulse (lineCount == 0 && pixelCount == 0);
        $display("vsync pulse sent");
        vsyncPulse.send();
    endrule
    rule sendHsyncPulse (pixelCount == 0);
        $display("hsync pulse sent");
        hsyncPulse.send();
    endrule

    rule data if (testPatternEnabled);
        LinePixelCount counts = newCounts(lineCount, pixelCount);
        lineCount <= counts.line;
        pixelCount <= counts.pixel;

        if (pixelCount == 0)
            $display("tpg line %d", lineCount);

        if (lineCount == 0 && pixelCount == 0)
        begin
            $display("testPatternEnabled %d", shadowTestPatternEnabled);
            testPatternEnabled <= shadowTestPatternEnabled;

            patternRegs[0] <= patternReg0; 
            patternRegs[1] <= 32'h00FF0000; // blue
            patternRegs[2] <= 32'h0000FF00; // green
            patternRegs[3] <= 32'h000000FF; // red
            //patternRegs[1] <= 32'h80ff80ff; // yuv422 white
            //patternRegs[2] <= 32'h2c961596; // yuv422 green
            //patternRegs[3] <= 32'hff1d6b1d; // yuv422 red
        end

        Bit#(2) index = 0;
        if (pixelCount >= pixelMidpoint)
            index[0] = 1;
        if (lineCount >= lineMidpoint)
            index[1] = 1;
        Bit#(32) data = patternRegs[index];

        vsyncReg <= vsync;
        hsyncReg <= hsync;
        rgb888StageReg <= Rgb888Stage { vsync: vsync, hsync: hsync, de: dataEnable, data: unpack(truncate(data)) };

        if (dataEnable)
            dataCount <= dataCount + 1;
        else if (vsync == 1)
            dataCount <= 0;

    endrule

    rule fromRgbRgbFifo if (dataFifo.notFull);
        dataFifo.enq(rgbrgbFifo.first);
        rgbrgbFifo.deq;
    endrule

    // (* descending_urgency = "fbRule, notfbRule" *)
    // rule notfbRule if (!testPatternEnabled);
    //     rgb888StageReg <= Rgb888Stage { vsync: 0, hsync: 0, de: False, data: unpack(24'h070a0d) };
    // endrule

    rule fbRule if (!testPatternEnabled);
        if (pixelCount == 0)
            $display("fb line %d", lineCount);

        let myDataEnable = (pixelCount >= dePixelCountMinimum && pixelCount < dePixelCountMaximum
                            && lineCount >= deLineCountMinimum && lineCount < deLineCountMaximum);
        Rgb888 pixel = unpack(0);
        if (myDataEnable && dataFifo.notEmpty)
        begin
            Bit#(64) data = pack(dataFifo.first);
            Bit#(1) pixelSelect = dataCount[0];
            if (pixelSelect == 0)
            begin
                pixel = unpack(data[23:0]);
            end
            else if (pixelSelect == 1)
            begin
                pixel = unpack(data[55:32]);
            end
            // else if (pixelSelect == 2)
            // begin
            //     pixel = unpack(data[87:64]);
            // end
            // else
            // begin
            //     pixel = unpack(data[119:96]);
            // end
            dataCount <= dataCount + 1;

            if (pixelSelect == 1)
                dataFifo.deq;
        end
        else if (myDataEnable && !dataFifo.notEmpty)
        begin
            pixel = unpack(24'h070a0d);
            myDataEnable = False;
        end
        else 
        begin
            if (vsync == 1)
            begin
                dataCount <= 0;
            end
        end

        vsyncReg <= vsync;
        hsyncReg <= hsync;

        rgb888StageReg <= Rgb888Stage { vsync: vsync, hsync: hsync, de: myDataEnable, data: pixel };

        if (!myDataEnable)
        begin
            LinePixelCount counts = newCounts(lineCount, pixelCount);
            lineCount <= counts.line;
            pixelCount <= counts.pixel;
        end

        if (lineCount == 0 && pixelCount == 0)
        begin
            $display("testPatternEnabled %d", shadowTestPatternEnabled);
            testPatternEnabled <= shadowTestPatternEnabled;
        end

    endrule

    let nonBlank = (lineCount > blankLines && pixelCount > blankPixels);

    rule yuv444IntermediatesStage;
        let previous = rgb888StageReg;
        yuv444IntermediatesStageReg <= Yuv444IntermediatesStage {
            vsync: previous.vsync,
            hsync: previous.hsync,
            de: previous.de,
            data: (previous.de) ? rgbToYuvIntermediates(previous.data) : unpack(0)
        };
    endrule

    rule yuv444Stage;
        let previous = yuv444IntermediatesStageReg;
        yuv444StageReg <= Yuv444Stage {
            vsync: previous.vsync,
            hsync: previous.hsync,
            de: previous.de,
            data: (previous.de) ? yuvIntermediatesToYuv444(previous.data) : unpack(0)
        };
    endrule

    rule yuv422stage;
        let previous = yuv444StageReg;
        if (previous.de)
            evenOddPixelReg <= !evenOddPixelReg;
        Bit#(16) data = { evenOddPixelReg ? previous.data.u : previous.data.v,
                          previous.data.y };
        yuv422StageReg <= Yuv422Stage {
            vsync: previous.vsync,
            hsync: previous.hsync,
            de: previous.de,
            data: data
        };
    endrule

    interface HDMI hdmi;
        method Bit#(1) hdmi_vsync;
            return yuv422StageReg.vsync;
        endmethod
        method Bit#(1) hdmi_hsync;
            return yuv422StageReg.hsync;
        endmethod
        method Bit#(1) hdmi_de;
            return yuv422StageReg.de ? 1 : 0;
        endmethod
        method Bit#(16) hdmi_data;
            return yuv422StageReg.data;
        endmethod
    endinterface

endmodule
