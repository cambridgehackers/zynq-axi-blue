import RegFile::*;

interface XIP;
   method Action put(Bit#(12) addr, Bit#(32) v);
   method ActionValue#(Bit#(32)) get(Bit#(12) addr);
   method Bit#(1) error();
   method Bit#(1) interrupt();
endinterface

module mkIpSlave(XIP);

   RegFile#(Bit#(12), Bit#(32)) rf <- mkRegFile(0, 12'hfff);
   Reg#(Bool) interrupted <- mkReg(False);

   rule timer if (rf.sub(12'h008) != 0);
      let newval = rf.sub(12'h008) - 1;
      rf.upd(12'h008, newval);
      if (newval == 32'd0)
          interrupted <= True;
   endrule

   method Action put(Bit#(12) addr, Bit#(32) v);
       if (addr == 12'h000 && v[0] == 1'b1)
           interrupted <= False;
       rf.upd(addr, v);
   endmethod
   method ActionValue#(Bit#(32)) get(Bit#(12) addr);
       return rf.sub(addr);
   endmethod
   method Bit#(1) error();
       return 0;
   endmethod
   method Bit#(1) interrupt();
       if (rf.sub(12'h04)[0] == 1'd1)
           return interrupted ? 1'd1 : 1'd0;
       else
           return 1'd0;
   endmethod
endmodule
