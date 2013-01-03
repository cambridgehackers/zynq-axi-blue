
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

import AxiMasterSlave::*;
import HDMI::*;
import FifoToAxi::*;

interface DUT;
    method Action setBase(Bit#(32) base);
    method Action setBounds(Bit#(32) bounds);
    method Action setThreshold(Bit#(32) threshold);
    method Action setEnabled(Bit#(32) v);
    method Action enq(Bit#(32) v);

    method Action readFifoStatus(Bit#(12) addr);
    method ActionValue#(Bit#(32)) fifoStatus();
    method ActionValue#(Bit#(32)) axiResponse();

    method Action configure(Bit#(32) v);

    method Action readRange(Bit#(32) addr);
    method Action readFromFifoStatus(Bit#(12) addr);
    method ActionValue#(Bit#(32)) fromFifoStatus();
    method ActionValue#(Bit#(32)) axirResponse();
    method ActionValue#(Bit#(32)) readValue();

    method Action runTest(Bit#(32) numWords);
    method ActionValue#(Bit#(32)) testCompleted();
    method ActionValue#(Bit#(32)) writeQueued();
    method ActionValue#(Bit#(32)) writeCompleted();
    method ActionValue#(Bit#(32)) firstRead();
    method ActionValue#(Bit#(32)) readCompleted();

    method Action runTest2(Bit#(32) base);
    method ActionValue#(Bit#(32)) test2Completed();

    method Action setPatternReg(Bit#(32) yuv422);

    interface AxiMasterWrite#(64,8) axiw;
    interface AxiMasterRead#(64) axir;
    interface HDMI hdmi;
endinterface
