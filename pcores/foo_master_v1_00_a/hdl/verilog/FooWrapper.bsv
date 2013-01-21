
import GetPut::*;
import Connectable::*;
import Adapter::*;
import AxiMasterSlave::*;
import Clocks::*;
import TypesAndInterfaces::*;
import Foo::*;


interface FooWrapper;
   method Bit#(32) requestSize();
   method Bit#(32) responseSize();
   interface Reg#(Bit#(32)) reqCount;
   interface Reg#(Bit#(32)) respCount;
   interface Reg#(Bit#(32)) junkReqCount;
   interface Reg#(Bit#(32)) blockedRequestsDiscardedCount;
   interface Reg#(Bit#(32)) blockedResponsesDiscardedCount;

    interface AxiMasterWrite#(64,8) axi0w;
    interface AxiMasterRead#(64) axi0r;
    interface AxiMasterWrite#(64,8) axi1w;
    interface AxiMasterRead#(64) axi1r;
    interface AxiMasterWrite#(64,8) axi2w;
    interface AxiMasterRead#(64) axi2r;
endinterface

typedef union tagged {

    struct {
        Bit#(32) addr;
    } ReadRange$Request;

    struct {
        Bit#(6) index;
    } BeginTranslationTable$Request;

    struct {
        Bit#(20) address;
        Bit#(12) length;
    } AddTranslationEntry$Request;

  Bit#(0) FooRequestUnused;
} FooRequest deriving (Bits);

typedef union tagged {

    Bit#(32) ReadValue$Response;

    Bit#(96) TranslationTableEntry$Response;

  Bit#(0) FooResponseUnused;
} FooResponse deriving (Bits);

module mkFooWrapper#(Clock axis_clk, FromBit32#(FooRequest) requestFifo, ToBit32#(FooResponse) responseFifo)(FooWrapper) provisos(Bits#(FooRequest,fooRequestSize),Bits#(FooResponse,fooResponseSize));

    Foo foo <- mkFoo(axis_clk);
    Reg#(Bit#(32)) requestFired <- mkReg(0);
    Reg#(Bit#(32)) responseFired <- mkReg(0);
    Reg#(Bit#(32)) junkReqReg <- mkReg(0);
    Reg#(Bit#(16)) requestTimerReg <- mkReg(0);
    Reg#(Bit#(16)) requestTimeLimitReg <- mkReg(maxBound);
    Reg#(Bit#(16)) responseTimerReg <- mkReg(0);
    Reg#(Bit#(16)) responseTimeLimitReg <- mkReg(maxBound);
    Reg#(Bit#(32)) blockedRequestsDiscardedReg <- mkReg(0);
    Reg#(Bit#(32)) blockedResponsesDiscardedReg <- mkReg(0);

    Bit#(2) maxTag = 3;

    rule handleJunkRequest if (pack(requestFifo.first)[2+32-1:32] > maxTag);
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


    rule handle$readRange$request if (requestFifo.first matches tagged ReadRange$Request .sp);
        requestFifo.deq;
        foo.readRange(sp.addr);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule readValue$response;
        Bit#(32) r <- foo.readValue();
        let response = tagged ReadValue$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule handle$beginTranslationTable$request if (requestFifo.first matches tagged BeginTranslationTable$Request .sp);
        requestFifo.deq;
        foo.beginTranslationTable(sp.index);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule handle$addTranslationEntry$request if (requestFifo.first matches tagged AddTranslationEntry$Request .sp);
        requestFifo.deq;
        foo.addTranslationEntry(sp.address, sp.length);
        requestFired <= requestFired + 1;
        requestTimerReg <= 0;
    endrule

    rule translationTableEntry$response;
        Bit#(96) r <- foo.translationTableEntry();
        let response = tagged TranslationTableEntry$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    method Bit#(32) requestSize();
        return pack(fromInteger(valueof(fooRequestSize)));
    endmethod
    method Bit#(32) responseSize();
        return pack(fromInteger(valueof(fooResponseSize)));
    endmethod
    interface Reg reqCount = requestFired;
    interface Reg respCount = responseFired;
    interface Reg junkReqCount = junkReqReg;
    interface Reg blockedRequestsDiscardedCount = blockedRequestsDiscardedReg;
    interface Reg blockedResponsesDiscardedCount = blockedResponsesDiscardedReg;

    interface AxiMasterWrite axi0w = foo.axi0w;
    interface AxiMasterRead axi0r = foo.axi0r;
    interface AxiMasterWrite axi1w = foo.axi1w;
    interface AxiMasterRead axi1r = foo.axi1r;
    interface AxiMasterWrite axi2w = foo.axi2w;
    interface AxiMasterRead axi2r = foo.axi2r;
endmodule
