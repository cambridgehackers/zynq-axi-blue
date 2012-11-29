typedef struct {
        Bit#(32) x;
        Bit#(32) y;
} Params;

typedef enum { Octarine, Red=1, Green[0:5]=2, Blue[3] } Colors;

interface DUT;
    method Action setParams(Bit#(32) a, Bit#(32) b);
    method ActionValue#(Bit#(32)) result();
endinterface

interface NestedDut;
    interface Foo foo;
        method Action bar(Bit#(17) a);
    endinterface
endinterface

