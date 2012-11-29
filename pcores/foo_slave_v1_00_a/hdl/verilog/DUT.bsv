import TypesAndInterfaces::*;

module mkDUT(DUT);

    Reg#(Maybe#(Bit#(32))) resultReg <- mkReg(tagged Invalid);

    method Action setParams(Bit#(32) a, Bit#(32) b) if (resultReg matches tagged Invalid);
        resultReg <= tagged Valid (a | b);
    endmethod

    method ActionValue#(Bit#(32)) result() if (resultReg matches tagged Valid .r);
        resultReg <= tagged Invalid;
        return r;
    endmethod
endmodule