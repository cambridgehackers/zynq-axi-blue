
import FIFO::*;
import GetPut::*;
import Connectable::*;
import Adapter::*;
import AxiMasterSlave::*;
import HDMI::*;
import Clocks::*;
import TypesAndInterfaces::*;
import HdmiDisplay::*;



typedef union tagged {

    struct {
        Bit#(32) yuv422;
    } SetPatternReg$Request;

    struct {
        Bit#(32) base;
    } StartFrameBuffer$Request;

    struct {
        Bit#(32) unused;
    } WaitForVsync$Request;

    struct {
        Bit#(32) value;
    } HdmiLinesPixels$Request;

    struct {
        Bit#(32) value;
    } HdmiBlankLinesPixels$Request;

    struct {
        Bit#(32) strideBytes;
    } HdmiStrideBytes$Request;

    struct {
        Bit#(32) value;
    } HdmiLineCountMinMax$Request;

    struct {
        Bit#(32) value;
    } HdmiPixelCountMinMax$Request;

    struct {
        Bit#(32) value;
    } HdmiSyncWidths$Request;

    struct {
        Bit#(8) index;
    } BeginTranslationTable$Request;

    struct {
        Bit#(20) address;
        Bit#(12) length;
    } AddTranslationEntry$Request;

  Bit#(0) DutRequestUnused;
} HdmiDisplayRequest deriving (Bits);

typedef union tagged {

    Bit#(32) VsyncReceived$Response;

    Bit#(96) TranslationTableEntry$Response;

    Bit#(96) FbReading$Response;

  Bit#(0) DutResponseUnused;
} HdmiDisplayResponse deriving (Bits);

interface HdmiDisplayWrapper;
   method Bit#(1) interrupt();
   interface AxiSlave#(32,4) ctrl;
   interface AxiSlave#(32,4) fifo;

    interface AxiMaster#(64,8) m_axi;
    interface HDMI hdmi;
endinterface

typedef SizeOf#(HdmiDisplayRequest) HdmiDisplayRequestSize;
typedef SizeOf#(HdmiDisplayResponse) HdmiDisplayResponseSize;

