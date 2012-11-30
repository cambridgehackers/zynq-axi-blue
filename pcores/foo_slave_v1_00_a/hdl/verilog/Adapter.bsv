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
endinterface
   
interface FromBit32#(type a);
   method Action enq(Bit#(32) v);
   method a first();
   method Action deq();
   method Bool notEmpty();
endinterface

module mkToBit32(ToBit32#(a))
   provisos(Bits#(a,asz),
	    Add#(32,asz,asz32));
   
   Bit#(32) size = fromInteger(valueOf(asz));
   Bit#(32) max  = (size >> 5) + ((size[4:0] == 0) ? 0 : 1)-1;
   
   FIFOF#(Bit#(asz))   fifo <- mkUGFIFOF();
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
               
   method Bool notEmpty();
       return fifo.notEmpty;
   endmethod
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
   
   method Bool notEmpty();
       return fifo.notEmpty;
   endmethod
endmodule
