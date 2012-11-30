import Adapter::*;
import RegFile::*;
import DUTWrapper::*;
import GetPut::*;
import Connectable::*;

interface XIP;
   method Action put(Bit#(12) addr, Bit#(32) v);
   method ActionValue#(Bit#(32)) get(Bit#(12) addr);
   method Bit#(1) error();
   method Bit#(1) interrupt();
endinterface

module mkIpSlave(XIP);

   FromBit32#(DutRequest) requestFifo <- mkFromBit32();
   ToBit32#(DutResponse) responseFifo <- mkToBit32();
   DUTWrapper dutWrapper <- mkDUTWrapper(requestFifo, responseFifo);

   RegFile#(Bit#(12), Bit#(32)) rf <- mkRegFile(0, 12'hfff);
   Reg#(Bool) interrupted <- mkReg(False);
   Reg#(Bit#(32)) getWordCount <- mkReg(0);
   Reg#(Bit#(32)) putWordCount <- mkReg(0);

   rule fifoNotEmpty if (responseFifo.notEmpty && !interrupted);
       interrupted <= True;
   endrule

   method Action put(Bit#(12) addr, Bit#(32) v);
       if (addr == 12'h000 && v[0] == 1'b1)
           interrupted <= False;
       if (addr < 12'h100)
           rf.upd(addr, v);
       else
         begin
           putWordCount <= putWordCount + 1;
           requestFifo.enq(v);
         end
   endmethod

   method ActionValue#(Bit#(32)) get(Bit#(12) addr);
       if (addr < 12'h100)
         begin
           let v = rf.sub(addr);
           if (addr == 12'h000)
               v[0] = interrupted ? 1'd1 : 1'd0 ;
           if (addr == 12'h010)
               v = dutWrapper.reqCount;
           if (addr == 12'h014)
               v = dutWrapper.respCount;
           if (addr == 12'h018)
               v = putWordCount;
           if (addr == 12'h01C)
               v = getWordCount;
           return v;
         end
       else
           begin
               let v = 0;
               if (responseFifo.notEmpty)
               begin
                   let r = responseFifo.first(); 
                   if (r matches tagged Valid .b) begin
                       v = b;
                       responseFifo.deq;
                       getWordCount <= getWordCount + 1;
                   end
               end
               return v;
           end
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
