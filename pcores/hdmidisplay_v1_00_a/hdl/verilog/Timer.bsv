// Copyright (c) 2012,2013 Nokia, Inc.

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
