import TypesAndInterfaces::*;
import FifoToAxi::*;
import FIFOF::*;

module mkDUT(DUT);

    FifoToAxi fifoToAxi <-mkFifoToAxi();
    FifoFromAxi fifoFromAxi <-mkFifoFromAxi();
    Reg#(Maybe#(Bit#(32))) resultReg <- mkReg(tagged Invalid);
    Reg#(Maybe#(Bit#(32))) result2Reg <- mkReg(tagged Invalid);
    FIFOF#(Bit#(32)) fifoStatusFifo <- mkSizedFIFOF(16);
    FIFOF#(Bit#(32)) fromFifoStatusFifo <- mkSizedFIFOF(16);

    method Action setBase(Bit#(32) base);
        fifoToAxi.base <= base;
    endmethod
    method Action setBounds(Bit#(32) bounds);
        fifoToAxi.bounds <= bounds;
    endmethod
    method Action setThreshold(Bit#(32) threshold);
        fifoToAxi.threshold <= threshold;
        fifoFromAxi.threshold <= threshold;
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

    method Action readRange(Bit#(32) addr);
        fifoFromAxi.base <= addr;
        fifoFromAxi.bounds <= addr + 8*4;
        fifoFromAxi.enabled <= True;
    endmethod
    
    method Action readFromFifoStatus(Bit#(12) addr);
        fromFifoStatusFifo.enq(fifoFromAxi.readStatus(addr));
    endmethod
    method ActionValue#(Bit#(32)) fromFifoStatus() if (fromFifoStatusFifo.notEmpty);
        fromFifoStatusFifo.deq;
        return fromFifoStatusFifo.first;
    endmethod

    method ActionValue#(Bit#(32)) axirResponse();
        let r <- fifoFromAxi.getResponse();
        return r;
    endmethod

    method ActionValue#(Bit#(32)) readValue();
         let v = fifoFromAxi.first;
         fifoFromAxi.deq;
         return v;
    endmethod

    interface AxiMasterWrite axiw = fifoToAxi.axi;
    interface AxiMasterWrite axir = fifoFromAxi.axi;
endmodule
