
import GetPut::*;
import Connectable::*;
import Adapter::*;
import TypesAndInterfaces::*;
import DUT::*;
import DUT::*;


interface DUTWrapper;
   interface Reg#(Bit#(32)) reqCount;
   interface Reg#(Bit#(32)) respCount;
   interface Reg#(Bit#(32)) req2Count;
   interface Reg#(Bit#(32)) resp2Count;
endinterface


typedef union tagged {

    struct {
        Bit#(32) a;
        Bit#(32) b;
    } Ior$Request;

    struct {
        Bit#(32) x;
        Bit#(32) y;
    } Iorshift$Request;

  Bit#(0) DutRequestUnused;
} DutRequest deriving (Bits);

typedef union tagged {

    Bit#(32) Resultiorshift$Response;

    Bit#(32) Result$Response;

  Bit#(0) DutResponseUnused;
} DutResponse deriving (Bits);

module mkDUTWrapper#(FromBit32#(DutRequest) requestFifo, ToBit32#(DutResponse) responseFifo)(DUTWrapper);

    DUT dut <- mkDUT();
    Reg#(Bit#(32)) requestFired <- mkReg(0);
    Reg#(Bit#(32)) responseFired <- mkReg(0);
    Reg#(Bit#(32)) request2Fired <- mkReg(0);
    Reg#(Bit#(32)) response2Fired <- mkReg(0);



    rule handle$ior$request if (requestFifo.first matches tagged Ior$Request .sp);
        requestFifo.deq;
        dut.ior(sp.a, sp.b);
        requestFired <= requestFired + 1;
    endrule

    rule handle$iorShift$request if (requestFifo.first matches tagged Iorshift$Request .sp);
        requestFifo.deq;
        dut.iorShift(sp.x, sp.y);
        request2Fired <= request2Fired + 1;
    endrule

    rule resultIorShift$response;
        Bit#(32) r <- dut.resultIorShift();
        let response = tagged Resultiorshift$Response r;
        responseFifo.enq(response);
        response2Fired <= response2Fired + 1;
    endrule

    rule result$response;
        Bit#(32) r <- dut.result();
        let response = tagged Result$Response r;
        responseFifo.enq(response);
        responseFired <= responseFired + 1;
    endrule


    interface Reg reqCount = requestFired;
    interface Reg respCount = responseFired;
    interface Reg req2Count = request2Fired;
    interface Reg resp2Count = response2Fired;
endmodule
