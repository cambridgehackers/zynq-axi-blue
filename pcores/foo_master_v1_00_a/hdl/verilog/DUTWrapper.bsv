
import GetPut::*;
import Connectable::*;
import Adapter::*;
import TypesAndInterfaces::*;
import DUT::*;
import FifoToAxi::*;


interface DUTWrapper;
   interface Reg#(Bit#(32)) reqCount;
   interface Reg#(Bit#(32)) respCount;
   interface AxiMasterWrite axi;
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

  Bit#(0) DutRequestUnused;
} DutRequest deriving (Bits);

typedef union tagged {

    Bit#(32) Fifostatus$Response;

    Bit#(32) Axiresponse$Response;

  Bit#(0) DutResponseUnused;
} DutResponse deriving (Bits);

module mkDUTWrapper#(FromBit32#(DutRequest) requestFifo, ToBit32#(DutResponse) responseFifo)(DUTWrapper);

    DUT dut <- mkDUT();
    Reg#(Bit#(32)) requestFired <- mkReg(0);
    Reg#(Bit#(32)) responseFired <- mkReg(0);



    rule handle$setBase$request if (requestFifo.first matches tagged Setbase$Request .sp);
        requestFifo.deq;
        dut.setBase(sp.base);
        requestFired <= requestFired + 1;
    endrule

    rule handle$setBounds$request if (requestFifo.first matches tagged Setbounds$Request .sp);
        requestFifo.deq;
        dut.setBounds(sp.bounds);
        requestFired <= requestFired + 1;
    endrule

    rule handle$setThreshold$request if (requestFifo.first matches tagged Setthreshold$Request .sp);
        requestFifo.deq;
        dut.setThreshold(sp.threshold);
        requestFired <= requestFired + 1;
    endrule

    rule handle$setEnabled$request if (requestFifo.first matches tagged Setenabled$Request .sp);
        requestFifo.deq;
        dut.setEnabled(sp.v);
        requestFired <= requestFired + 1;
    endrule

    rule handle$enq$request if (requestFifo.first matches tagged Enq$Request .sp);
        requestFifo.deq;
        dut.enq(sp.v);
        requestFired <= requestFired + 1;
    endrule

    rule handle$readFifoStatus$request if (requestFifo.first matches tagged Readfifostatus$Request .sp);
        requestFifo.deq;
        dut.readFifoStatus(sp.addr);
        requestFired <= requestFired + 1;
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


    interface Reg reqCount = requestFired;
    interface Reg respCount = responseFired;
    interface axi = dut.axiw;
endmodule
