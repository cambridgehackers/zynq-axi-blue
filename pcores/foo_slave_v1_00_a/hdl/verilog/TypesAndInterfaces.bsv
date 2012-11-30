typedef struct {
        Bit#(32) x;
        Bit#(32) y;
} Params;

typedef enum { Octarine, Red=1, Green[0:5]=2, Blue[3] } Colors;

interface DUT;
    method Action ior(Bit#(32) a, Bit#(32) b);
    method Action iorShift(Bit#(32) x, Bit#(32) y);
    method ActionValue#(Bit#(32)) result();
endinterface

interface Foo;
    method Action bar(Bit#(17) a);
endinterface

interface NestedDut;
    interface Foo foo;
endinterface
