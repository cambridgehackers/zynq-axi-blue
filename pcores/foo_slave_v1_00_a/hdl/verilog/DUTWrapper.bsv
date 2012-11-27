
import DUT::*;
import GetPut::*;

typedef union tagged {
    struct {
        Bit#(32) a;
        Bit#(32) b;
    } SetParams;
} DutRequest deriving (Bits);

typedef union tagged {
    Bit#(32) Result;
} DutResponse deriving (Bits);

interface DUTWrapper;
   interface Put#(DutRequest) req;
   interface Get#(DutResponse) resp;
   interface Reg#(Bit#(32)) reqCount;
   interface Reg#(Bit#(32)) respCount;
endinterface

module mkDUTWrapper(DUTWrapper);
    DUT dut <- mkDUT();
    Reg#(Maybe#(DutResponse)) respReg <- mkReg(tagged Invalid);
    Reg#(Bit#(32)) requestFired <- mkReg(0);
    Reg#(Bit#(32)) responseFired <- mkReg(0);

    rule result_response;
        Bit#(32) r <- dut.result();
        responseFired <= responseFired + 1;
        DutResponse dutResponse = tagged Result r;
        respReg <= tagged Valid dutResponse;
    endrule

    interface Put req;
        method Action put(DutRequest req);
            case (req) matches
            tagged SetParams .sp  : begin
                dut.setParams(sp.a, sp.b);
                requestFired <= requestFired + 1;
            end
            endcase
        endmethod
    endinterface

    interface Get resp;
        method ActionValue#(DutResponse) get() if (respReg matches tagged Valid .r);
            respReg <= tagged Invalid;
            return r;
        endmethod
    endinterface
    interface Reg reqCount = requestFired;
    interface Reg respCount = responseFired;
endmodule
