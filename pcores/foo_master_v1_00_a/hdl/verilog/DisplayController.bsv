
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

import FrameBuffer::*;
import FrameBufferBram::*;
import HDMI::*;

interface HdmiDisplayController;
    method Action start(FrameBufferConfig fbc);
    SyncPulseIfc vsyncPulse;
    SyncPulseIfc hsyncPulse;
    interface AxiMasterWrite#(64,8) axiw;
    interface AxiMasterRead#(64) axir;
    interface HDMI hdmi;
endinterface

module mkHdmiDisplayController#(Clock parent_clock)((HdmiDisplayController);
    Clock clock <- exposeCurrentClock;
    Reset reset <- exposeCurrentReset;

    SyncPulseIfc vsyncHandshake <- mkSyncHandshake(clock, reset, parent_clock);
    SyncPulseIfc hsyncHandshake <- mkSyncHandshake(clock, reset, parent_clock);
    SyncFIFOIfc#(HdmiCommand) commandFifo <- mkSyncFIFO(2, clock, reset, parent_clock);

    Reg#(Bit#(32)) shadowFrameBufferBase <- mkReg(0);
    FrameBufferBram frameBuffer <- mkFrameBufferBram(clock, reset);

    HdmiTestPatternGenerator hdmiTpg <- mkHdmiTestPatternGenerator(commandFifo, frameBuffer.buffer,
                                                                   vsyncPulse, hsyncPulse);

    rule vsync if (hdmiTpg.vsync);
        vsyncHandshake.send(True);
        vsyncPulseCountReg <= vsyncPulseCountReg + 1;
        if (shadowFrameBufferBase != 0)
        begin
            $display("frame started");
            frameCountReg <= frameCountReg + 1;
            FrameBufferConfig fbc;
            fbc.base = shadowFrameBufferBase;
            fbc.pixels = 1920;
            fbc.lines = 1080;
            fbc.stridebytes = 1920*fromInteger(bytesperpixel);
            frameBuffer.start(fbc);
            commandFifo.enq(tagged TestPattern {enabled: False});
        end
    endrule

    rule hsync if (hdmiTpg.hsync);
        hsyncHandshake.send(True);
        if (frameBuffer.running)
            frameBuffer.startLine();
    endrule

    method Action startFrameBuffer(Bit#(32) base);
        $display("startFrameBuffer %h", base);
        shadowFrameBufferBase <= base;
    endmethod

    SyncPulseIfc vsyncPulse = vsyncHandshake;
    SyncPulseIfc hsyncPulse = hsyncHandshake;
    interface AxiMasterWrite axiw1 = frameBuffer.axiw;
    interface AxiMasterWrite axir1 = frameBuffer.axir;
    interface HDMI hdmi = hdmiTpg.hdmi;

endmodule