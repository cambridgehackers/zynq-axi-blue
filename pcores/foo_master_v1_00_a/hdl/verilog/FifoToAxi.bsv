import RegFile::*;
import FIFOF::*;

interface AxiMasterRead;
   method ActionValue#(Bit#(32)) readAddr();
   method Bit#(8) readBurstLen();
   method Bit#(3) readBurstWidth();
   method Bit#(2) readBurstType();  // drive with 2'b
   method Bit#(3) readBurstProt(); // drive with 4'b000
   method Bit#(4) readBurstCache(); // drive with 4'b0011

   method Action readData(Bit#(32) data, Bit#(2) resp, Bit#(1) last);
endinterface

interface AxiMasterWrite;
   method ActionValue#(Bit#(32)) writeAddr();
   method Bit#(8) writeBurstLen();
   method Bit#(3) writeBurstWidth();
   method Bit#(2) writeBurstType();  // drive with 2'b
   method Bit#(3) writeBurstProt(); // drive with 4'b000
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
   interface AxiMasterWrite axi;
   method Action enq(Bit#(32) value);
   method ActionValue#(Bit#(32)) getResponse();
endinterface

module mkFifoToAxi(FifoToAxi);

   Reg#(Bool) enabledReg <- mkReg(False);
   Reg#(Bit#(32)) baseReg <- mkReg(0);
   Reg#(Bit#(32)) boundsReg <- mkReg(0);
   Reg#(Bit#(32)) thresholdReg <- mkReg(0);
   Reg#(Bit#(32)) ptrReg <- mkReg(0);
   FIFOF#(Bit#(32)) fifo <- mkSizedFIFOF(32);
   Reg#(Bit#(8)) burstCountReg <- mkReg(0);
   FIFOF#(Bit#(2)) responseFifo <- mkSizedFIFOF(32);

   rule updateBurstCount if (!fifo.notFull());
       burstCountReg <= 8'd8 - 1;
   endrule

   method Bool notEmpty();
       return ptrReg != baseReg;
   endmethod

   method Bool notFull();
       return ptrReg != boundsReg;
   endmethod

   interface Reg base;
       method Action _write(Bit#(32) base);
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
       method Action _write(Bit#(32) bounds);
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

   interface AxiMasterWrite axi;

       method ActionValue#(Bit#(32)) writeAddr() if (burstCountReg != 0 && enabledReg);
           let ptrValue = ptrReg;
           ptrReg <= ptrReg + 4;
           burstCountReg <= burstCountReg - 1;
           return ptrReg;
       endmethod
       method Bit#(8) writeBurstLen();
           return burstCountReg;
       endmethod
       method Bit#(3) writeBurstWidth();
           return 3'b010; // 'b010: 32bit, 'b011: 64bit
       endmethod
       method Bit#(2) writeBurstType();  // drive with 2'b
           return 2'b01; // increment address
       endmethod
       method Bit#(3) writeBurstProt(); // drive with 3'b000
           return 3'b000;
       endmethod
       method Bit#(4) writeBurstCache(); // drive with 4'b0011
           return 4'b0011;
       endmethod

       method ActionValue#(Bit#(32)) writeData();
           let d = fifo.first;
           fifo.deq;
           return d;
       endmethod
       method Bit#(4) writeDataByteEnable();
           return 4'b1111;
       endmethod
       method Bit#(1) writeLastDataBeat(); // last data beat
           if (burstCountReg == 4)
               return 1'b1;
           else
               return 1'b0;
       endmethod

       method Action writeResponse(Bit#(2) responseCode);
           responseFifo.enq(responseCode);
       endmethod
   endinterface

   method Action enq(Bit#(32) value);
       fifo.enq(value);
   endmethod
   method ActionValue#(Bit#(32)) getResponse() if (responseFifo.notEmpty);
       responseFifo.deq;
       return extend(responseFifo.first);
   endmethod

endmodule
