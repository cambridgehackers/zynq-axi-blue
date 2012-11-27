import FIFO           ::*;
import FIFOF          ::*;
import GetPut         ::*;

function Bit#(a) rtruncate(Bit#(b) x) provisos(Add#(k,a,b));
   match {.v,.*} = split(x);
   return v;
endfunction

interface ToBit32#(type a);
   interface Put#(a) put;
   interface Get#(Maybe#(Bit#(32))) get;
endinterface
   
interface FromBit32#(type a);
   interface Put#(Bit#(32)) put;          
   interface Get#(a) get;
endinterface

module mkToBit32(ToBit32#(a))
   provisos(Bits#(a,asz),
	    Add#(32,asz,asz32));
   
   Bit#(32) size = fromInteger(valueOf(asz));
   Bit#(32) max  = (size >> 5) + ((size[4:0] == 0) ? 0 : 1)-1;
   
   FIFOF#(Bit#(asz))   fifo <- mkUGFIFOF();
   Reg#(Bit#(32))      count <- mkReg(0);

   interface Put put;
       method Action put(a val) if (fifo.notFull);
          fifo.enq(pack(val));   
       endmethod
   endinterface

   interface Get get;
       method ActionValue#(Maybe#(Bit#(32))) get();
           if (fifo.notEmpty)
           begin 
               let val = fifo.first();
               Bit#(asz32) vx = zeroExtend(val >> (32 * count));
               Bit#(32) x = vx[31:0];

               if (count == max)
                  begin 
                     count <= 0;
                     fifo.deq();
                  end
               else
                  begin
                     count <= count + 1;
                  end   

               return tagged Valid x;
           end
           else
           begin
               return tagged Invalid;
           end
       endmethod
   endinterface
               
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
   
   interface Put put;
       method Action put(Bit#(32) x) if (fifo.notFull);
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
   endinterface
   
   interface Get get;
       method ActionValue#(a) get if (fifo.notEmpty());
           fifo.deq;
           return unpack(fifo.first);
       endmethod
   endinterface
   
endmodule
