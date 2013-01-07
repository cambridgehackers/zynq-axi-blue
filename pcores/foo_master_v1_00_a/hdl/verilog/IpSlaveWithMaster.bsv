
// Copyright (c) 2012 Nokia, Inc.

// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use, copy,
// modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
// BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import RegFile::*;
import Adapter::*;
import AxiMasterSlave::*;
import HDMI::*;
import FifoToAxi::*;
import DUTWrapper::*;
import GetPut::*;
import Connectable::*;
import Clocks::*;

interface IpSlaveWithMaster;
   method Action put(Bit#(12) addr, Bit#(32) v);
   method ActionValue#(Bit#(32)) get(Bit#(12) addr);
   method Bit#(1) error();
   method Bit#(1) interrupt();
   interface AxiMasterWrite#(64,8) axiw0;
   interface AxiMasterRead#(64) axir0;
   interface AxiMasterWrite#(64,8) axiw1;
   interface AxiMasterRead#(64) axir1;
   interface HDMI hdmi;
endinterface

module mkIpSlaveWithMaster#(Clock hdmi_ref_clk)(IpSlaveWithMaster);

   FromBit32#(DutRequest) requestFifo <- mkFromBit32();
   ToBit32#(DutResponse) responseFifo <- mkToBit32();
   DUTWrapper dutWrapper <- mkDUTWrapper(hdmi_ref_clk, requestFifo, responseFifo);

   RegFile#(Bit#(12), Bit#(32)) rf <- mkRegFile(0, 12'h00f);
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
           if (addr == 12'h008)
               v = 32'h02142011;
           if (addr == 12'h00c)
               v = dutWrapper.junkReqCount;
           if (addr == 12'h010)
               v = dutWrapper.reqCount;
           if (addr == 12'h014)
               v = dutWrapper.respCount;
           if (addr == 12'h018)
               v = underflowCount;
           if (addr == 12'h020)
               v = dutWrapper.vsyncPulseCount;
           if (addr == 12'h024)
               v = dutWrapper.frameCount;
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

   interface AxiMasterWrite axiw0 = dutWrapper.axiw0;
   interface AxiMasterWrite axir0 = dutWrapper.axir0;
   interface AxiMasterWrite axiw1 = dutWrapper.axiw1;
   interface AxiMasterWrite axir1 = dutWrapper.axir1;
   interface HDMI hdmi = dutWrapper.hdmi;
endmodule
