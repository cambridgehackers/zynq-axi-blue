
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
import Clocks::*;
import TypesAndInterfaces::*;
import AxiStream::*;
import FifoToAxi::*;
import HDMI::*;
import TbAxi::*;

interface Timer#(type width);
    method Action start();
    method Action stop();
    method Bool running();
    method Bit#(width) elapsed();
endinterface

module mkTimer(Timer#(width));
   Reg#(Bit#(width)) timerReg <- mkReg(0);
   Reg#(Bool) runningReg <- mkReg(False);

   rule incr if (runningReg);
       timerReg <= timerReg + 1;
   endrule
   method Action start();
       runningReg <= True;
       timerReg <= 0;
   endmethod
   method Action stop();
       runningReg <= False;
   endmethod
   method Bool running();
       return runningReg;
   endmethod
   method Bit#(width) elapsed();
       return timerReg;
   endmethod
endmodule

module mkDUT#(Clock hdmi_clk)(DUT);

    let busWidthBytes=8;
    FifoToAxi#(64,8) fifoToAxi <-mkFifoToAxi();
    FifoFromAxi#(64) fifoFromAxi <-mkFifoFromAxi();
    Reg#(Maybe#(Bit#(32))) resultReg <- mkReg(tagged Invalid);
    Reg#(Maybe#(Bit#(32))) result2Reg <- mkReg(tagged Invalid);
    FIFOF#(Bit#(32)) fifoStatusFifo <- mkSizedFIFOF(16);
    FIFOF#(Bit#(32)) fromFifoStatusFifo <- mkSizedFIFOF(16);

    Reg#(Bool) testReg <- mkReg(False);
    Reg#(Bool) testCompletedReg <- mkReg(False);
    Reg#(Bit#(32)) writeCountReg <- mkReg(0);
    Reg#(Bit#(32)) readCountReg <- mkReg(0);
    Reg#(Bit#(32)) numWordsReg <- mkReg(0);
    Reg#(Bit#(32)) valueReg <- mkReg(13);
    Reg#(Bit#(32)) testResultReg <- mkReg(0);

    Timer#(32) writeTimer <- mkTimer();
    Timer#(32) readTimer <- mkTimer();
    Reg#(Bool) writeQueuedSent <- mkReg(False);
    Reg#(Bool) readCompletedSent <- mkReg(False);
    Reg#(Bool) firstReadSent <- mkReg(False);

    Reset reset <- exposeCurrentReset;

    Reset hdmi_reset <- mkAsyncReset(2, reset, hdmi_clk);

    SyncFIFOIfc#(Bit#(32)) patternFifo <- mkSyncFIFOFromCC(1, hdmi_clk);
    HdmiTestPatternGenerator hdmiTpg <- mkHdmiTestPatternGenerator(clocked_by hdmi_clk, reset_by hdmi_reset, patternFifo);


    AxiTester axiTester <- mkAxiTester(fifoToAxi, fifoFromAxi, 1204);

    rule enqTestData if (testReg && writeCountReg < numWordsReg);
        let v = valueReg * 7;
        valueReg <= v;
        writeCountReg <= writeCountReg + 1;
        fifoToAxi.enq(extend(v));
    endrule

    rule enableRead if (testReg && writeCountReg == numWordsReg && !fifoFromAxi.enabled);
        fifoFromAxi.enabled <= True;
    endrule

    rule receiveTestData if (testReg && writeCountReg == numWordsReg
                             && readCountReg < numWordsReg
                             && fifoFromAxi.notEmpty);
        let v = fifoFromAxi.first;
        testResultReg <= truncate(v);
        fifoFromAxi.deq;
        if (readCountReg >= numWordsReg-1)
        begin
            testReg <= False;
            testCompletedReg <= True;
        end
        readCountReg <= readCountReg + 1;
    endrule

    method Action setBase(Bit#(32) base);
        fifoToAxi.base <= base;
    endmethod
    method Action setBounds(Bit#(32) bounds);
        fifoToAxi.bounds <= bounds;
    endmethod
    method Action setThreshold(Bit#(32) threshold);
        fifoToAxi.threshold <= threshold;
        fifoFromAxi.threshold <= threshold;
    endmethod
    method Action setEnabled(Bit#(32) enabled);
        fifoToAxi.enabled <= (enabled != 32'd0) ? True : False;
    endmethod
    method Action enq(Bit#(32) v);
        fifoToAxi.enq(extend(v));
    endmethod

    method Action readFifoStatus(Bit#(12) addr);
        fifoStatusFifo.enq(fifoToAxi.readStatus(addr));
    endmethod
    method ActionValue#(Bit#(32)) fifoStatus() if (fifoStatusFifo.notEmpty);
        fifoStatusFifo.deq;
        return fifoStatusFifo.first;
    endmethod

    method ActionValue#(Bit#(32)) axiResponse();
        let r <- fifoToAxi.getResponse();
        return r;
    endmethod

    method Action configure(Bit#(32) v);
        fifoToAxi.oneBeatAddress <= (v[0] == 1) ? True : False;
        fifoFromAxi.oneBeatAddress <= (v[1] == 1) ? True : False;
        fifoToAxi.thirtyTwoBitTransfer <= (v[2] == 1) ? True : False;
        fifoFromAxi.thirtyTwoBitTransfer <= (v[3] == 1) ? True : False;
    endmethod

    method Action readRange(Bit#(32) addr);
        fifoFromAxi.base <= addr;
        fifoFromAxi.bounds <= addr + 8*busWidthBytes;
        fifoFromAxi.enabled <= True;
    endmethod
    
    method Action readFromFifoStatus(Bit#(12) addr);
        fromFifoStatusFifo.enq(fifoFromAxi.readStatus(addr));
    endmethod

    method ActionValue#(Bit#(32)) fromFifoStatus() if (fromFifoStatusFifo.notEmpty);
        fromFifoStatusFifo.deq;
        return fromFifoStatusFifo.first;
    endmethod

    method ActionValue#(Bit#(32)) axirResponse();
        let r <- fifoFromAxi.getResponse();
        return r;
    endmethod

    method ActionValue#(Bit#(32)) readValue() if (!testReg);
         let v = fifoFromAxi.first;
         fifoFromAxi.deq;
         return truncate(v);
    endmethod

    method Action runTest(Bit#(32) numWords) if (!testReg);
        fifoToAxi.enabled <= True;
        fifoFromAxi.enabled <= False;
        fifoFromAxi.base <= fifoToAxi.base;
        fifoToAxi.bounds <= fifoToAxi.base + numWords*busWidthBytes;
        fifoFromAxi.bounds <= fifoToAxi.base + numWords*busWidthBytes;

        testReg <= True;
        testCompletedReg <= False;
        writeCountReg <= 0;
        readCountReg <= 0;
        numWordsReg <= numWords;
        writeQueuedSent <= False;
        firstReadSent <= False;
        readCompletedSent <= False;

        writeTimer.start();
        readTimer.start();
    endmethod

    method ActionValue#(Bit#(32)) writeQueued() if (testReg
                                                    && writeCountReg == numWordsReg
                                                    && !writeQueuedSent);
        writeQueuedSent <= True;
        return writeTimer.elapsed;
    endmethod
    method ActionValue#(Bit#(32)) firstRead() if (testReg
                                                  && writeCountReg == numWordsReg
                                                  && fifoFromAxi.notEmpty
                                                  && !firstReadSent);
        firstReadSent <= True;
        let v = readTimer.elapsed;
        v[31:24] = truncate(readCountReg);
        v[23] = readTimer.running ? 1 : 0;
        v[22] = fifoFromAxi.enabled ? 1 : 0;
        return v;
    endmethod

    method ActionValue#(Bit#(32)) writeCompleted() if (testReg
                                                       && writeCountReg == numWordsReg
                                                       && writeTimer.running()
                                                       && !fifoToAxi.notEmpty);
        writeTimer.stop();
        let v = writeTimer.elapsed; 
        v[31] = !fifoToAxi.notEmpty ? 1 : 0;
        return v;
    endmethod

    method ActionValue#(Bit#(32)) readCompleted() if (testReg
                                                      && readCountReg == numWordsReg
                                                      && !readCompletedSent);
        readTimer.stop();
        readCompletedSent <= True;
        return readTimer.elapsed;
    endmethod

    method ActionValue#(Bit#(32)) testCompleted() if (testCompletedReg);
        testCompletedReg <= False;
        testReg <= False;
        return testResultReg;
    endmethod

    method Action runTest2(Bit#(32) numWords);
        axiTester.start(fifoToAxi.base, numWords);
        writeTimer.start();
    endmethod

    method ActionValue#(Bit#(32)) test2Completed();
        let v <- axiTester.completed;
        let t = writeTimer.elapsed();
        writeTimer.stop();
        return t;
    endmethod

    method Action setPatternReg(Bit#(32) yuv422);
        patternFifo.enq(yuv422);
    endmethod

    interface AxiMasterWrite axiw = fifoToAxi.axi;
    interface AxiMasterWrite axir = fifoFromAxi.axi;
    interface HDMI hdmi = hdmiTpg.hdmi;
endmodule
