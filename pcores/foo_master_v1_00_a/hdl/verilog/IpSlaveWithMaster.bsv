import RegFile::*;
import FifoToAxi::*;

interface IpSlaveWithMaster;
   method Action put(Bit#(12) addr, Bit#(32) v);
   method ActionValue#(Bit#(32)) get(Bit#(12) addr);
   method Bit#(1) error();
   method Bit#(1) interrupt();
   interface AxiMasterWrite axi;
endinterface

module mkIpSlaveWithMaster(IpSlaveWithMaster);

   FifoToAxi fifoToAxi <- mkFifoToAxi;

   RegFile#(Bit#(12), Bit#(32)) rf <- mkRegFile(0, 12'hfff);

   Reg#(Bool) thresholdEdgeDetected <- mkReg(False);

   Reg#(Bool) interrupted <- mkReg(False);
   rule fifoAboveThreshold if (!thresholdEdgeDetected && fifoToAxi.aboveThreshold());
       interrupted <= True;
       thresholdEdgeDetected <= True;
   endrule
   rule fifoBelowThreshold if (thresholdEdgeDetected && !fifoToAxi.aboveThreshold());
       thresholdEdgeDetected <= False;
   endrule

   method Action put(Bit#(12) addr, Bit#(32) v);
       if (addr == 12'h000 && v[0] == 1)
           interrupted <= False;
       if (addr < 12'h010)
           rf.upd(addr, v);
       else if (addr == 12'h010)
           fifoToAxi.base <= v;
       else if (addr == 12'h014)
           fifoToAxi.bounds <= v;
       else if (addr == 12'h018)
           fifoToAxi.threshold <= v;
       else
           fifoToAxi.enq(v);
   endmethod
   method ActionValue#(Bit#(32)) get(Bit#(12) addr);
       if (addr < 12'h010)
           return rf.sub(addr);
       else if (addr == 12'h010)
           return fifoToAxi.base;
       else if (addr == 12'h014)
           return fifoToAxi.bounds;
       else if (addr == 12'h018)
           return fifoToAxi.threshold;
       else
           return 32'h5a5aBeef;
   endmethod
   method Bit#(1) error();
       return 0;
   endmethod
   method Bit#(1) interrupt();
       if (rf.sub(12'h04)[0] == 1'd1)
           return interrupted ? 1'b1 : 1'b0; //rf.sub(12'h00)[0];
       else
           return 1'd0;
   endmethod
   interface AxiMasterWrite axi = fifoToAxi.axi;
endmodule
