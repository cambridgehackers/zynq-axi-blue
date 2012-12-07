
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

import FIFO           ::*;
import FIFOF          ::*;
import GetPut         ::*;

function Bit#(a) rtruncate(Bit#(b) x) provisos(Add#(k,a,b));
   match {.v,.*} = split(x);
   return v;
endfunction

interface ToBit32#(type a);
   method Action enq(a v);          
   method Maybe#(Bit#(32)) first;
   method Action deq();
   method Bool notEmpty();
   method Bool notFull();
endinterface
   
interface FromBit32#(type a);
   method Action enq(Bit#(32) v);
   method a first();
   method Action deq();
   method Bool notEmpty();
   method Bool notFull();
endinterface

module mkToBit32(ToBit32#(a))
   provisos(Bits#(a,asz),
	    Add#(32,asz,asz32));
   
   Bit#(32) size = fromInteger(valueOf(asz));
   Bit#(32) max  = (size >> 5) + ((size[4:0] == 0) ? 0 : 1)-1;
   
   FIFOF#(Bit#(asz))   fifo <- mkUGSizedFIFOF(32);
   Reg#(Bit#(32))      count <- mkReg(0);

   method Action enq(a val) if (fifo.notFull);
      fifo.enq(pack(val));   
   endmethod

   method Maybe#(Bit#(32)) first();
    if (fifo.notEmpty)
       begin 
           let val = fifo.first();
           Bit#(asz32) vx = zeroExtend(val >> (32 * count));
           Bit#(32) x = vx[31:0];
           return tagged Valid x;
       end
    else
       begin
           return tagged Invalid;
       end
   endmethod
   method Action deq();
     if (fifo.notEmpty)
     begin
       if (count == max)
          begin 
             count <= 0;
             fifo.deq();
          end
       else
          begin
             count <= count + 1;
          end   
     end
   endmethod
               
   method Bool notEmpty = fifo.notEmpty;
   method Bool notFull = fifo.notFull;
endmodule

module mkFromBit32(FromBit32#(a))
   provisos(Bits#(a,asz),
	    Add#(32,asz,asz32));

   Bit#(32) size   = fromInteger(valueOf(asz));
   Bit#(5)  offset = size[4:0];
   Bit#(32) max    = (size >> 5) + ((offset == 0) ? 0 : 1) -1;
   
   FIFOF#(Bit#(asz))   fifo <- mkUGFIFOF();
   Reg#(Bit#(asz))    buff <- mkReg(0);
   Reg#(Bit#(32))    count <- mkReg(0);   
   
   method Action enq(Bit#(32) x) if (fifo.notFull);
      Bit#(asz32) concatedvalue = {x,buff};
      Bit#(asz) newval = rtruncate(concatedvalue);
      if (count == max)
         begin 
            count <= 0;
            buff  <= ?;
            Bit#(asz) longval = truncate({x,buff} >> ((offset==0) ? 32'd32 : zeroExtend(offset)));
            fifo.enq(longval);
         end
      else
         begin
            count <= count+1;
            buff  <= newval; 
         end
   endmethod
   
   method a first if (fifo.notEmpty());
       return unpack(fifo.first);
   endmethod

   method Action deq if (fifo.notEmpty());
       fifo.deq;
   endmethod
   
   method Bool notEmpty() = fifo.notEmpty;
   method Bool notFull() = fifo.notFull;
endmodule
