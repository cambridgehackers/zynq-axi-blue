import RegFile::*;
import FIFOF::*;

interface AxiMasterRead;
   method ActionValue#(Bit#(32)) readAddr();
   method Bit#(8) readBurstLen();
   method Bit#(3) readBurstWidth();
   method Bit#(2) readBurstType();  // drive with 2'b01
   method Bit#(3) readBurstProt(); // drive with 3'b000
   method Bit#(4) readBurstCache(); // drive with 4'b0011

   method Action readData(Bit#(32) data, Bit#(2) resp, Bit#(1) last);
endinterface

interface AxiMasterWrite;
   method ActionValue#(Bit#(32)) writeAddr();
   method Bit#(8) writeBurstLen();
   method Bit#(3) writeBurstWidth();
   method Bit#(2) writeBurstType();  // drive with 2'b01
   method Bit#(3) writeBurstProt(); // drive with 3'b000
   method Bit#(4) writeBurstCache(); // drive with 4'b0011

   method ActionValue#(Bit#(32)) writeData();
   method Bit#(4) writeDataByteEnable();
   method Bit#(1) writeLastDataBeat(); // last data beat
   method Action writeResponse(Bit#(2) responseCode);
endinterface

interface FifoToAxi;
   interface Reg#(Bit#(32)) base;
   interface Reg#(Bit#(32)) bounds;
   interface Reg#(Bit#(32)) threshold;
   interface Reg#(Bool) enabled;
   interface Reg#(Bit#(32)) ptr;
   method Bool aboveThreshold();
   method Bool notEmpty();
   method Bool notFull();

   method Bit#(32) readStatus(Bit#(12) addr);

   interface AxiMasterWrite axi;
   method Action enq(Bit#(32) value);
   method ActionValue#(Bit#(32)) getResponse();
endinterface

interface FifoFromAxi;
   interface Reg#(Bit#(32)) base;
   interface Reg#(Bit#(32)) bounds;
   interface Reg#(Bit#(32)) threshold;
   interface Reg#(Bool) enabled;
   interface Reg#(Bit#(32)) ptr;
   method Bool aboveThreshold();
   method Bool notEmpty();
   method Bool notFull();

   method Bit#(32) readStatus(Bit#(12) addr);

   interface AxiMasterRead axi;

   method Action deq();
   method Bit#(32) first();
   method ActionValue#(Bit#(32)) getResponse();
endinterface

module mkFifoToAxi(FifoToAxi);

   Reg#(Bool) enabledReg <- mkReg(False);
   Reg#(Bit#(32)) baseReg <- mkReg(0);
   Reg#(Bit#(32)) boundsReg <- mkReg(0);
   Reg#(Bit#(32)) thresholdReg <- mkReg(0);
   Reg#(Bit#(32)) ptrReg <- mkReg(0);
   Reg#(Bit#(32)) addrsBeatCount <- mkReg(0);
   Reg#(Bit#(32)) wordsWrittenCount <- mkReg(0);
   Reg#(Bit#(32)) wordsEnqCount <- mkReg(0);
   Reg#(Bit#(32)) lastDataBeatCount <- mkReg(0);
   FIFOF#(Bit#(32)) dfifo <- mkSizedFIFOF(8);
   Reg#(Bit#(8)) burstCountReg <- mkReg(0);
   Reg#(Bool) operationInProgress <- mkReg(False);
   FIFOF#(Bit#(2)) axiBrespFifo <- mkSizedFIFOF(32);

   rule updateBurstCount if (!dfifo.notFull() && !operationInProgress && enabledReg);
       burstCountReg <= 8'd8;
       operationInProgress <= True;
   endrule

   method Bool notEmpty();
       return ptrReg != baseReg;
   endmethod

   method Bool notFull();
       return ptrReg != boundsReg;
   endmethod

   interface Reg base;
       method Action _write(Bit#(32) base) if (!operationInProgress);
          if (!enabledReg) begin
              baseReg <= base;
              ptrReg <= base;
          end
       endmethod
       method Bit#(32) _read();
          return baseReg;
       endmethod
   endinterface

   interface Reg bounds;
       method Action _write(Bit#(32) bounds) if (!operationInProgress);
          if (!enabledReg) begin
              boundsReg <= bounds;
          end
       endmethod
       method Bit#(32) _read();
          return boundsReg;
       endmethod
   endinterface

   interface Reg threshold = thresholdReg;
   interface Reg enabled = enabledReg;

   method Bool aboveThreshold;
       return ptrReg >= thresholdReg;
   endmethod

   method Bit#(32) readStatus(Bit#(12) addr);
   Bit#(32) v = 32'h02142042;
   if (addr == 12'h000)
       v =  baseReg;
   else if (addr == 12'h004)
       v = boundsReg;
   else if (addr == 12'h008)
       v = ptrReg;
   else if (addr == 12'h00C)
       v = extend(burstCountReg);
   else if (addr == 12'h010)
       v = enabledReg ? 32'heeeeeeee : 32'hdddddddd;
   else if (addr == 12'h014)
   begin
       v = 0;
       v[3:0] = axiBrespFifo.notEmpty ? 4'h1 : 4'he;
       v[15:12] = axiBrespFifo.notFull ? 4'h0 : 4'hf;
   end
   else if (addr == 12'h018)
   begin
       v = 0;
       v[3:0] = dfifo.notEmpty ? 4'h1 : 4'he;
       v[15:12] = dfifo.notFull ? 4'h0 : 4'hf;
   end
   else if (addr == 12'h01C)
   begin
       v[31:24] = 8'hbb;
       v[23:16] = operationInProgress ? 8'haa : 8'h11;
       v[15:0] = extend(burstCountReg);
   end
   else if (addr == 12'h020)
       v = wordsEnqCount;
   else if (addr == 12'h024)
       v = addrsBeatCount;
   else if (addr == 12'h028)
       v = wordsWrittenCount;
   else if (addr == 12'h02C)
       v = lastDataBeatCount;
   return v;
   endmethod

   interface AxiMasterWrite axi;
       method ActionValue#(Bit#(32)) writeAddr() if (operationInProgress);
           addrsBeatCount <= addrsBeatCount + 1;
           let ptrValue = ptrReg;
           return ptrReg;
       endmethod
       method Bit#(8) writeBurstLen();
           return burstCountReg-1;
       endmethod
       method Bit#(3) writeBurstWidth();
           return 3'b010; // 3'b010: 32bit, 3'b011: 64bit, 3'b100: 128bit
       endmethod
       method Bit#(2) writeBurstType();  // drive with 2'b01 increment address
           return 2'b01; // increment address
       endmethod
       method Bit#(3) writeBurstProt(); // drive with 3'b000
           return 3'b000;
       endmethod
       method Bit#(4) writeBurstCache(); // drive with 4'b0011
           return 4'b0011;
       endmethod

       method ActionValue#(Bit#(32)) writeData() if (operationInProgress && dfifo.notEmpty);
           ptrReg <= ptrReg + 4;
           if (burstCountReg == 8'd1 || burstCountReg == 8'd0)
           begin
               operationInProgress <= False;
               lastDataBeatCount <= lastDataBeatCount + 1;
           end
           burstCountReg <= burstCountReg - 1;
           wordsWrittenCount <= wordsWrittenCount + 1;

           let d = dfifo.first;
           dfifo.deq;
           return d;
       endmethod
       method Bit#(4) writeDataByteEnable();
           return 4'b1111;
       endmethod
       method Bit#(1) writeLastDataBeat(); // last data beat
           if (burstCountReg == 8'd1)
               return 1'b1;
           else
               return 1'b0;
       endmethod

       method Action writeResponse(Bit#(2) responseCode) if (axiBrespFifo.notFull);
           if (responseCode != 2'b00)
               axiBrespFifo.enq(responseCode);
       endmethod
   endinterface

   method Action enq(Bit#(32) value);
       wordsEnqCount <= wordsEnqCount + 1;
       dfifo.enq(value);
   endmethod
   method ActionValue#(Bit#(32)) getResponse() if (axiBrespFifo.notEmpty);
       axiBrespFifo.deq;
       return extend(axiBrespFifo.first);
   endmethod

endmodule

module mkFifoFromAxi(FifoFromAxi);

   Reg#(Bool) enabledReg <- mkReg(False);
   Reg#(Bit#(32)) baseReg <- mkReg(0);
   Reg#(Bit#(32)) boundsReg <- mkReg(0);
   Reg#(Bit#(32)) thresholdReg <- mkReg(0);
   Reg#(Bit#(32)) ptrReg <- mkReg(0);
   Reg#(Bit#(32)) addrsBeatCount <- mkReg(0);
   Reg#(Bit#(32)) wordsReceivedCount <- mkReg(0);
   Reg#(Bit#(32)) wordsDeqCount <- mkReg(0);
   Reg#(Bit#(32)) lastDataBeatCount <- mkReg(0);
   FIFOF#(Bit#(32)) rfifo <- mkSizedFIFOF(32);
   Reg#(Bit#(8)) burstCountReg <- mkReg(0);
   Reg#(Bool) operationInProgress <- mkReg(False);
   FIFOF#(Bit#(2)) axiRrespFifo <- mkSizedFIFOF(32);

   rule updateBurstCount if (rfifo.notFull && !operationInProgress && enabledReg && ptrReg < boundsReg);
       burstCountReg <= 8'd8;
       operationInProgress <= True;
   endrule

   method Bool notEmpty();
   // fixme
       return ptrReg != baseReg;
   endmethod

   method Bool notFull();
   // fixme
       return ptrReg != boundsReg;
   endmethod

   interface Reg base;
       method Action _write(Bit#(32) base) if (!operationInProgress);
          if (!enabledReg) begin
              baseReg <= base;
              ptrReg <= base;
          end
       endmethod
       method Bit#(32) _read();
          return baseReg;
       endmethod
   endinterface

   interface Reg bounds;
       method Action _write(Bit#(32) bounds) if (!operationInProgress);
          if (!enabledReg) begin
              boundsReg <= bounds;
          end
       endmethod
       method Bit#(32) _read();
          return boundsReg;
       endmethod
   endinterface

   interface Reg threshold = thresholdReg;
   interface Reg enabled = enabledReg;

   method Bool aboveThreshold;
   // fixme
       return ptrReg >= thresholdReg;
   endmethod

   method Bit#(32) readStatus(Bit#(12) addr);
       Bit#(32) v = 32'h02142042;
       if (addr == 12'h000)
           v =  baseReg;
       else if (addr == 12'h004)
           v = boundsReg;
       else if (addr == 12'h008)
           v = ptrReg;
       else if (addr == 12'h00C)
           v = extend(burstCountReg);
       else if (addr == 12'h010)
           v = enabledReg ? 32'heeeeeeee : 32'hdddddddd;
       else if (addr == 12'h014)
       begin
           v = 0;
           v[3:0] = axiRrespFifo.notEmpty ? 4'h1 : 4'he;
           v[15:12] = axiRrespFifo.notFull ? 4'h0 : 4'hf;
       end
       else if (addr == 12'h018)
       begin
           v = 0;
           v[3:0] = rfifo.notEmpty ? 4'h1 : 4'he;
           v[15:12] = rfifo.notFull ? 4'h0 : 4'hf;
       end
       else if (addr == 12'h01C)
       begin
           v[31:24] = 8'hbb;
           v[23:16] = operationInProgress ? 8'haa : 8'h11;
           v[15:0] = extend(burstCountReg);
       end
       else if (addr == 12'h020)
           v = wordsDeqCount;
       else if (addr == 12'h024)
           v = addrsBeatCount;
       else if (addr == 12'h028)
           v = wordsReceivedCount;
       else if (addr == 12'h02C)
           v = lastDataBeatCount;
       return v;
   endmethod

   interface AxiMasterRead axi;
       method ActionValue#(Bit#(32)) readAddr() if (operationInProgress);
           addrsBeatCount <= addrsBeatCount + 1;
           let ptrValue = ptrReg;
           return ptrReg;
       endmethod
       method Bit#(8) readBurstLen();
           return burstCountReg-1;
       endmethod
       method Bit#(3) readBurstWidth();
           return 3'b010; // 3'b010: 32bit, 3'b011: 64bit, 3'b100: 128bit
       endmethod
       method Bit#(2) readBurstType();  // drive with 2'b01
           return 2'b01;
       endmethod
       method Bit#(3) readBurstProt(); // drive with 3'b000
           return 3'b000;
       endmethod
       method Bit#(4) readBurstCache(); // drive with 4'b0011
           return 4'b0011;
       endmethod
       method Action readData(Bit#(32) data, Bit#(2) resp, Bit#(1) last) if (rfifo.notFull && operationInProgress);
           if (resp == 2'b00)
           begin
               burstCountReg <= burstCountReg - 1;
               ptrReg <= ptrReg + 4;
               rfifo.enq(data);
               wordsReceivedCount <= wordsReceivedCount + 1;
           end
           else
           begin
               axiRrespFifo.enq(resp);
           end

           if (resp != 2'b00 || last == 1'b1 || burstCountReg == 8'd1 || burstCountReg == 8'd0)
               operationInProgress <= False;

           if (last == 1'b1)
               lastDataBeatCount <= lastDataBeatCount + 1;
       endmethod
   endinterface

   method Action deq();
       wordsDeqCount <= wordsDeqCount + 1;
       rfifo.deq();
   endmethod
   method Bit#(32) first();
       return rfifo.first;
   endmethod

   method ActionValue#(Bit#(32)) getResponse() if (axiRrespFifo.notEmpty);
       axiRrespFifo.deq;
       return extend(axiRrespFifo.first);
   endmethod

endmodule
