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

interface BRAM#(type idx_type, type data_type);
  method Action readAddr(idx_type idx);
  method data_type readData();
  method Action	write(idx_type idx, data_type data);
endinterface

interface SyncBRAMBVI#(type idx_type, type data_type);
  method Action portAReadAddr(idx_type idx);
  method data_type portAReadData();
  method Action	portAWrite(idx_type idx, data_type data);

  method Action portBReadAddr(idx_type idx);
  method data_type portBReadData();
  method Action	portBWrite(idx_type idx, data_type data);
endinterface

interface SyncBRAM#(type idx_type, type data_type);
    interface BRAM#(idx_type, data_type) portA;
    interface BRAM#(idx_type, data_type) portB;
endinterface

import "BVI" NRCCBRAM2 = module mkSyncBRAMBVI#(Integer memsize, Clock clkA, Reset rstA, Clock clkB, Reset rstB) 
  //interface:
              (SyncBRAMBVI#(idx_type, data_type))
  provisos
          (Bits#(idx_type, idx), 
	   Bits#(data_type, data),
	   Literal#(idx_type));

  parameter ADDR_WIDTH = valueof(idx);
  parameter DATA_WIDTH = valueof(data);
  parameter MEMSIZE = memsize;
  parameter PIPELINED = 0;

  input_clock (CLKA, (*inhigh*)GATE) = clkA;
  input_clock (CLKB, (*inhigh*)GATE) = clkB;
  default_clock clkA;
  input_reset (RSTA_N) clocked_by (clkA) = rstA;
  input_reset (RSTB_N) clocked_by (clkB) = rstB;
  default_reset rstA;
  method DOA portAReadData() ready (DRA) clocked_by(clkA) reset_by (rstA);
  
  method portAReadAddr(RADDRA) enable(ENA) clocked_by(clkA) reset_by (rstA);
  method portAWrite(WADDRA, DIA) enable(WEA) clocked_by(clkA) reset_by (rstA);

  method DOB portBReadData() ready (DRB) clocked_by(clkB) reset_by (rstB);
  
  method portBReadAddr(RADDRB) enable(ENB) clocked_by(clkB) reset_by (rstB);
  method portBWrite(WADDRB, DIB) enable(WEB) clocked_by(clkB) reset_by (rstB);

  schedule portAReadAddr  CF (portAReadData);
  schedule portAReadData  CF (portAReadAddr, portAReadData, portAWrite);
  schedule portAWrite     CF (portAReadData);
  
  schedule portAReadAddr  C portAReadAddr;
  //schedule portAReadData  C portAReadData;
  schedule portAWrite     C portAWrite;
  schedule portAReadAddr  C portAWrite;
  schedule portAWrite     C portAReadAddr;

  schedule portBReadAddr  CF (portBReadData);
  schedule portBReadData  CF (portBReadAddr, portBReadData, portBWrite);
  schedule portBWrite     CF (portBReadData);

  schedule portBReadAddr  C portBReadAddr;
  //schedule portBReadData  C portBReadData;
  schedule portBWrite     C portBWrite;
  schedule portBReadAddr  C portBWrite;
  schedule portBWrite     C portBReadAddr;

endmodule

module mkSyncBRAM#(Integer memsize, Clock clkA, Reset resetA, Clock clkB, Reset resetB)
                  (SyncBRAM#(idx_type, data_type))
                  provisos(Bits#(idx_type, idxbits),
                           Literal#(idx_type),
                           Bits#(data_type, databits),
                           Literal#(data_type),
                           Add#(1, z, databits));
    SyncBRAMBVI#(idx_type, data_type) syncBRAMBVI <- mkSyncBRAMBVI(memsize, clkA, resetA, clkB, resetB);

    interface BRAM portA;
        method Action readAddr(idx_type idx);
            syncBRAMBVI.portAReadAddr(idx);
        endmethod
        method data_type readData();
            return syncBRAMBVI.portAReadData();
        endmethod
        method Action write(idx_type idx, data_type data);
            syncBRAMBVI.portAWrite(idx, data);
        endmethod
    endinterface
    interface BRAM portB;
        method Action readAddr(idx_type idx);
            syncBRAMBVI.portBReadAddr(idx);
        endmethod
        method data_type readData();
            return syncBRAMBVI.portBReadData();
        endmethod
        method Action write(idx_type idx, data_type data);
            syncBRAMBVI.portBWrite(idx, data);
        endmethod
    endinterface
endmodule
