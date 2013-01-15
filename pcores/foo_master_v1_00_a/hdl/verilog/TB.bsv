
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

import Clocks::*;
import FIFOF::*;

import Adapter::*;
import AxiMasterSlave::*;
import DUTWrapper::*;

typedef enum {
    State[12],
    Running
} State deriving (Bits,Eq);

module mkTb();
    Clock clock <- exposeCurrentClock;
    Reset reset <- exposeCurrentReset;

    FromBit32#(DutRequest) requestFifo <- mkFromBit32();
    ToBit32#(DutResponse) responseFifo <- mkToBit32();
    DUTWrapper dutWrapper <- mkDUTWrapper(clock, requestFifo, responseFifo);

    AxiSlave#(64,8) axiSlave0 <- mkAxiSlaveRegFile;
    AxiSlave#(64,8) axiSlave1 <- mkAxiSlaveRegFile;

    mkMasterSlaveConnection(dutWrapper.axiw0, dutWrapper.axir0, axiSlave0);
    mkMasterSlaveConnection(dutWrapper.axiw1, dutWrapper.axir1, axiSlave1);

    Reg#(State) state <- mkReg(State0);

    Bit#(64) request0 = extend(pack(BeginTranslationTable$Request { index: 0 }));
    Bit#(64) request1 = extend(pack(AddTranslationEntry$Request { address: 20'hc0000, length: 12'h3f4 }));
    Bit#(64) request2 = extend(pack(AddTranslationEntry$Request { address: 20'hb0000, length: 12'h3f5 }));
    Bit#(64) request3 = extend(pack(tagged StartFrameBuffer$Request { base: 32'h10000 }));
    rule startIt0 if (state == State0);
        requestFifo.enq(request0[31:0]);
        state <= State1;
    endrule
    rule startIt1 if (state == State1);
        requestFifo.enq(request0[63:32]);
        state <= State2;
    endrule

    rule startIt2 if (state == State2);
        requestFifo.enq(request1[31:0]);
        state <= State3;
    endrule
    rule startIt3 if (state == State3);
        requestFifo.enq(request1[63:32]);
        state <= State4;
    endrule

    rule startIt4 if (state == State4);
        requestFifo.enq(request2[31:0]);
        state <= State5;
    endrule
    rule startIt5 if (state == State5);
        requestFifo.enq(request2[63:32]);
        state <= State6;
    endrule

    rule startIt6 if (state == State6);
        requestFifo.enq(request3[31:0]);
        state <= State7;
    endrule
    rule startIt7 if (state == State7);
        requestFifo.enq(request3[63:32]);
        state <= State8;
    endrule

endmodule
