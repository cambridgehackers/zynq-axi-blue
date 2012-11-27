import RegFile::*;
import GetPut::*;

interface XIP;
   method Action put(Bit#(32) v);
   method ActionValue#(Bit#(32)) get();
   method Bit#(1) error();
   method Bit#(1) interrupt();
endinterface

module mkIP(XIP);

   Reg#(Bit#(32)) r <- mkReg(0);

   method Action put(Bit#(32) v);
       r <= v;
   endmethod
   method ActionValue#(Bit#(32)) get();
       return r;
   endmethod
   method Bit#(1) error();
       return 0;
   endmethod
   method Bit#(1) interrupt();
       return 0;
   endmethod
endmodule
