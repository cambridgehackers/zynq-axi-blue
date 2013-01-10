
import GetPut::*;
import Connectable::*;
import Adapter::*;
import AxiMasterSlave::*;
import AxiStream::*;
import FifoToAxi::*;
import TypesAndInterfaces::*;
import HDMI::*;
import DUT::*;
import Clocks::*;


interface DUTWrapper;
   method Bit#(32) requestSize();
   method Bit#(32) responseSize();
   interface Reg#(Bit#(32)) reqCount;
   interface Reg#(Bit#(32)) respCount;
   interface Reg#(Bit#(32)) junkReqCount;
   interface Reg#(Bit#(32)) vsyncPulseCount;
   interface Reg#(Bit#(32)) frameCount;

   interface AxiMasterWrite#(64,8) axiw0;
   interface AxiMasterRead#(64) axir0;
   interface AxiMasterWrite#(64,8) axiw1;
   interface AxiMasterRead#(64) axir1;
   interface HDMI hdmi;
endinterface


typedef union tagged {

    struct {
        Bit#(32) base;
    } SetBase$Request;

    struct {
        Bit#(32) bounds;
    } SetBounds$Request;

    struct {
        Bit#(32) threshold;
    } SetThreshold$Request;

    struct {
        Bit#(32) v;
    } SetEnabled$Request;

    struct {
        Bit#(32) v;
    } Enq$Request;

    struct {
        Bit#(12) addr;
    } ReadFifoStatus$Request;

    struct {
        Bit#(32) v;
    } Configure$Request;

    struct {
        Bit#(32) addr;
    } ReadRange$Request;

    struct {
        Bit#(12) addr;
    } ReadFromFifoStatus$Request;

    struct {
        Bit#(32) numWords;
    } RunTest$Request;

    struct {
        Bit#(32) base;
    } RunTest2$Request;

    struct {
        Bit#(32) yuv422;
    } SetPatternReg$Request;

    struct {
        Bit#(32) base;
    } StartFrameBuffer$Request;

  Bit#(0) DutRequestUnused;
} DutRequest deriving (Bits);

typedef union tagged {

    Bit#(32) FifoStatus$Response;

    Bit#(32) AxiResponse$Response;

    Bit#(32) FromFifoStatus$Response;

    Bit#(32) AxirResponse$Response;

    Bit#(32) ReadValue$Response;

    Bit#(32) TestCompleted$Response;

    Bit#(32) WriteQueued$Response;

    Bit#(32) WriteCompleted$Response;

    Bit#(32) FirstRead$Response;

    Bit#(32) ReadCompleted$Response;

    Bit#(32) Test2Completed$Response;

  Bit#(0) DutResponseUnused;
} DutResponse deriving (Bits);

