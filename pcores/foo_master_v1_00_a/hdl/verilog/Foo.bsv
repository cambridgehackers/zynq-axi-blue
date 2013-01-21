
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

import FIFOF::*;
import BRAMFIFO::*;
import Clocks::*;
import GetPut::*;
import Connectable::*;

import TypesAndInterfaces::*;
import AxiMasterSlave::*;
import AxiStream::*;
import FifoToAxi::*;
import HDMI::*;
import TbAxi::*;
import Timer::*;
import FrameBuffer::*;
import FrameBufferBram::*;
import YUV::*;

function Put#(item_t) syncFifoToPut( SyncFIFOIfc#(item_t) f);
    return (
        interface Put
            method Action put (item_t item);
                f.enq(item);
            endmethod
        endinterface
    );
endfunction

module mkFoo#(Clock hdmi_clk)(Foo);

    let busWidthBytes=8;
    AxiMasterServer#(64, 8) axiMaster0 <- mkAxiMasterServer;
    AxiMasterServer#(64, 8) axiMaster1 <- mkAxiMasterServer;
    AxiMasterServer#(64, 8) axiMaster2 <- mkAxiMasterServer;

    FIFOF#(Bit#(32)) readFifo <- mkSizedBRAMFIFOF(32);

    Clock clock <- exposeCurrentClock;
    Reset reset <- exposeCurrentReset;

    Reset hdmi_reset <- mkAsyncReset(2, reset, hdmi_clk);

    Reg#(Bit#(6)) segmentIndexReg <- mkReg(0);
    Reg#(Bit#(24)) segmentOffsetReg <- mkReg(0);

    rule axiReadData;
         let v <- axiMaster0.readData();
         readFifo.enq(truncate(v));
    endrule

    method Action readRange(Bit#(32) addr);
        axiMaster0.readAddr(addr, 8);
    endmethod
    
    method ActionValue#(Bit#(32)) readValue();
        let v = readFifo.first;
        readFifo.deq;
        return v;
    endmethod
    method Action beginTranslationTable(Bit#(6) index);
        segmentIndexReg <= index;
        segmentOffsetReg <= 0;
    endmethod
    method Action addTranslationEntry(Bit#(20) address, Bit#(12) length);
        //frameBuffer.setSgEntry(segmentIndexReg, segmentOffsetReg, address, extend(length));
        segmentIndexReg <= segmentIndexReg + 1;
        segmentOffsetReg <= segmentOffsetReg + {length,12'd0};
    endmethod

    interface AxiMasterWrite axi0w = axiMaster0.axi.write;
    interface AxiMasterWrite axi0r = axiMaster0.axi.read;
    interface AxiMasterWrite axi1w = axiMaster1.axi.write;
    interface AxiMasterWrite axi1r = axiMaster1.axi.read;
    interface AxiMasterWrite axi2w = axiMaster2.axi.write;
    interface AxiMasterWrite axi2r = axiMaster2.axi.read;
endmodule
