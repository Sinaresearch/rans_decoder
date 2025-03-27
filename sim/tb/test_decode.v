
`timescale 1ns / 1ns
module test_decode;

reg clk, resetn;

wire [7:0]divider_index;
wire [8:0]slot_adjust_index;
wire [8:0]slot_freqs_index;
wire [8:0]sym_id_index;

wire [31:0]dividerQ;
wire [31:0]slot_adjustQ;
wire [31:0]sym_idQ;
wire [31:0]slot_freqsQ;

wire [31:0]BottomWord;
wire [31:0]ByteIndex;
wire [31:0]EncodedFileSize;
wire [23:0]EncBytes;
wire [7:0]DecodedByte;
wire init;
wire Active;

reg restart;
integer linecount;
integer ptextcount;

initial // Clock generator
  begin
    clk = 0;
    forever #10 clk = !clk;
  end
  
initial	// Test stimulus
  begin
    resetn = 1;
    linecount = 0;
	restart = 0;
	ptextcount = 1;
    #5 resetn = 0;
    #4 resetn = 1;
	#6725 restart = 1;
	linecount = 0;
	#20 restart = 0;
  end

rans_Top dut( // algorithm code which can be put in a chipset.
.clk(clk),
.resetn(resetn),
.divider_index (divider_index),
.slot_adjust_index (slot_adjust_index),
.sym_id_index (sym_id_index),
.slot_freqs_index (slot_freqs_index),
.dividerQ (dividerQ),
.slot_adjustQ (slot_adjustQ),
.sym_idQ (sym_idQ),
.slot_freqsQ (slot_freqsQ),
.ByteIndex(ByteIndex),
.BottomWord(BottomWord),
.EncBytes(EncBytes),
.Result(DecodedByte),
.init(init),
.restart(restart),
.Active(Active)
);
 
ANSTables ans1 (	// tables brought over from the encoder.  
.divider_index (divider_index),
.slot_adjust_index (slot_adjust_index),
.sym_id_index (sym_id_index),
.slot_freqs_index (slot_freqs_index),
.dividerQ (dividerQ),
.slot_adjustQ (slot_adjustQ),
.sym_idQ (sym_idQ),
.slot_freqsQ (slot_freqsQ)
);


EncodedInput f0( // Encoded input data.
.ByteIndex(ByteIndex),
.EncBytes(EncBytes),
.BottomWord(BottomWord),
.EncodedFileSize(EncodedFileSize)
);


  
always @(posedge clk)
begin
    //$display("%d, %d, %d, %d, 0x%x, %d, 0x%x, %c\n", $stime, resetn, clk, init ,BottomWord, ByteIndex, EncBytes, DecodedByte); 
     linecount = linecount + 1;
     $write("%c", DecodedByte);
     if (linecount == 40)
		begin
			linecount = 0;
		end
	  if (Active)
	  begin
		ptextcount = ptextcount + 1;
	  end
	  else
	  begin
		ptextcount = 1;
	  end
end
endmodule    
