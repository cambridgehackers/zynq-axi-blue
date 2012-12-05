import RegFile::*;
import Adapter::*;
import FifoToAxi::*;
import DUTWrapper::*;
import GetPut::*;
import Connectable::*;

interface IpSlaveWithMaster;
   method Action put(Bit#(12) addr, Bit#(32) v);
   method ActionValue#(Bit#(32)) get(Bit#(12) addr);
   method Bit#(1) error();
   method Bit#(1) interrupt();
   interface AxiMasterWrite axiw;
   interface AxiMasterRead axir;
endinterface

module mkIpSlaveWithMaster(IpSlaveWithMaster);

   FromBit32#(DutRequest) requestFifo <- mkFromBit32();
   ToBit32#(DutResponse) responseFifo <- mkToBit32();
   DUTWrapper dutWrapper <- mkDUTWrapper(requestFifo, responseFifo);

   RegFile#(Bit#(12), Bit#(32)) rf <- mkRegFile(0, 12'hfff);
   Reg#(Bool) interrupted <- mkReg(False);
   Reg#(Bool) interruptCleared <- mkReg(False);
   Reg#(Bit#(32)) getWordCount <- mkReg(0);
   Reg#(Bit#(32)) putWordCount <- mkReg(0);
   Reg#(Bit#(32)) underflowCount <- mkReg(0);

   rule interrupted_rule;
       interrupted <= responseFifo.notEmpty;
   endrule
   rule reset_interrupt_cleared_rule if (!interrupted);
       interruptCleared <= False;
   endrule

   method Action put(Bit#(12) addr, Bit#(32) v);
       if (addr == 12'h000 && v[0] == 1'b1 && interrupted)
       begin
           interruptCleared <= True;
       end
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
           begin
               v[0] = interrupted ? 1'd1 : 1'd0 ;
               v[16] = responseFifo.notFull ? 1'd1 : 1'd0;
           end
           if (addr == 12'h00c)
               v = 32'h02142011;
           if (addr == 12'h010)
               v = dutWrapper.reqCount;
           if (addr == 12'h014)
               v = dutWrapper.respCount;
           if (addr == 12'h018)
               v = underflowCount;
           if (addr == 12'h020)
               v = putWordCount;
           if (addr == 12'h024)
               v = getWordCount;
           return v;
         end
       else
           begin
               let v = 32'h050a050a;
               if (responseFifo.notEmpty)
               begin
                   let r = responseFifo.first(); 
                   if (r matches tagged Valid .b) begin
                       v = b;
                       responseFifo.deq;
                       getWordCount <= getWordCount + 1;
                   end
               end
               else
               begin
                   underflowCount <= underflowCount + 1;
               end
               return v;
           end
   endmethod

   method Bit#(1) error();
       return 0;
   endmethod

   method Bit#(1) interrupt();
       if (rf.sub(12'h04)[0] == 1'd1 && !interruptCleared)
           return interrupted ? 1'd1 : 1'd0;
       else
           return 1'd0;
   endmethod

   interface AxiMasterWrite axiw = dutWrapper.axiw;
   interface AxiMasterWrite axir = dutWrapper.axir;
endmodule
