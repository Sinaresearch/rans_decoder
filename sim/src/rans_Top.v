


// Top level for Rans Decoder
// Includes decoder primitive and driver
// No additional functionality, just the interconnect of the decoder and driver.
//

`timescale 1ns / 1ns

module rans_Top(
input wire clk,
input wire resetn,
input wire restart,
output wire [31:0]ByteIndex,
output wire [7:0]divider_index,
output wire [8:0]slot_adjust_index,
output wire [8:0]slot_freqs_index,
output wire [8:0]sym_id_index,
input wire [31:0]dividerQ,
input wire [31:0]slot_adjustQ,
input wire [31:0]slot_freqsQ,
input wire [31:0]sym_idQ,
input wire [31:0]BottomWord,
input wire [23:0]EncBytes,
output wire [7:0]Result,
output wire init,
output wire Active
);

wire [31:0]NewRansState;
wire [31:0]RansState;
wire Valid;
wire [7:0]DecodedByte;

rans_decoder dec1(
.RansState(RansState),
.slot_freqsLookup(slot_freqsQ),
.slot_adjustLookup(slot_adjustQ),
.dividerLookup(dividerQ),
.sym_idLookup(sym_idQ),
.slot_freqsLookupIndex(slot_freqs_index),
.slot_adjustLookupIndex(slot_adjust_index),
.sym_idLookupIndex(sym_id_index),
.dividerLookupIndex(divider_index),
.NewRansState(NewRansState),
.dec_byte(DecodedByte)
);


Fin_and_S_wrapper wr1(
.clk(clk),
.resetn (resetn),
.restart(restart),
.EncBytes(EncBytes), // 3 bytes pointed at by EncPtr;
.DecodeDone(Done),  // Input to here.
.EncodedFileBottomWord(BottomWord),  // bottom(first) 32 bit word of encoded file used to seed the rans_state.
.EncPtr(ByteIndex),  // index into encoded input file, points to a byte. 0 is first byte 1 is second byte, etc
.rans_state(RansState),
.NewRansState (NewRansState),
.init(init),
.SymID(DecodedByte),
.Result (Result),
.Active(Active)
);

endmodule

