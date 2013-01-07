
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
    Initial,
    FirstWordSent,
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

    Reg#(State) state <- mkReg(Initial);

    Bit#(64) request = extend(pack(tagged StartFrameBuffer$Request { base: 32'h10000 }));
    rule startIt1 if (state == Initial);
        requestFifo.enq(request[31:0]);
        state <= FirstWordSent;
    endrule
    rule startIt2 if (state == FirstWordSent);
        requestFifo.enq(request[63:32]);
        state <= Running;
    endrule

endmodule
