
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
import BRAMFIFO::*;
import FIFOF::*;
import SpecialFIFOs::*;

interface AxiMasterRead#(type busWidth);
   method ActionValue#(Bit#(32)) readAddr();
   method Bit#(8) readBurstLen();
   method Bit#(3) readBurstWidth();
   method Bit#(2) readBurstType();  // drive with 2'b01
   method Bit#(3) readBurstProt(); // drive with 3'b000
   method Bit#(4) readBurstCache(); // drive with 4'b0011
   method Bit#(1) readId();

   method Action readData(Bit#(busWidth) data, Bit#(2) resp, Bit#(1) last, Bit#(1) id);
endinterface

interface AxiMasterWrite#(type busWidth, type busWidthBytes);
   method ActionValue#(Bit#(32)) writeAddr();
   method Bit#(8) writeBurstLen();
   method Bit#(3) writeBurstWidth();
   method Bit#(2) writeBurstType();  // drive with 2'b01
   method Bit#(3) writeBurstProt(); // drive with 3'b000
   method Bit#(4) writeBurstCache(); // drive with 4'b0011
   method Bit#(1) writeId();

   method ActionValue#(Bit#(busWidth)) writeData();
   method Bit#(busWidthBytes) writeDataByteEnable();
   method Bit#(1) writeLastDataBeat(); // last data beat
   method Action writeResponse(Bit#(2) responseCode, Bit#(1) id);
endinterface

interface AxiMaster#(type busWidth, type busWidthBytes);
   interface AxiMasterRead#(busWidth) read;
   interface AxiMasterWrite#(busWidth, busWidthBytes) write;
endinterface

interface AxiSlaveRead#(type busWidth, type busWidthBytes);
   method Action readAddr(Bit#(32) addr, Bit#(8) burstLen, Bit#(3) burstWidth,
                          Bit#(2) burstType, Bit#(3) burstProt, Bit#(4) burstCache);

   method ActionValue#(Bit#(busWidth)) readData(Bit#(busWidthBytes) byteEnable, Bit#(1) last);
   // method Action readResponse(Bit#(2) responseCode);
endinterface

interface AxiSlaveWrite#(type busWidth, type busWidthBytes);
   method Action writeAddr(Bit#(32) addr, Bit#(8) burstLen, Bit#(3) burstWidth,
                           Bit#(2) burstType, Bit#(3) burstProt, Bit#(4) burstCache);
   method ActionValue#(Bit#(2)) writeData(Bit#(busWidth) data, Bit#(busWidthBytes) byteEnable, Bit#(1) last);
endinterface

interface AxiSlave#(type busWidth, type busWidthBytes);
   interface AxiSlaveRead#(busWidth, busWidthBytes) read;
   interface AxiSlaveWrite#(busWidth, busWidthBytes) write;
endinterface

interface AxiMasterServer#(type busWidth, type busWidthBytes);
   method Action readAddr(Bit#(32) addr, Bit#(8) numWords);
   method ActionValue#(Bit#(busWidth)) readData();

   method Action writeAddr(Bit#(32) addr, Bit#(8) numWords);
   method Action writeData(Bit#(busWidth) data);
   method ActionValue#(Bit#(2)) writeResponse();

   interface AxiMaster#(busWidth,busWidthBytes) axi;
endinterface

typedef struct {
    Bit#(32) addr;
    Bit#(8) numWords;
} AddrBurst deriving (Bits);

module mkAxiMasterServer(AxiMasterServer#(busWidth,busWidthBytes)) provisos(Div#(busWidth,8,busWidthBytes),Add#(1,a,busWidth));
   Reg#(Bit#(32)) wAddrReg <- mkReg(0);
   Reg#(Bit#(1)) writeIdReg <- mkReg(0);
   Reg#(Bit#(1)) readIdReg <- mkReg(0);
   //FIFOF#(AddrBurst) raddrFifo <- mkSizedBypassFIFOF(4);
   FIFOF#(AddrBurst) raddrFifo <- mkSizedBRAMFIFOF(8);
   FIFOF#(Bit#(busWidth)) rfifo <- mkSizedBRAMFIFOF(32);
   FIFOF#(Bit#(busWidth)) wfifo <- mkSizedBRAMFIFOF(32);
   FIFOF#(Bit#(2)) bfifo <- mkSizedBRAMFIFOF(8);
   Reg#(Bit#(8)) wBurstCountReg <- mkReg(0);
   Reg#(Bool) wAddressPresented <- mkReg(False);
   FIFOF#(Bit#(2)) axiBrespFifo <- mkSizedBRAMFIFOF(32);

   method Action readAddr(Bit#(32) addr, Bit#(8) numWords);
       //$display("readAddr addr %h burstCountReg %d", addr, numWords);
       raddrFifo.enq(AddrBurst { addr: addr, numWords: numWords});
   endmethod

   method ActionValue#(Bit#(busWidth)) readData() if (rfifo.notEmpty);
       //$display("axiMaster.readData %h", rfifo.first);
       rfifo.deq;
       return rfifo.first;
   endmethod

   method Action writeAddr(Bit#(32) addr, Bit#(8) numWords) if (wBurstCountReg == 0);
       wAddrReg <= addr;
       wBurstCountReg <= numWords;
       wAddressPresented <= False;
   endmethod

   method Action writeData(Bit#(busWidth) data) if (wfifo.notFull);
       wfifo.enq(data);
   endmethod
   method ActionValue#(Bit#(2)) writeResponse() if (bfifo.notEmpty);
       bfifo.deq;
       return bfifo.first;
   endmethod

   interface AxiMaster axi;
       interface AxiMasterWrite write;
           method ActionValue#(Bit#(32)) writeAddr() if (wBurstCountReg != 0 && !wAddressPresented);
               wAddressPresented <= True;
               writeIdReg <= writeIdReg + 1;
               return wAddrReg;
           endmethod
           method Bit#(8) writeBurstLen();
               return wBurstCountReg-1;
           endmethod
           method Bit#(3) writeBurstWidth();
               if (valueOf(busWidth) == 32)
                   return 3'b010; // 3'b010: 32bit, 3'b011: 64bit, 3'b100: 128bit
               else
                   return 3'b011;
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
           method Bit#(1) writeId();
               return writeIdReg;
           endmethod

           method ActionValue#(Bit#(busWidth)) writeData() if (wBurstCountReg != 0 && wfifo.notEmpty);
               wBurstCountReg <= wBurstCountReg - 1;

               let d = wfifo.first;
               wfifo.deq;
               return d;
           endmethod
           method Bit#(busWidthBytes) writeDataByteEnable();
               return maxBound;
           endmethod
           method Bit#(1) writeLastDataBeat(); // last data beat
               return (wBurstCountReg == 8'd1) ? 1'b1 : 1'b0;
           endmethod

           method Action writeResponse(Bit#(2) responseCode, Bit#(1) id) if (bfifo.notFull);
               bfifo.enq(responseCode);
           endmethod
       endinterface

       interface AxiMasterRead read;
           method ActionValue#(Bit#(32)) readAddr();
               raddrFifo.deq();
               readIdReg <= readIdReg + 1;
               return raddrFifo.first().addr;
           endmethod
           method Bit#(8) readBurstLen();
               return raddrFifo.first().numWords-1;
           endmethod
           method Bit#(3) readBurstWidth();
               if (valueOf(busWidth) == 32)
                   return 3'b010; // 3'b010: 32bit, 3'b011: 64bit, 3'b100: 128bit
               else
                   return 3'b011;
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
           method Bit#(1) readId();
               return readIdReg;
           endmethod
           method Action readData(Bit#(busWidth) data, Bit#(2) resp, Bit#(1) last, Bit#(1) id) if (rfifo.notFull);
	       //$display("axi.read.readData %h bc %d", data, rBurstCountReg);
               rfifo.enq(data);
           endmethod
       endinterface
   endinterface
endmodule

module mkAxiSlaveFromRegFile#(RegFile#(Bit#(21), Bit#(busWidth)) rf)
                             (AxiSlave#(busWidth, busWidthBytes)) provisos(Div#(busWidth,8,busWidthBytes));
    Reg#(Bit#(21)) readAddrReg <- mkReg(0);
    Reg#(Bit#(21)) writeAddrReg <- mkReg(0);
    Reg#(Bit#(8)) readBurstCountReg <- mkReg(0);
    Reg#(Bit#(8)) writeBurstCountReg <- mkReg(0);

    Bool verbose = False;
    interface AxiSlaveRead read;
        method Action readAddr(Bit#(32) addr, Bit#(8) burstLen, Bit#(3) burstWidth,
                               Bit#(2) burstType, Bit#(3) burstProt, Bit#(4) burstCache) if (readBurstCountReg == 0);
            if (verbose) $display("axiSlave.read.readAddr %h bc %d", addr, burstLen+1);			       
            readAddrReg <= truncate(addr/fromInteger(valueOf(busWidthBytes)));                               
            readBurstCountReg <= burstLen+1;
        endmethod

        method ActionValue#(Bit#(busWidth)) readData(Bit#(busWidthBytes) byteEnable, Bit#(1) last) if (readBurstCountReg > 0);
            let data = rf.sub(readAddrReg);
            if (verbose) $display("axiSlave.read.readData %h %h %d", readAddrReg, data, readBurstCountReg);
            readBurstCountReg <= readBurstCountReg - 1;
            readAddrReg <= readAddrReg + 1;
            return data;
        endmethod
    endinterface

    interface AxiSlaveWrite write;
       method Action writeAddr(Bit#(32) addr, Bit#(8) burstLen, Bit#(3) burstWidth,
                               Bit#(2) burstType, Bit#(3) burstProt, Bit#(4) burstCache) if (writeBurstCountReg == 0);
           if (verbose) $display("axiSlave.write.writeAddr %h bc %d", addr, burstLen+1);
           writeAddrReg <= truncate(addr/fromInteger(valueOf(busWidthBytes)));
           writeBurstCountReg <= burstLen+1;
       endmethod

       method ActionValue#(Bit#(2)) writeData(Bit#(busWidth) data, Bit#(busWidthBytes) byteEnable, Bit#(1) last) if (writeBurstCountReg > 0);
           if (verbose) $display("writeData %h %h %d", writeAddrReg, data, writeBurstCountReg);
           rf.upd(writeAddrReg, data);
           writeAddrReg <= writeAddrReg + 1;
           writeBurstCountReg <= writeBurstCountReg - 1;
            if (verbose) $display("axiSlave.write.writeData %h %h %d", writeAddrReg, data, writeBurstCountReg);
           return 2'b00;
       endmethod
    endinterface
endmodule

module mkAxiSlaveRegFile(AxiSlave#(busWidth, busWidthBytes)) provisos(Div#(busWidth,8,busWidthBytes));
       RegFile#(Bit#(21), Bit#(busWidth)) rf <- mkRegFileFull();
       AxiSlave#(busWidth, busWidthBytes) axiSlave <- mkAxiSlaveFromRegFile(rf);
       return axiSlave;
endmodule

module mkAxiSlaveRegFileLoad#(String fileName)(AxiSlave#(busWidth, busWidthBytes)) provisos(Div#(busWidth,8,busWidthBytes));
       RegFile#(Bit#(21), Bit#(busWidth)) rf <- mkRegFileFullLoad(fileName);
       AxiSlave#(busWidth, busWidthBytes) axiSlave <- mkAxiSlaveFromRegFile(rf);
       return axiSlave;
endmodule

module mkMasterSlaveConnection#(AxiMasterWrite#(busWidth, busWidthBytes) axiw,
                                AxiMasterRead#(busWidth) axir,
                                AxiSlave#(busWidth, busWidthBytes) axiSlave)();
       
    Reg#(Bit#(8)) writeBurstCountReg <- mkReg(0);
    Bool verbose = False;

    rule readAddr;
        Bit#(32) addr <-axir.readAddr;
        let burstLen = axir.readBurstLen;
        let burstWidth = axir.readBurstWidth;
        let burstType = axir.readBurstType;
        let burstProt = axir.readBurstProt;
        let burstCache = axir.readBurstCache;
        axiSlave.read.readAddr(addr, burstLen, burstWidth, burstType, burstProt, burstCache);
	if (verbose) $display("        MasterSlaveConnection.readAddr %h %d", addr, burstLen+1);
    endrule
    rule readData;
        let data <- axiSlave.read.readData(maxBound, 0);
        axir.readData(data, 2'b00, 0, 0);
        if (verbose) $display("        MasterSlaveConnection.readData %h", data);
    endrule
    rule writeAddr;
        Bit#(32) addr <- axiw.writeAddr;
        let burstLen = axiw.writeBurstLen;
        let burstWidth = axiw.writeBurstWidth;
        let burstType = axiw.writeBurstType;
        let burstProt = axiw.writeBurstProt;
        let burstCache = axiw.writeBurstCache;
        axiSlave.write.writeAddr(addr, burstLen, burstWidth, burstType, burstProt, burstCache);
        if (verbose) $display("        MasterSlaveConnection.writeAddr %h %d", addr, burstLen+1);
    endrule
    rule writeData;
        let data <- axiw.writeData;
        let byteEnable = axiw.writeDataByteEnable;
        let last = axiw.writeLastDataBeat;
        let response <- axiSlave.write.writeData(data, byteEnable, last);
        axiw.writeResponse(response, 0);
        if (verbose) $display("        MasterSlaveConnection.writeData %h", data);
    endrule
endmodule
