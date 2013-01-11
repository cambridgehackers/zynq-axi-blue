
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

import BRAMFIFO::*;
import GetPut::*;
import FIFOF::*;
import SpecialFIFOs::*;
import AxiMasterSlave::*;

Integer bytesperpixel = 4;

typedef struct {
    Bit#(32) base;
    Bit#(11) lines;
    Bit#(12) pixels;
    Bit#(12) stridebytes;
} FrameBufferConfig deriving (Bits);

interface FrameBuffer;
    method Bool running();
    method Action start(FrameBufferConfig fbc);
    method Action startLine();
    interface Get#(Bit#(64)) pixels;
    interface AxiMasterWrite#(64,8) axiw;
    interface AxiMasterRead#(64) axir;
endinterface

module mkFrameBuffer(FrameBuffer);
    Reg#(FrameBufferConfig) fbc <- mkReg(FrameBufferConfig {base: 0, lines: 0, pixels: 0, stridebytes: 0});
    Reg#(Bool) runningReg <- mkReg(False);

    Reg#(Bit#(32)) lineAddrReg <- mkReg(0); // address of start of line
    Reg#(Bit#(32)) readAddrReg <- mkReg(0); // next address to read
    Reg#(Bit#(12)) pixelCountReg <- mkReg(0);
    Reg#(Bit#(11)) lineCountReg <- mkReg(0);
    
    AxiMasterServer#(64,8) axiMaster <- mkAxiMasterServer;

    let burstCount = 32;
    let bytesPerWord = 8;
    let bytesPerPixel = 4;
    let pixelsPerWord = bytesPerWord / bytesPerPixel;

    rule issueRead if (runningReg);
        axiMaster.readAddr(readAddrReg, burstCount);
        let pixelCount = pixelCountReg - burstCount*pixelsPerWord;
        if (pixelCount == 0)
        begin
            let lineCount = lineCountReg - 1;
            lineCountReg <= lineCount;
            if (lineCount == 0)
            begin
                $display("issuing last read of frame");
                runningReg <= False;
            end
            else
            begin
                pixelCountReg <= fbc.pixels;
                let lineAddr = lineAddrReg + extend(fbc.stridebytes / bytesPerWord);
                lineAddrReg <= lineAddr;
                readAddrReg <= lineAddr;
            end
        end
        else
        begin
            pixelCountReg <= pixelCount;
            readAddrReg <= readAddrReg + burstCount*bytesPerWord;
        end
    endrule

    method Bool running();
        return runningReg;
    endmethod

    method Action start(FrameBufferConfig newConfig) if (!runningReg);
        fbc <= newConfig;
        lineAddrReg <= newConfig.base;
        readAddrReg <= newConfig.base;
        lineCountReg <= newConfig.lines;
        pixelCountReg <= newConfig.pixels;
        runningReg <= True;
    endmethod

    method Action startLine();
    endmethod

    interface Get pixels;
        method ActionValue#(Bit#(64)) get();
            Bit#(64) pixels <- axiMaster.readData();
            return pixels;
        endmethod
    endinterface

    interface AxiMasterWrite axiw = axiMaster.axi.write;
    interface AxiMasterRead axir = axiMaster.axi.read;
endmodule
