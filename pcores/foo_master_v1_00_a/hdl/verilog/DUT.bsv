import TypesAndInterfaces::*;
import FifoToAxi::*;
import FIFOF::*;

module mkDUT(DUT);

    FifoToAxi fifoToAxi <-mkFifoToAxi();
    Reg#(Maybe#(Bit#(32))) resultReg <- mkReg(tagged Invalid);
    Reg#(Maybe#(Bit#(32))) result2Reg <- mkReg(tagged Invalid);
    FIFOF#(Bit#(32)) fifoStatusFifo <- mkSizedFIFOF(16);

    method Action setBase(Bit#(32) base);
        fifoToAxi.base <= base;
    endmethod
    method Action setBounds(Bit#(32) bounds);
        fifoToAxi.bounds <= bounds;
    endmethod
    method Action setThreshold(Bit#(32) threshold);
        fifoToAxi.threshold <= threshold;
    endmethod
    method Action setEnabled(Bit#(32) enabled);
        fifoToAxi.enabled <= (enabled != 32'd0) ? True : False;
    endmethod
    method Action enq(Bit#(32) v);
        fifoToAxi.enq(v);
    endmethod

    method Action readFifoStatus(Bit#(12) addr);
        fifoStatusFifo.enq(fifoToAxi.readStatus(addr));
    endmethod
    method ActionValue#(Bit#(32)) fifoStatus() if (fifoStatusFifo.notEmpty);
        fifoStatusFifo.deq;
        return fifoStatusFifo.first;
    endmethod

    method ActionValue#(Bit#(32)) axiResponse();
        let r <- fifoToAxi.getResponse();
        return r;
    endmethod
    interface AxiMasterWrite axiw = fifoToAxi.axi;
endmodule
