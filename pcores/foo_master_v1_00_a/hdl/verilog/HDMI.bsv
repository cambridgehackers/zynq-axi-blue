import Vector::*;
import Clocks::*;
import FIFO::*;

interface HDMI;
    method Bit#(1) hdmi_vsync;
    method Bit#(1) hdmi_hsync;
    method Bit#(1) hdmi_de;
    method Bit#(16) hdmi_data;
endinterface

interface HdmiTestPatternGenerator;
    interface HDMI hdmi;
endinterface

module mkHdmiTestPatternGenerator#(SyncFIFOIfc#(Bit#(32)) patternFifo)(HdmiTestPatternGenerator);
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

    let vsync = (lineCount < vsyncWidth) ? 1 : 0;
    let hsync = (pixelCount < hsyncWidth) ? 1 : 0;

    rule updatePatternReg0 if (patternFifo.notEmpty);
        patternRegs[0] <= patternFifo.first;
        patternFifo.deq;
    endrule

    rule incrPixelCount;
        if (pixelCount == numberOfPixels-2)
        begin
           pixelCount <= 0; 
           if (lineCount == numberOfLines-2)
           begin
               lineCount <= 0;
               $finish(0);
           end
           else
               lineCount <= lineCount+1;
        end
        else
        begin
            pixelCount <= pixelCount + 1;
        end
    endrule

    let dataEnable = (pixelCount >= dePixelCountMinimum && pixelCount <= dePixelCountMaximum
                      && lineCount >= deLineCountMinimum && lineCount <= deLineCountMaximum);

    rule data;
        vsyncReg <= vsync;
        hsyncReg <= hsync;
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
        begin
            dataCount <= 0;
            patternRegs[1] <= 32'h80ff80ff;
            patternRegs[2] <= 32'h2c961596;
            patternRegs[3] <= 32'hff1d6b1d;
        end
    endrule

    rule display if (vsync == 1);
        $display("pixelCount %h lineCount %h dataEnable %d dataReg %h\n", pixelCount, lineCount, dataEnable, dataReg);
    endrule

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
