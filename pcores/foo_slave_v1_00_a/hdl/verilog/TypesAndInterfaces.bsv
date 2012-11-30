interface DUT;
    method Action ior(Bit#(32) a, Bit#(32) b);
    method Action iorShift(Bit#(32) x, Bit#(32) y);
    method ActionValue#(Bit#(32)) resultIorShift();
    method ActionValue#(Bit#(32)) result();
endinterface
