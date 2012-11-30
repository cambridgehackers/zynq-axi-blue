
import DUT::*;
import TypesAndInterfaces::*;
import GetPut::*;
import Connectable::*;
import Adapter::*;

typedef union tagged {
    struct {
        Bit#(32) a;
        Bit#(32) b;
    } Or$Request;
    struct {
        Bit#(32) a;
        Bit#(32) b;
    } OrShift$Request;
    struct {
        Bit#(32) unused;
    } ResultParams$Request;
} DutRequest deriving (Bits);

typedef union tagged {
    Bit#(32) Or$Response;
    Bit#(32) OrShift$Response;
    Bit#(32) Result$Response;
} DutResponse deriving (Bits);

interface DUTWrapper;
   interface Reg#(Bit#(32)) reqCount;
   interface Reg#(Bit#(32)) respCount;
endinterface

module mkDUTWrapper#(FromBit32#(DutRequest) requestFifo, ToBit32#(DutResponse) responseFifo)(DUTWrapper);

    DUT dut <- mkDUT();
    Reg#(Maybe#(DutResponse)) respReg <- mkReg(tagged Invalid);
    Reg#(Bit#(32)) requestFired <- mkReg(0);
    Reg#(Bit#(32)) responseFired <- mkReg(0);

    rule result_response;
        Bit#(32) r <- dut.result();
        let response = tagged Result$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule

    rule handle_or_request if (requestFifo.first matches tagged Or$Request .sp);
        requestFifo.deq;
        dut.ior(sp.a, sp.b);
        requestFired <= requestFired + 1;
    endrule
    rule handle_orShift_request if (requestFifo.first matches tagged OrShift$Request .sp);
        requestFifo.deq;
        dut.iorShift(sp.a, sp.b);
        requestFired <= requestFired + 1;
    endrule

    interface Reg reqCount = requestFired;
    interface Reg respCount = responseFired;
endmodule
