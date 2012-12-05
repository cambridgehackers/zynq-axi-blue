import FifoToAxi::*;

interface DUT;
    method Action setBase(Bit#(32) base);
    method Action setBounds(Bit#(32) bounds);
    method Action setThreshold(Bit#(32) threshold);
    method Action setEnabled(Bit#(32) v);
    method Action enq(Bit#(32) v);

    method Action readFifoStatus(Bit#(12) addr);
    method ActionValue#(Bit#(32)) fifoStatus();

    method ActionValue#(Bit#(32)) axiResponse();
    interface AxiMasterWrite axiw;
endinterface