module mkHdmiDisplayWrapper#(Clock hdmi_clk)(HdmiDisplayWrapper);

    HdmiDisplay hdmiDisplay <- mkHdmiDisplay(hdmi_clk);
    FromBit32#(HdmiDisplayRequest) requestFifo <- mkFromBit32();
    ToBit32#(HdmiDisplayResponse) responseFifo <- mkToBit32();
    Reg#(Bit#(32)) requestFired <- mkReg(0);
    Reg#(Bit#(32)) responseFired <- mkReg(0);
    Reg#(Bit#(32)) junkReqReg <- mkReg(0);
    Reg#(Bit#(16)) requestTimerReg <- mkReg(0);
    Reg#(Bit#(16)) requestTimeLimitReg <- mkReg(maxBound);
    Reg#(Bit#(16)) responseTimerReg <- mkReg(0);
    Reg#(Bit#(16)) responseTimeLimitReg <- mkReg(maxBound);
    Reg#(Bit#(32)) blockedRequestsDiscardedReg <- mkReg(0);
    Reg#(Bit#(32)) blockedResponsesDiscardedReg <- mkReg(0);

    Bit#(4) maxTag = 11;

    rule requestTimer if (requestFifo.notFull);
        requestTimerReg <= requestTimerReg + 1;
    endrule

    rule responseTimer if (!responseFifo.notFull);
        responseTimerReg <= responseTimerReg + 1;
    endrule

    //rule handleJunkRequest if (pack(requestFifo.first)[4+32-1:32] > maxTag);
    //    requestFifo.deq;
    //    junkReqReg <= junkReqReg + 1;
    //endrule


    rule handle$setPatternReg$request if (requestFifo.first matches tagged SetPatternReg$Request .sp);
        requestFifo.deq;
        hdmiDisplay.setPatternReg(sp.yuv422);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$startFrameBuffer$request if (requestFifo.first matches tagged StartFrameBuffer$Request .sp);
        requestFifo.deq;
        hdmiDisplay.startFrameBuffer(sp.base);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$waitForVsync$request if (requestFifo.first matches tagged WaitForVsync$Request .sp);
        requestFifo.deq;
        hdmiDisplay.waitForVsync(sp.unused);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule vsyncReceived$response;
        Bit#(32) r <- hdmiDisplay.vsyncReceived();
        let response = tagged VsyncReceived$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule handle$hdmiLinesPixels$request if (requestFifo.first matches tagged HdmiLinesPixels$Request .sp);
        requestFifo.deq;
        hdmiDisplay.hdmiLinesPixels(sp.value);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$hdmiBlankLinesPixels$request if (requestFifo.first matches tagged HdmiBlankLinesPixels$Request .sp);
        requestFifo.deq;
        hdmiDisplay.hdmiBlankLinesPixels(sp.value);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$hdmiStrideBytes$request if (requestFifo.first matches tagged HdmiStrideBytes$Request .sp);
        requestFifo.deq;
        hdmiDisplay.hdmiStrideBytes(sp.strideBytes);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$hdmiLineCountMinMax$request if (requestFifo.first matches tagged HdmiLineCountMinMax$Request .sp);
        requestFifo.deq;
        hdmiDisplay.hdmiLineCountMinMax(sp.value);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$hdmiPixelCountMinMax$request if (requestFifo.first matches tagged HdmiPixelCountMinMax$Request .sp);
        requestFifo.deq;
        hdmiDisplay.hdmiPixelCountMinMax(sp.value);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$hdmiSyncWidths$request if (requestFifo.first matches tagged HdmiSyncWidths$Request .sp);
        requestFifo.deq;
        hdmiDisplay.hdmiSyncWidths(sp.value);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$beginTranslationTable$request if (requestFifo.first matches tagged BeginTranslationTable$Request .sp);
        requestFifo.deq;
        hdmiDisplay.beginTranslationTable(sp.index);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$addTranslationEntry$request if (requestFifo.first matches tagged AddTranslationEntry$Request .sp);
        requestFifo.deq;
        hdmiDisplay.addTranslationEntry(sp.address, sp.length);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule translationTableEntry$response;
        Bit#(96) r <- hdmiDisplay.translationTableEntry();
        let response = tagged TranslationTableEntry$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule fbReading$response;
        Bit#(96) r <- hdmiDisplay.fbReading();
        let response = tagged FbReading$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    Reg#(Bit#(32)) interruptEnableReg <- mkReg(0);
    Reg#(Bool) interrupted <- mkReg(False);
    Reg#(Bool) interruptCleared <- mkReg(False);
    Reg#(Bit#(32)) getWordCount <- mkReg(0);
    Reg#(Bit#(32)) putWordCount <- mkReg(0);
    Reg#(Bit#(32)) word0Put  <- mkReg(0);
    Reg#(Bit#(32)) word1Put  <- mkReg(0);
    Reg#(Bit#(32)) underflowCount <- mkReg(0);
    Reg#(Bit#(32)) overflowCount <- mkReg(0);

    rule interrupted_rule;
        interrupted <= responseFifo.notEmpty;
    endrule
    rule reset_interrupt_cleared_rule if (!interrupted);
        interruptCleared <= False;
    endrule

    Reg#(Bit#(12)) ctrlReadAddrReg <- mkReg(0);
    Reg#(Bit#(12)) fifoReadAddrReg <- mkReg(0);
    Reg#(Bit#(12)) ctrlWriteAddrReg <- mkReg(0);
    Reg#(Bit#(12)) fifoWriteAddrReg <- mkReg(0);
    Reg#(Bit#(8)) ctrlReadBurstCountReg <- mkReg(0);
    Reg#(Bit#(8)) fifoReadBurstCountReg <- mkReg(0);
    Reg#(Bit#(8)) ctrlWriteBurstCountReg <- mkReg(0);
    Reg#(Bit#(8)) fifoWriteBurstCountReg <- mkReg(0);
    FIFO#(Bit#(2)) ctrlBrespFifo <- mkFIFO();
    FIFO#(Bit#(2)) fifoBrespFifo <- mkFIFO();

    interface AxiSlave ctrl;
        interface AxiSlaveWrite write;
            method Action writeAddr(Bit#(32) addr, Bit#(8) burstLen, Bit#(3) burstWidth,
                                     Bit#(2) burstType, Bit#(3) burstProt, Bit#(4) burstCache)
                          if (ctrlWriteBurstCountReg == 0);
                ctrlWriteBurstCountReg <= burstLen + 1;
                ctrlWriteAddrReg <= truncate(addr);
            endmethod
            method Action writeData(Bit#(32) v, Bit#(4) byteEnable, Bit#(1) last)
                          if (ctrlWriteBurstCountReg > 0);
                let addr = ctrlWriteAddrReg;
                ctrlWriteAddrReg <= ctrlWriteAddrReg + 12'd4;
                ctrlWriteBurstCountReg <= ctrlWriteBurstCountReg - 1;
                if (addr == 12'h000 && v[0] == 1'b1 && interrupted)
                begin
                    interruptCleared <= True;
                end
                if (addr == 12'h004)
                    interruptEnableReg <= v;
                ctrlBrespFifo.enq(0);
            endmethod
            method ActionValue#(Bit#(2)) writeResponse();
                ctrlBrespFifo.deq;
                return ctrlBrespFifo.first;
            endmethod
        endinterface
        interface AxiSlaveRead read;
            method Action readAddr(Bit#(32) addr, Bit#(8) burstLen, Bit#(3) burstWidth,
                                   Bit#(2) burstType, Bit#(3) burstProt, Bit#(4) burstCache)
                          if (ctrlReadBurstCountReg == 0);
                ctrlReadBurstCountReg <= burstLen + 1;
                ctrlReadAddrReg <= truncate(addr);
            endmethod
            method Bit#(1) last();
                return (ctrlReadBurstCountReg == 1) ? 1 : 0;
            endmethod
            method ActionValue#(Bit#(32)) readData()
                          if (ctrlReadBurstCountReg > 0);
                let addr = ctrlReadAddrReg;
                ctrlReadAddrReg <= ctrlReadAddrReg + 12'd4;
                ctrlReadBurstCountReg <= ctrlReadBurstCountReg - 1;

                let v = 32'h05a05a0;
                if (addr == 12'h000)
                begin
                    v = 0;
                    v[0] = interrupted ? 1'd1 : 1'd0 ;
                    v[16] = responseFifo.notFull ? 1'd1 : 1'd0;
                end
                if (addr == 12'h004)
                    v = interruptEnableReg;
                if (addr == 12'h008)
                    v = fromInteger(valueOf(HdmiDisplayRequestSize));
                if (addr == 12'h00C)
                    v = fromInteger(valueOf(HdmiDisplayResponseSize));
                if (addr == 12'h010)
                    v = requestFired;
                if (addr == 12'h014)
                    v = responseFired;
                if (addr == 12'h018)
                    v = underflowCount;
                if (addr == 12'h01C)
                    v = overflowCount;
                if (addr == 12'h020)
                    v = (32'h68470000
                         | (responseFifo.notFull ? 32'h20 : 0) | (responseFifo.notEmpty ? 32'h10 : 0)
                         | (requestFifo.notFull ? 32'h02 : 0) | (requestFifo.notEmpty ? 32'h01 : 0));
                if (addr == 12'h024)
                    v = putWordCount;
                if (addr == 12'h028)
                    v = getWordCount;
                if (addr == 12'h02C)
                    v = word0Put;
                if (addr == 12'h030)
                    v = word1Put;
                if (addr == 12'h034)
                    v = junkReqReg;
                if (addr == 12'h038)
                    v = blockedRequestsDiscardedReg;
                if (addr == 12'h03C)
                    v = blockedResponsesDiscardedReg;
                return v;
            endmethod
        endinterface
    endinterface

    interface AxiSlave fifo;
        interface AxiSlaveWrite write;
            method Action writeAddr(Bit#(32) addr, Bit#(8) burstLen, Bit#(3) burstWidth,
                                    Bit#(2) burstType, Bit#(3) burstProt, Bit#(4) burstCache)
                          if (fifoWriteBurstCountReg == 0);
                fifoWriteBurstCountReg <= burstLen + 1;
                fifoWriteAddrReg <= truncate(addr);
            endmethod
            method Action writeData(Bit#(32) v, Bit#(4) byteEnable, Bit#(1) last)
                          if (fifoWriteBurstCountReg > 0);
                let addr = fifoWriteAddrReg;
                fifoWriteAddrReg <= fifoWriteAddrReg + 12'd4;
                fifoWriteBurstCountReg <= fifoWriteBurstCountReg - 1;

                word0Put <= word1Put;
                word1Put <= v;
                if (requestFifo.notFull)
                begin
                    putWordCount <= putWordCount + 1;
                    requestFifo.enq(v);
                end
                else
                begin
                    overflowCount <= overflowCount + 1;
                end
                fifoBrespFifo.enq(0);
            endmethod
            method ActionValue#(Bit#(2)) writeResponse();
                fifoBrespFifo.deq;
                return fifoBrespFifo.first;
            endmethod
        endinterface
        interface AxiSlaveRead read;
            method Action readAddr(Bit#(32) addr, Bit#(8) burstLen, Bit#(3) burstWidth,
                                   Bit#(2) burstType, Bit#(3) burstProt, Bit#(4) burstCache)
                          if (fifoReadBurstCountReg == 0);
                fifoReadBurstCountReg <= burstLen + 1;
                fifoReadAddrReg <= truncate(addr);
            endmethod
            method Bit#(1) last();
                return (fifoReadBurstCountReg == 1) ? 1 : 0;
            endmethod
            method ActionValue#(Bit#(32)) readData()
                          if (fifoReadBurstCountReg > 0);
                let addr = fifoReadAddrReg;
                fifoReadAddrReg <= fifoReadAddrReg + 12'd4;
                fifoReadBurstCountReg <= fifoReadBurstCountReg - 1;
                let v = 32'h050a050a;
                if (responseFifo.notEmpty)
                begin
                    let r = responseFifo.first(); 
                    if (r matches tagged Valid .b) begin
                        v = b;
                        responseFifo.deq;
                        getWordCount <= getWordCount + 1;
                    end
                end
                else
                begin
                    underflowCount <= underflowCount + 1;
                end
                return v;
            endmethod
        endinterface
    endinterface

    method Bit#(1) interrupt();
        if (interruptEnableReg[0] == 1'd1 && !interruptCleared)
            return interrupted ? 1'd1 : 1'd0;
        else
            return 1'd0;
    endmethod


    interface AxiMaster m_axi = hdmiDisplay.m_axi;
    interface HDMI hdmi = hdmiDisplay.hdmi;
endmodule
