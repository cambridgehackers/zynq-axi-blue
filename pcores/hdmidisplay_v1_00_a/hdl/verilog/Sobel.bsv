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

import Vector::*;
import FIFOF::*;
import SpecialFIFOs::*;
import RegFile::*;
import Adapter::*;
import AxiMasterSlave::*;

typedef struct {
    Int#(8) a;
    Int#(8) r;
    Int#(8) g;
    Int#(8) b;
} RGB deriving (Bits);

typedef Vector#(3, Int#(8)) RowWindow;
typedef Vector#(3, RowWindow) Window;
//typedef Vector#(3, Vector#(1920, Int#(8))) LineBuffer;

interface Sobel;
    method Action startSobel(Int#(16) rows, Int#(16) cols, Bit#(32) inter_pix_addr, Bit#(32) out_pix_addr);
    method Action sobelCompleted();
endinterface

interface SobelToplevel;
    method Action startSobel(Int#(16) rows, Int#(16) cols, Bit#(32) inter_pix_addr, Bit#(32) out_pix_addr);
    method Action sobelCompleted();
    interface AxiMasterServer#(64,8) axi;
endinterface

function Int#(8) rgb2y(RGB pixel);
    Int#(16) y = ((66 * extend(pixel.r) + 129 * extend(pixel.g) + 25 * extend(pixel.b) + 128) >> 8) + 16;
    return truncate(y);
endfunction

function RGB sobel_operator(Window window);
    Int#(16) x_weight = 0;
    Int#(16) y_weight = 0;

    Int#(8) x_op[3][3] = {{-1,0,1},
                          {-2,0,2},
                          {-1,0,1}};

    Int#(8) y_op[3][3] =  {{1,2,1},
                           {0,0,0},
                           {-1,-2,-1}};

    //Compute approximation of the gradients in the X-Y direction
    for (Int#(4) i=0; i < 3; i = i+1)
    begin
        for (Int#(4) j = 0; j < 3; j = j+1)
        begin

            // X direction gradient
            x_weight = x_weight + extend(window[i][j] * x_op[i][j]);
      
            // Y direction gradient
            y_weight = y_weight + extend(window[i][j] * y_op[i][j]);
        end
    end
  
    Int#(16) edge_weight = abs(x_weight) + abs(y_weight);

    Int#(16) edge_val = 255-edge_weight;

    //Edge thresholding
    if (edge_val > 200)
        edge_val = 255;
    else if(edge_val < 100)
        edge_val = 0;

    Int#(8) eval = truncate(edge_val);
    RGB pixel = RGB { r: eval, g: eval, b: eval, a: 0 };

    return pixel;
endfunction

module mkSobel#(AxiMasterServer#(64,8) axiMaster)(Sobel);
    Reg#(Bool) runningReg <- mkReg(False);
    In64Out32FIFOF#(RGB) inputFifo <- mkIn64Out32();
    In32Out64FIFOF#(RGB) outputFifo <- mkIn32Out64();
    //FIFOF#(RGB) inputFifo <- mkSizedFIFOF(32);
    //FIFOF#(RGB) outputFifo <- mkSizedFIFOF(32);
    FIFOF#(Int#(16)) rowFifo <- mkSizedFIFOF(16);
    FIFOF#(Int#(16)) colFifo <- mkSizedFIFOF(16);
    Reg#(Int#(16)) colReg <- mkReg(0);
    Reg#(Int#(16)) rowReg <- mkReg(0);
    Reg#(Int#(16)) colsReg <- mkReg(0);
    Reg#(Int#(16)) rowsReg <- mkReg(0);
    Reg#(Bit#(32)) rAddrReg <- mkReg(0);
    Reg#(Bit#(32)) wAddrReg <- mkReg(0);
    Reg#(RGB) tempxReg <- mkRegU;
    Reg#(Int#(8)) tempReg <- mkRegU;
    RegFile#(Int#(16), Vector#(3, Int#(8))) buff_A <- mkRegFile(0, 1920);
    Reg#(Window) buff_C <- mkReg(newVector);

    let fh <- mkReg(InvalidFile);

    Reg#(Bit#(24)) fooCount <- mkReg(0);
    Reg#(Bit#(24)) barCount <- mkReg(0);
    Reg#(Bit#(24)) enqCount <- mkReg(0);
    Reg#(Bit#(24)) deqCount <- mkReg(0);

    rule readAddr if (colReg < colsReg && rowReg < rowsReg
                      && rowFifo.notFull && colFifo.notFull);
        let row = rowReg;
        let col = colReg;
        Bit#(16) colbits = pack(col);
	// read 16 pixels (8 64bit words) in a burst
        if (row < rowsReg && col < colsReg && colbits[3:0] == 0)
	begin
            axiMaster.readAddr(rAddrReg, 8);
	    rAddrReg <= rAddrReg + 8*8;
	end

	if (False)
	begin
	    if (col == colsReg-1)
		$display("Sobel.readAddr row %d col %d foo %d enq %d deq %d",
			 row, col, fooCount, enqCount, deqCount);
        end

        fooCount <= fooCount+1;
        rowFifo.enq(row);
        colFifo.enq(col);

        if (col == colsReg-1)
        begin
            colReg <= 0;
            rowReg <= rowReg + 1;
        end
        else
        begin
            colReg <= colReg + 1;
        end
    endrule

    rule readData if (inputFifo.notFull);
        let v <- axiMaster.readData();
	//$display("readData %h inputFifo.notFull %b", v, inputFifo.notEmpty);
        inputFifo.enq(v);
	enqCount <= enqCount + 2;
    endrule

    rule processInput if (inputFifo.notEmpty &&
                          rowFifo.first < rowsReg
                          && colFifo.first < colsReg
			  );
        let row = rowFifo.first;
        let col = colFifo.first;
        rowFifo.deq;
        colFifo.deq;
	barCount <= barCount + 1;

        RGB pixel = tempxReg;

        Window window = buff_C;
        Int#(8) temp = tempReg;

	//if (True || col == 0 || col == colsReg)
	       //$display("processInput row %d col %d pixel %h", row, col, pixel);

        if (row < rowsReg && col < colsReg)
        begin
            pixel = inputFifo.first;
            inputFifo.deq;
	    deqCount <= deqCount + 1;

	    //if (col == 0 || col == colsReg)
	    //$display("processInput row %d col %d pixel %h", row, col, pixel);
            tempxReg <= pixel;
        end

        Vector#(3, Int#(8)) buff_A_col = buff_A.sub(col);
        Int#(8) y = buff_A_col[2];
        if (col < colsReg)
        begin
            y = rgb2y(pixel);
            temp = buff_A_col[1];
            buff_A.upd(col, shiftInAtN(buff_A_col, y));
        end

        if (col < colsReg)
        begin
            window[0] = shiftInAtN(window[0], y);
            window[1] = shiftInAtN(window[1], temp);
            window[2] = shiftInAtN(window[2], rgb2y(pixel));
        end

        RGB edgeRGB = RGB { r: 0, g: 0, b: 0, a: 0 };
        if ( row > 1 && row < rowsReg && col > 1 && col < colsReg)
            //Sobel operation on the inner portion of the image
            edgeRGB = sobel_operator(window);

        tempReg <= temp;
        buff_C <= window;
        //The output image is offset from the input to account for the line buffer
        if (row > 0 && col > 0)
        begin
            //out_pix[row-1][col-1] = output_pixel;
	    // if (edgeRGB.r != -1)
	    //     $display("edgeRGB %h", edgeRGB);
            outputFifo.enq(edgeRGB);
        end
	if (row == rowsReg-1 && col == colsReg-1
	    )
	begin
	    runningReg <= False;

	    if (False)
	    $display("processInput row %d col %d inputFifo %b outputFifo %b foo %d bar %d enq %d deq %d",
	             row, col,
	             inputFifo.notEmpty, outputFifo.notEmpty,
		     fooCount, barCount, enqCount, deqCount);
            if (False)		     
            $display("    rowFifo %b colFifo %b outputFifo %b nfull",
	             rowFifo.notEmpty, colFifo.notEmpty, outputFifo.notFull);
        end
    endrule

    rule writeAddr if (outputFifo.notEmpty);
        let addr = wAddrReg;
        // update addr
        wAddrReg <= wAddrReg + 8*8;
        axiMaster.writeAddr(addr, 8);
    endrule

    rule writeData if (outputFifo.notEmpty); // fires 8 times for each call to writeAddr
	if (fh != InvalidFile)
	    $fwrite(fh, "%h\n", outputFifo.first);
        axiMaster.writeData(outputFifo.first);
        outputFifo.deq;
    endrule

    rule writeResponse;
        let r <- axiMaster.writeResponse;
    endrule

    method Action startSobel(Int#(16) rows, Int#(16) cols, Bit#(32) inter_pix_addr, Bit#(32) out_pix_addr) if (!runningReg);
        $display("startSobel");
        colReg <= 0;
        rowReg <= 0;
        rowsReg <= rows;
        colsReg <= cols;
        rAddrReg <= inter_pix_addr;
        wAddrReg <= out_pix_addr;
        runningReg <= True;
	let file <- $fopen("output_1080p.hex", "w+");
	fh <= file;
    endmethod
    method Action sobelCompleted() if (!inputFifo.notEmpty
                                       && !outputFifo.notEmpty
                                       && !runningReg);
        $display("sobelCompleted enq %d deq %d", enqCount, deqCount);
	if (fh != InvalidFile)
	   $fclose(fh);
    endmethod

endmodule

module mkSobelToplevel(SobelToplevel);
    AxiMasterServer#(64,8) axiMaster <- mkAxiMasterServer;
    Sobel sobel <- mkSobel(axiMaster);       

    method startSobel = sobel.startSobel;
    method sobelCompleted = sobel.sobelCompleted;
    interface AxiMaster axi = axiMaster;
endmodule

typedef enum {
        TbStart,
        TbRunning,
        TbCompleted
} SobelTbState deriving (Bits, Eq);

module mkSobelTb();
    AxiSlave#(64,8) axiSlave <- mkAxiSlaveRegFileLoad("test_1080p.hex");
    AxiMasterServer#(64,8) axiMaster <- mkAxiMasterServer;
    mkMasterSlaveConnection(axiMaster.axi.write,axiMaster.axi.read,axiSlave);

    Sobel sobel <- mkSobel(axiMaster);
    Reg#(SobelTbState) state <- mkReg(TbStart);

    rule start if (state == TbStart);
        Int#(16) rows = 1080;
        Int#(16) cols = 1920;
        sobel.startSobel(rows, cols, 0, pack(extend(rows)*extend(cols)*4));
        state <= TbRunning;
        $display("started");
    endrule

    rule completed if (state == TbRunning);
        sobel.sobelCompleted;
        state <= TbCompleted;
        $display("completed");
    endrule

endmodule

