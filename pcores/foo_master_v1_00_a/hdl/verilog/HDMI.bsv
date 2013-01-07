import Vector::*;
import Clocks::*;
import FIFO::*;
import FIFOF::*;

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

module mkHdmiTestPatternGenerator#(SyncFIFOIfc#(HdmiCommand) commandFifo,
                                   SyncFIFOIfc#(Bit#(64)) pixelFifo,
                                   SyncPulseIfc vsyncPulse)(HdmiTestPatternGenerator);
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

    Reg#(Bit#(1)) vsyncReg <- mkReg(0);
    Reg#(Bit#(1)) hsyncReg <- mkReg(0);
    Reg#(Bit#(1)) dataEnableReg <- mkReg(0);
    Reg#(Bit#(16)) dataReg <- mkReg(0);
    Reg#(Bit#(22)) dataCount <- mkReg(0);
    Vector#(4, Reg#(Bit#(32))) patternRegs <- replicateM(mkReg(0));

    FIFOF#(Bit#(64)) ugFifo <- mkUGFIFOF();

    Reg#(Bool) shadowTestPatternEnabled <- mkReg(True);
    Reg#(Bool) testPatternEnabled <- mkReg(True);

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
        patternRegs[0] <= x.yuv422;
        commandFifo.deq;
    endrule

    rule updateTestPatternEnabledReg if (commandFifo.first matches tagged TestPattern .x);
        shadowTestPatternEnabled <= x.enabled;
        commandFifo.deq;
    endrule

    rule data if (testPatternEnabled);
        LinePixelCount counts = newCounts(lineCount, pixelCount);
        lineCount <= counts.line;
        pixelCount <= counts.pixel;
        vsyncReg <= vsync;
        hsyncReg <= hsync;

        if (pixelCount == 0)
            $display("tpg line %d", lineCount);

        if (lineCount == 0 && pixelCount == 0)
        begin
            $display("vsync pulse sent");
            vsyncPulse.send();

            $display("testPatternEnabled %d", shadowTestPatternEnabled);
            testPatternEnabled <= shadowTestPatternEnabled;

            patternRegs[1] <= 32'h80ff80ff;
            patternRegs[2] <= 32'h2c961596;
            patternRegs[3] <= 32'hff1d6b1d;
        end

        dataEnableReg <= (dataEnable) ? 1 : 0;
        Bit#(2) index = 0;
        if (pixelCount >= pixelMidpoint)
            index[0] = 1;
        if (lineCount >= lineMidpoint)
            index[1] = 1;
        Bit#(32) data = patternRegs[index];
        if (dataCount[0] == 0)
            dataReg <= data[15:0];
        else
            dataReg <= data[31:16];

        if (dataEnable)
            dataCount <= dataCount + 1;
        else if (vsync == 1)
            dataCount <= 0;

    endrule

    rule getData if (ugFifo.notFull);
        let d = pixelFifo.first;
        pixelFifo.deq;
        ugFifo.enq(d);
    endrule

    rule fbRule if (!testPatternEnabled);
        if (pixelCount == 0)
            $display("fb line %d", lineCount);

        vsyncReg <= vsync;
        hsyncReg <= hsync;

        if (lineCount == 0 && pixelCount == 0)
        begin
            $display("fb vsync pulse sent");
            vsyncPulse.send();
        end

        let myDataEnable = (pixelCount >= dePixelCountMinimum && pixelCount < dePixelCountMaximum
                            && lineCount >= deLineCountMinimum && lineCount < deLineCountMaximum);
        if (myDataEnable)
        begin
            if (ugFifo.notEmpty)
            begin
                dataEnableReg <= 1;
                Bit#(64) data = ugFifo.first;
                if (dataCount[1:0] == 0)
                    dataReg <= data[15:0];
                else if (dataCount[1:0] == 1)
                    dataReg <= data[31:16];
                else if (dataCount[1:0] == 2)
                    dataReg <= data[47:32];
                else
                    dataReg <= data[63:48];
                dataCount <= dataCount + 1;

                if (dataCount[1:0] == 3)
                    ugFifo.deq;
            end
            else
            begin
                dataEnableReg <= 0;
            end
        end
        else 
        begin
            dataEnableReg <= 0;
            if (vsync == 1)
            begin
                dataCount <= 0;
            end
        end

        if (!myDataEnable || ugFifo.notEmpty)
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

    // rule display if (vsync == 1);
    //     $display("pixelCount %h lineCount %h dataEnable %d dataReg %h\n", pixelCount, lineCount, dataEnable, dataReg);
    // endrule

    let nonBlank = (lineCount > blankLines && pixelCount > blankPixels);

    interface HDMI hdmi;
        method Bit#(1) hdmi_vsync;
            return vsyncReg;
        endmethod
        method Bit#(1) hdmi_hsync;
            return hsyncReg;
        endmethod
        method Bit#(1) hdmi_de;
            return dataEnableReg;
        endmethod
        method Bit#(16) hdmi_data;
            return dataReg;
        endmethod
    endinterface

endmodule
