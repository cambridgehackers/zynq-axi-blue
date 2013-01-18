
import GetPut::*;
import Connectable::*;
import Adapter::*;
import AxiMasterSlave::*;
import HDMI::*;
import Clocks::*;
import TypesAndInterfaces::*;
import DUT::*;


interface DUTWrapper;
   method Bit#(32) requestSize();
   method Bit#(32) responseSize();
   interface Reg#(Bit#(32)) reqCount;
   interface Reg#(Bit#(32)) respCount;
   interface Reg#(Bit#(32)) junkReqCount;
   interface Reg#(Bit#(32)) blockedRequestsDiscardedCount;
   interface Reg#(Bit#(32)) blockedResponsesDiscardedCount;

   interface AxiMasterWrite#(64,8) axiw0;
   interface AxiMasterRead#(64) axir0;
   interface AxiMasterWrite#(64,8) axiw1;
   interface AxiMasterRead#(64) axir1;
   interface HDMI hdmi;
endinterface

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
        Bit#(6) index;
    } BeginTranslationTable$Request;

    struct {
        Bit#(20) address;
        Bit#(12) length;
    } AddTranslationEntry$Request;

  Bit#(0) DutRequestUnused;
} DutRequest deriving (Bits);

typedef union tagged {

    Bit#(32) VsyncReceived$Response;

    Bit#(96) TranslationTableEntry$Response;

    Bit#(96) FbReading$Response;

  Bit#(0) DutResponseUnused;
} DutResponse deriving (Bits);

module mkDUTWrapper#(Clock axis_clk, FromBit32#(DutRequest) requestFifo, ToBit32#(DutResponse) responseFifo)(DUTWrapper) provisos(Bits#(DutRequest,dutRequestSize),Bits#(DutResponse,dutResponseSize));

    DUT dut <- mkDUT(axis_clk);
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

    rule handleJunkRequest if (pack(requestFifo.first)[4+32-1:32] > maxTag);
        requestFifo.deq;
        junkReqReg <= junkReqReg + 1;
    endrule

    rule requestTimer if (requestFifo.notFull);
        requestTimerReg <= requestTimerReg + 1;
    endrule

    rule discardBlockedRequests if (requestTimerReg > requestTimeLimitReg && requestFifo.notEmpty);
        requestFifo.deq;
        blockedRequestsDiscardedReg <= blockedRequestsDiscardedReg + 1;
        requestTimerReg <= 0;
    endrule

    rule responseTimer if (!responseFifo.notFull);
        responseTimerReg <= responseTimerReg + 1;
    endrule

    rule discardBlockedResponses if (responseTimerReg > responseTimeLimitReg && !responseFifo.notFull);
        responseFifo.deq;
        blockedResponsesDiscardedReg <= blockedResponsesDiscardedReg + 1;
        responseTimerReg <= 0;
    endrule


    rule handle$setPatternReg$request if (requestFifo.first matches tagged SetPatternReg$Request .sp);
        requestFifo.deq;
        dut.setPatternReg(sp.yuv422);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$startFrameBuffer$request if (requestFifo.first matches tagged StartFrameBuffer$Request .sp);
        requestFifo.deq;
        dut.startFrameBuffer(sp.base);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$waitForVsync$request if (requestFifo.first matches tagged WaitForVsync$Request .sp);
        requestFifo.deq;
        dut.waitForVsync(sp.unused);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule vsyncReceived$response;
        Bit#(32) r <- dut.vsyncReceived();
        let response = tagged VsyncReceived$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule handle$hdmiLinesPixels$request if (requestFifo.first matches tagged HdmiLinesPixels$Request .sp);
        requestFifo.deq;
        dut.hdmiLinesPixels(sp.value);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$hdmiBlankLinesPixels$request if (requestFifo.first matches tagged HdmiBlankLinesPixels$Request .sp);
        requestFifo.deq;
        dut.hdmiBlankLinesPixels(sp.value);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$hdmiStrideBytes$request if (requestFifo.first matches tagged HdmiStrideBytes$Request .sp);
        requestFifo.deq;
        dut.hdmiStrideBytes(sp.strideBytes);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$hdmiLineCountMinMax$request if (requestFifo.first matches tagged HdmiLineCountMinMax$Request .sp);
        requestFifo.deq;
        dut.hdmiLineCountMinMax(sp.value);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$hdmiPixelCountMinMax$request if (requestFifo.first matches tagged HdmiPixelCountMinMax$Request .sp);
        requestFifo.deq;
        dut.hdmiPixelCountMinMax(sp.value);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$hdmiSyncWidths$request if (requestFifo.first matches tagged HdmiSyncWidths$Request .sp);
        requestFifo.deq;
        dut.hdmiSyncWidths(sp.value);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$beginTranslationTable$request if (requestFifo.first matches tagged BeginTranslationTable$Request .sp);
        requestFifo.deq;
        dut.beginTranslationTable(sp.index);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$addTranslationEntry$request if (requestFifo.first matches tagged AddTranslationEntry$Request .sp);
        requestFifo.deq;
        dut.addTranslationEntry(sp.address, sp.length);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule translationTableEntry$response;
        Bit#(96) r <- dut.translationTableEntry();
        let response = tagged TranslationTableEntry$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule fbReading$response;
        Bit#(96) r <- dut.fbReading();
        let response = tagged FbReading$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    method Bit#(32) requestSize();
        return pack(fromInteger(valueof(dutRequestSize)));
    endmethod
    method Bit#(32) responseSize();
        return pack(fromInteger(valueof(dutResponseSize)));
    endmethod
    interface Reg reqCount = requestFired;
    interface Reg respCount = responseFired;
    interface Reg junkReqCount = junkReqReg;
    interface Reg blockedRequestsDiscardedCount = blockedRequestsDiscardedReg;
    interface Reg blockedResponsesDiscardedCount = blockedResponsesDiscardedReg;

    interface AxiMasterWrite axiw0 = dut.axiw0;
    interface AxiMasterRead axir0 = dut.axir0;
    interface AxiMasterWrite axiw1 = dut.axiw1;
    interface AxiMasterRead axir1 = dut.axir1;
    interface HDMI hdmi = dut.hdmi;
endmodule
