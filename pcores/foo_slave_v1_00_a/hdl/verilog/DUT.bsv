import TypesAndInterfaces::*;

module mkDUT(DUT);

    Reg#(Maybe#(Bit#(32))) resultReg <- mkReg(tagged Invalid);
    Reg#(Maybe#(Bit#(32))) result2Reg <- mkReg(tagged Invalid);

    method Action ior(Bit#(32) a, Bit#(32) b) if (resultReg matches tagged Invalid);
        resultReg <= tagged Valid (a | b);
    endmethod

    method Action iorShift(Bit#(32) a, Bit#(32) b) if (result2Reg matches tagged Invalid);
        result2Reg <= tagged Valid (a | (b << 16) | 32'h0000000b);
    endmethod

    method ActionValue#(Bit#(32)) result() if (resultReg matches tagged Valid .r);
        resultReg <= tagged Invalid;
        return r | 32'h30000000;
    endmethod

    method ActionValue#(Bit#(32)) resultIorShift() if (result2Reg matches tagged Valid .r);
        result2Reg <= tagged Invalid;
        return r | 32'h30007070;
    endmethod
endmodule