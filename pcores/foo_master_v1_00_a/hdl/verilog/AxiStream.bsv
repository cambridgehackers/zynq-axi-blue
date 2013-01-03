
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

interface AxiStream;
    method ActionValue#(Bit#(64)) tdata();
    method Bit#(8) tkeep();
    method Bit#(1) tlast();

    method Action fsync(Bit#(1) sync);
    method Bit#(1) fsync_out();
    method Bit#(1) mm2s_buffer_empty();
    method Bit#(1) mm2s_buffer_almost_empty();
endinterface

interface AxiStreamTestPatternGenerator;
    interface AxiStream axis;
endinterface

module mkAxiStreamTestPatternGenerator(AxiStreamTestPatternGenerator);
    // 1920 * 1080
    let blankLines = 45;
    let numberOfLines = 1125;
    let numberOfPixels = 2200;
    let blankPixels = 280;
    Reg#(Bit#(11)) lineCount <- mkReg(0);
    Reg#(Bit#(12)) pixelCount <- mkReg(0);

    rule incrPixelCount;
        if (pixelCount == numberOfPixels-2)
        begin
           pixelCount <= 0; 
           if (lineCount == numberOfLines-2)
               lineCount <= 0;
           else
               lineCount <= lineCount+1;
        end
        else
        begin
            pixelCount <= pixelCount + 1;
        end
    endrule

    let nonBlank = (lineCount > blankLines && pixelCount > blankPixels);
 
    interface AxiStream axis;
        method ActionValue#(Bit#(64)) tdata() if (nonBlank);
            Bit#(32) pixel = { pixelCount[11:4], 24'hffffff };
            return { pixel, pixel };
        endmethod

        method Bit#(8) tkeep();
            return maxBound;
        endmethod
        method Bit#(1) tlast();
	    if (lineCount == numberOfLines-1 && pixelCount == numberOfPixels-2)
	        return 1;
            else
                return 0;
	endmethod

        method Action fsync(Bit#(1) sync);
        endmethod
        method Bit#(1) fsync_out();
            return (numberOfLines < blankLines) ? 1 : 0;
        endmethod
        method Bit#(1) mm2s_buffer_empty();
            return 0;
        endmethod
        method Bit#(1) mm2s_buffer_almost_empty();
            return 0;
        endmethod
    endinterface
endmodule