module mkDUTWrapper#(Clock axis_clk, FromBit32#(DutRequest) requestFifo, ToBit32#(DutResponse) responseFifo)(DUTWrapper) provisos(Bits#(DutRequest,dutRequestSize),Bits#(DutRequest,dutResponseSize));

    DUT dut <- mkDUT(axis_clk);
    Reg#(Bit#(32)) requestFired <- mkReg(0);
    Reg#(Bit#(32)) responseFired <- mkReg(0);
    Reg#(Bit#(32)) junkReqReg <- mkReg(0);
    Reg#(Bit#(16)) requestTimerReg <- mkReg(0);
    Reg#(Bit#(16)) requestTimeLimitReg <- mkReg(maxBound);
    Reg#(Bit#(16)) responseTimerReg <- mkReg(0);
    Reg#(Bit#(16)) responseTimeLimitReg <- mkReg(maxBound);

    Bit#(4) maxTag = 13;

    rule handleJunkRequest if (pack(requestFifo.first)[4+32-1:32] > maxTag);
        requestFifo.deq;
        junkReqReg <= junkReqReg + 1;
    endrule

    rule requestTimer if (requestFifo.notFull);
        requestTimerReg <= requestTimerReg + 1;
    endrule

    rule discardBlockedRequests if (requestTimerReg > requestTimeLimitReg && requestFifo.notEmpty);
        requestFifo.deq;
        requestTimerReg <= 0;
    endrule

    rule responseTimer if (!responseFifo.notFull);
        responseTimerReg <= responseTimerReg + 1;
    endrule

    rule discardBlockedResponses if (responseTimerReg > responseTimeLimitReg && !responseFifo.notFull);
        responseFifo.deq;
        responseTimerReg <= 0;
    endrule


    rule handle$setBase$request if (requestFifo.first matches tagged SetBase$Request .sp);
        requestFifo.deq;
        dut.setBase(sp.base);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$setBounds$request if (requestFifo.first matches tagged SetBounds$Request .sp);
        requestFifo.deq;
        dut.setBounds(sp.bounds);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$setThreshold$request if (requestFifo.first matches tagged SetThreshold$Request .sp);
        requestFifo.deq;
        dut.setThreshold(sp.threshold);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$setEnabled$request if (requestFifo.first matches tagged SetEnabled$Request .sp);
        requestFifo.deq;
        dut.setEnabled(sp.v);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$enq$request if (requestFifo.first matches tagged Enq$Request .sp);
        requestFifo.deq;
        dut.enq(sp.v);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$readFifoStatus$request if (requestFifo.first matches tagged ReadFifoStatus$Request .sp);
        requestFifo.deq;
        dut.readFifoStatus(sp.addr);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    // rule fifoStatus$response;
    //     Bit#(32) r <- dut.fifoStatus();
    //     let response = tagged FifoStatus$Response r;
    //     responseFifo.enq(response);
    //     responseFired <= responseFired + 1;
    // endrule

    rule axiResponse$response;
        Bit#(32) r <- dut.axiResponse();
        let response = tagged AxiResponse$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule handle$configure$request if (requestFifo.first matches tagged Configure$Request .sp);
        requestFifo.deq;
        dut.configure(sp.v);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$readRange$request if (requestFifo.first matches tagged ReadRange$Request .sp);
        requestFifo.deq;
        dut.readRange(sp.addr);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$readFromFifoStatus$request if (requestFifo.first matches tagged ReadFromFifoStatus$Request .sp);
        requestFifo.deq;
        dut.readFromFifoStatus(sp.addr);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule fromFifoStatus$response;
        Bit#(32) r <- dut.fromFifoStatus();
        let response = tagged FromFifoStatus$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule axirResponse$response;
        Bit#(32) r <- dut.axirResponse();
        let response = tagged AxirResponse$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule readValue$response;
        Bit#(32) r <- dut.readValue();
        let response = tagged ReadValue$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule handle$runTest$request if (requestFifo.first matches tagged RunTest$Request .sp);
        requestFifo.deq;
        dut.runTest(sp.numWords);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule testCompleted$response;
        Bit#(32) r <- dut.testCompleted();
        let response = tagged TestCompleted$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule writeQueued$response;
        Bit#(32) r <- dut.writeQueued();
        let response = tagged WriteQueued$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule writeCompleted$response;
        Bit#(32) r <- dut.writeCompleted();
        let response = tagged WriteCompleted$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule firstRead$response;
        Bit#(32) r <- dut.firstRead();
        let response = tagged FirstRead$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule readCompleted$response;
        Bit#(32) r <- dut.readCompleted();
        let response = tagged ReadCompleted$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule handle$runTest2$request if (requestFifo.first matches tagged RunTest2$Request .sp);
        requestFifo.deq;
        dut.runTest2(sp.base);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
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

    rule test2Completed$response;
        Bit#(32) r <- dut.test2Completed();
        let response = tagged Test2Completed$Response r;
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
    interface Reg vsyncPulseCount = dut.vsyncPulseCount;
    interface Reg frameCount = dut.frameCount;

    interface AxiMasterWrite axiw0 = dut.axiw0;
    interface AxiMasterRead axir0 = dut.axir0;
    interface AxiMasterWrite axiw1 = dut.axiw1;
    interface AxiMasterRead axir1 = dut.axir1;
    interface HDMI hdmi = dut.hdmi;
endmodule
