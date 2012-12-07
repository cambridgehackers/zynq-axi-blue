
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

import FifoToAxi::*;
import RegFile::*;
import FIFOF::*;
 
module mkAxiSlaveRegFile(AxiSlave#(busWidth, busWidthBytes)) provisos(Div#(busWidth,8,busWidthBytes));
    RegFile#(Bit#(12), Bit#(busWidth)) rf <- mkRegFile(0, maxBound);
    Reg#(Bit#(12)) readAddrReg <- mkReg(0);
    Reg#(Bit#(12)) writeAddrReg <- mkReg(0);
    Reg#(Bit#(8)) readBurstCountReg <- mkReg(0);
    Reg#(Bit#(8)) writeBurstCountReg <- mkReg(0);

    Bool verbose = False;
    interface AxiSlaveRead read;
        method Action readAddr(Bit#(32) addr, Bit#(8) burstLen, Bit#(3) burstWidth,
                               Bit#(2) burstType, Bit#(3) burstProt, Bit#(4) burstCache) if (readBurstCountReg == 0);
            readAddrReg <= truncate(addr);                               
            readBurstCountReg <= burstLen+1;            
        endmethod

        method ActionValue#(Bit#(busWidth)) readData(Bit#(busWidthBytes) byteEnable, Bit#(1) last) if (readBurstCountReg > 0);
            let data = rf.sub(readAddrReg);
            if (verbose) $display("readData %h %h %d", readAddrReg, data, readBurstCountReg);
            readBurstCountReg <= readBurstCountReg - 1;
            readAddrReg <= readAddrReg + fromInteger(valueOf(busWidthBytes));
            return data;
        endmethod
    endinterface

    interface AxiSlaveWrite write;
       method Action writeAddr(Bit#(32) addr, Bit#(8) burstLen, Bit#(3) burstWidth,
                               Bit#(2) burstType, Bit#(3) burstProt, Bit#(4) burstCache) if (writeBurstCountReg == 0);
           writeAddrReg <= truncate(addr);
           writeBurstCountReg <= burstLen+1;
       endmethod

       method ActionValue#(Bit#(2)) writeData(Bit#(busWidth) data, Bit#(busWidthBytes) byteEnable, Bit#(1) last) if (writeBurstCountReg > 0);
           if (verbose) $display("writeData %h %h %d", writeAddrReg, data, writeBurstCountReg);
           rf.upd(writeAddrReg, data);
           writeAddrReg <= writeAddrReg + fromInteger(valueOf(busWidthBytes));
           writeBurstCountReg <= writeBurstCountReg - 1;
           return 2'b00;
       endmethod
    endinterface
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
        if (verbose) $display("        readAddr %h %d", addr, burstLen+1);
    endrule
    rule readData;
        let data <- axiSlave.read.readData(maxBound, 0);
        axir.readData(data, 2'b00, 0);
        if (verbose) $display("        readData %h", data);
    endrule
    rule writeAddr;
        Bit#(32) addr <- axiw.writeAddr;
        let burstLen = axiw.writeBurstLen;
        let burstWidth = axiw.writeBurstWidth;
        let burstType = axiw.writeBurstType;
        let burstProt = axiw.writeBurstProt;
        let burstCache = axiw.writeBurstCache;
        axiSlave.write.writeAddr(addr, burstLen, burstWidth, burstType, burstProt, burstCache);
        if (verbose) $display("        writeAddr %h %d", addr, burstLen+1);
    endrule
    rule writeData;
        let data <- axiw.writeData;
        let byteEnable = axiw.writeDataByteEnable;
        let last = axiw.writeLastDataBeat;
        let response <- axiSlave.write.writeData(data, byteEnable, last);
        axiw.writeResponse(response);
        if (verbose) $display("        writeData %h", data);
    endrule
endmodule

typedef enum {
        Start,
        EnqWrites,
        WaitForWriteCompletion,
        WaitForReadCompletion,
        TestCompleted,
        Idle
} TbState deriving (Bits, Eq, Bounded, FShow);

module mkTbAxi();

    Bool verbose = False;

    Bit#(32) numWords = 128;
    Bit#(32) busWidth = 64;
    Bit#(32) busWidthBytes = busWidth/8;
    RegFile#(Bit#(32), Bit#(64)) testDataRegFile <- mkRegFile(0, numWords);

    AxiSlave#(64,8) axiSlave <- mkAxiSlaveRegFile;
    FifoToAxi#(64,8) fifoToAxi <- mkFifoToAxi();
    FifoFromAxi#(64) fifoFromAxi <- mkFifoFromAxi();

    mkMasterSlaveConnection(fifoToAxi.axi, fifoFromAxi.axi, axiSlave);

    Reg#(TbState) state <- mkReg(Start);

    Reg#(Bit#(32)) writeAddrReg <- mkReg(0);
    Reg#(Bit#(32)) readAddrReg <- mkReg(0);

    Reg#(Bit#(32)) writeCountReg <- mkReg(0);
    Reg#(Bit#(32)) readCountReg <- mkReg(0);
    Reg#(Bit#(32)) numWordsReg <- mkReg(0);
    Reg#(Bit#(64)) valueReg <- mkReg(13);

    rule start if (state == Start);
        $display("Starting");
        fifoToAxi.enabled <= True;
        fifoFromAxi.enabled <= False;
        writeAddrReg <= 0;
        readAddrReg <= 0;
        writeCountReg <= 0;
        readCountReg <= 0;
        valueReg <= 13;
        numWordsReg <= numWords;

        Bit#(32) base = 0;
        fifoToAxi.base <= base;
        fifoFromAxi.base <= base;
        fifoToAxi.bounds <= fifoToAxi.base + numWords*busWidthBytes;
        fifoFromAxi.bounds <= fifoToAxi.base + numWords*busWidthBytes;

        state <= EnqWrites;
    endrule

    rule enqTestData if (state == EnqWrites && writeCountReg < numWordsReg);
        let v = valueReg * 7;
        valueReg <= v;
        testDataRegFile.upd(writeAddrReg/busWidthBytes, v);
        writeAddrReg <= writeAddrReg + busWidthBytes;
        if (writeCountReg == numWordsReg-1)
            state <= WaitForWriteCompletion;
        writeCountReg <= writeCountReg + 1;
        fifoToAxi.enq(extend(v));
    endrule

    rule waitForWriteCompletion if (state == WaitForWriteCompletion && !fifoToAxi.notEmpty);
        $display("Writes Completed");
        state <= WaitForReadCompletion;
        fifoFromAxi.enabled <= True;
    endrule

    rule waitForReadCompletion if (state == WaitForReadCompletion && fifoFromAxi.notEmpty);
        let data = fifoFromAxi.first;
        fifoFromAxi.deq;
        let testData = testDataRegFile.sub(readAddrReg/busWidthBytes);
        readAddrReg <= readAddrReg + busWidthBytes;

        if (verbose)
            $display("received read data %h %s", data,
                     (data == testData) ? "" : "mismatch");
        else if (data != testData)
            $display("mismatched data %h got %h expected %h", readAddrReg, data, testData);
        readCountReg <= readCountReg + 1;
        if (readCountReg == numWordsReg-1)
            state <= TestCompleted;
    endrule

    rule testCompleted if (state == TestCompleted);
        $display("Test Completed");
        state <= Idle;
    endrule

endmodule
