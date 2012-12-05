
import GetPut::*;
import Connectable::*;
import Adapter::*;
import TypesAndInterfaces::*;
import FifoToAxi::*;
import DUT::*;


interface DUTWrapper;
   interface Reg#(Bit#(32)) reqCount;
   interface Reg#(Bit#(32)) respCount;
   interface AxiMasterWrite axiw;
   interface AxiMasterRead axir;
endinterface


typedef union tagged {

    struct {
        Bit#(32) base;
    } Setbase$Request;

    struct {
        Bit#(32) bounds;
    } Setbounds$Request;

    struct {
        Bit#(32) threshold;
    } Setthreshold$Request;

    struct {
        Bit#(32) v;
    } Setenabled$Request;

    struct {
        Bit#(32) v;
    } Enq$Request;

    struct {
        Bit#(12) addr;
    } Readfifostatus$Request;

    struct {
        Bit#(32) addr;
    } Readrange$Request;

    struct {
        Bit#(12) addr;
    } Readfromfifostatus$Request;

  Bit#(0) DutRequestUnused;
} DutRequest deriving (Bits);

typedef union tagged {

    Bit#(32) Fifostatus$Response;

    Bit#(32) Axiresponse$Response;

    Bit#(32) Fromfifostatus$Response;

    Bit#(32) Axirresponse$Response;

    Bit#(32) Readvalue$Response;

  Bit#(0) DutResponseUnused;
} DutResponse deriving (Bits);

module mkDUTWrapper#(FromBit32#(DutRequest) requestFifo, ToBit32#(DutResponse) responseFifo)(DUTWrapper);

    DUT dut <- mkDUT();
    Reg#(Bit#(32)) requestFired <- mkReg(0);
    Reg#(Bit#(32)) responseFired <- mkReg(0);
    Reg#(Bit#(8)) txnTimer <- mkReg(0);

    rule timer if (requestFifo.notEmpty);
        txnTimer <= txnTimer + 1;
    endrule

    rule cancel_txn if (txnTimer == 255);
        requestFifo.deq;
        txnTimer <= 0;
    endrule

    rule handle$setBase$request if (requestFifo.first matches tagged Setbase$Request .sp);
        requestFifo.deq;
        dut.setBase(sp.base);
        requestFired <= requestFired + 1;
        txnTimer <= 0;
    endrule

    rule handle$setBounds$request if (requestFifo.first matches tagged Setbounds$Request .sp);
        requestFifo.deq;
        dut.setBounds(sp.bounds);
        requestFired <= requestFired + 1;
        txnTimer <= 0;
    endrule

    rule handle$setThreshold$request if (requestFifo.first matches tagged Setthreshold$Request .sp);
        requestFifo.deq;
        dut.setThreshold(sp.threshold);
        requestFired <= requestFired + 1;
        txnTimer <= 0;
    endrule

    rule handle$setEnabled$request if (requestFifo.first matches tagged Setenabled$Request .sp);
        requestFifo.deq;
        dut.setEnabled(sp.v);
        requestFired <= requestFired + 1;
        txnTimer <= 0;
    endrule

    rule handle$enq$request if (requestFifo.first matches tagged Enq$Request .sp);
        requestFifo.deq;
        dut.enq(sp.v);
        requestFired <= requestFired + 1;
        txnTimer <= 0;
    endrule

    rule handle$readFifoStatus$request if (requestFifo.first matches tagged Readfifostatus$Request .sp);
        requestFifo.deq;
        dut.readFifoStatus(sp.addr);
        requestFired <= requestFired + 1;
        txnTimer <= 0;
    endrule

    rule fifoStatus$response;
        Bit#(32) r <- dut.fifoStatus();
        let response = tagged Fifostatus$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule axiResponse$response;
        Bit#(32) r <- dut.axiResponse();
        let response = tagged Axiresponse$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule handle$readRange$request if (requestFifo.first matches tagged Readrange$Request .sp);
        requestFifo.deq;
        dut.readRange(sp.addr);
        requestFired <= requestFired + 1;
        txnTimer <= 0;
    endrule

    rule handle$readFromFifoStatus$request if (requestFifo.first matches tagged Readfromfifostatus$Request .sp);
        requestFifo.deq;
        dut.readFromFifoStatus(sp.addr);
        requestFired <= requestFired + 1;
        txnTimer <= 0;
    endrule

    rule fromFifoStatus$response;
        Bit#(32) r <- dut.fromFifoStatus();
        let response = tagged Fromfifostatus$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule axirResponse$response;
        Bit#(32) r <- dut.axirResponse();
        let response = tagged Axirresponse$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule readValue$response;
        Bit#(32) r <- dut.readValue();
        let response = tagged Readvalue$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule


    interface Reg reqCount = requestFired;
    interface Reg respCount = responseFired;
    interface AxiMasterWrite axiw = dut.axiw;
    interface AxiMasterRead axir = dut.axir;
endmodule
