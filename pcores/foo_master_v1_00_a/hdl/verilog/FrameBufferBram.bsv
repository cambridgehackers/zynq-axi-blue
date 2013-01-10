
// Copyright (c) 2013 Nokia, Inc.

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

import NrccSyncBRAM::*;
import BRAMFIFO::*;
import GetPut::*;
import FIFOF::*;
import SpecialFIFOs::*;
import AxiMasterSlave::*;
import FrameBuffer::*;

Integer bytesperpixel = 4;

interface FrameBufferBram;
    method Bool running();
    method Action start(FrameBufferConfig fbc);
    method Action startLine();
    interface AxiMasterRead#(64) axir;
    interface AxiMasterWrite#(64,8) axiw;
    interface BRAM#(Bit#(12), Bit#(64)) buffer;
endinterface

module mkFrameBufferBram#(Clock displayClk, Reset displayRst)(FrameBufferBram);
    Reg#(FrameBufferConfig) fbc <- mkReg(FrameBufferConfig {base: 0, lines: 0, pixels: 0, stridebytes: 0});
    Reg#(Bool) runningReg <- mkReg(False);

    let burstCount = 32;
    let bytesPerWord = 8;
    let busWidth = bytesPerWord * 8;
    let bytesPerPixel = 4;
    let pixelsPerWord = bytesPerWord / bytesPerPixel;

    Reg#(Bit#(32)) lineAddrReg <- mkReg(0); // address of start of line
    Reg#(Bit#(32)) readAddrReg <- mkReg(0); // next address to read
    Reg#(Bit#(32)) readLimitReg <- mkReg(0); // address of end of line
    Reg#(Bit#(12)) pixelCountReg <- mkReg(0);
    Reg#(Bit#(12)) lineCountReg <- mkReg(0);
    
    AxiMaster#(64,8) nullAxiMaster <- mkNullAxiMaster();

    Clock clk <- exposeCurrentClock ;
    Reset rst <- exposeCurrentReset ;
    SyncBRAM#(Bit#(12), Bit#(64)) syncBRAM <- mkSyncBRAM( 4096, displayClk, displayRst, clk, rst );
    Reg#(Bit#(12)) pixelCountReg2 <- mkReg(0);

    method Bool running();
        return runningReg;
    endmethod

    method Action start(FrameBufferConfig newConfig);
        if (!runningReg)
        begin
            fbc <= newConfig;
            lineAddrReg <= newConfig.base;
            readAddrReg <= 0; // indicates have not received first hsync pulse
            Bit#(32) pixelCount32 = extend(newConfig.pixels);
            readLimitReg <= newConfig.base + pixelCount32 * bytesPerPixel;
            lineCountReg <= newConfig.lines;
            pixelCountReg <= newConfig.pixels;
            pixelCountReg2 <= 0;
            runningReg <= True;
        end
    endmethod

    method Action startLine();
        if (runningReg)
        begin
            let lineAddr = lineAddrReg;
            let readLimit = readLimitReg;
            let lineCount = lineCountReg;
            if (readAddrReg == 0) // if not the first line
            begin
                lineAddr = lineAddr + extend(fbc.stridebytes);
                readLimit = readLimit + extend(fbc.stridebytes);
                lineCount = lineCount - 1;
            end

            lineAddrReg <= lineAddr;
            readAddrReg <= lineAddr;
            readLimitReg <= readLimit;
            lineCountReg <= lineCount;

            pixelCountReg2 <= 0;

            if (lineCount == 0)
                runningReg <= False;
        end
    endmethod

   interface AxiMasterRead axir;
       method ActionValue#(Bit#(32)) readAddr() if (runningReg && readAddrReg != 0 && readAddrReg < readLimitReg);
           readAddrReg <= readAddrReg + burstCount*bytesPerWord;
           return readAddrReg;
       endmethod
       method Bit#(8) readBurstLen();
           return burstCount-1;
       endmethod
       method Bit#(3) readBurstWidth();
           if (busWidth == 32)
               return 3'b010; // 3'b010: 32bit, 3'b011: 64bit, 3'b100: 128bit
           else if (busWidth == 64)
               return 3'b011;
           else
               return 3'b100;
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
           return 0;
       endmethod
       method Action readData(Bit#(64) data, Bit#(2) resp, Bit#(1) last, Bit#(1) id);
           let newPixelCount = pixelCountReg2 + pixelsPerWord;
           pixelCountReg2 <= newPixelCount;

           syncBRAM.portB.write(pixelCountReg2 / pixelsPerWord, data);
       endmethod
   endinterface

   interface AxiMasterWrite axiw = nullAxiMaster.write;
   interface NrccBRAM buffer = syncBRAM.portA;
endmodule