import TypesAndInterfaces::*;
import FifoToAxi::*;

module mkDUT(DUT);

    FifoToAxi fifoToAxi <-mkFifoToAxi();
    Reg#(Maybe#(Bit#(32))) resultReg <- mkReg(tagged Invalid);
    Reg#(Maybe#(Bit#(32))) result2Reg <- mkReg(tagged Invalid);

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
    method ActionValue#(Bit#(32)) getResponse();
        let r <- fifoToAxi.getResponse();
        return r;
    endmethod
    interface AxiMasterWrite axiw = fifoToAxi.axi;
endmodule