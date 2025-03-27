// ************************************************************
//  rans_decoder.v
//  Decode of rans ported from C program function.
//
// ************************************************************

//static inline uint32_t RansDecGetAlias(RansState* r, SymbolStats* const syms, uint32_t scale_bits)
//{
//    RansState x = *r;
//
//    // figure out symbol via alias table
//    uint32_t mask = (1u << scale_bits) - 1; // constant for fixed scale_bits!
//    uint32_t xm = x & mask;
//    uint32_t bucket_id = xm >> (scale_bits - SymbolStats::LOG2NSYMS);
//    uint32_t bucket2 = bucket_id * 2;
//    if (xm < syms->divider[bucket_id])
//        bucket2++;
//
//    // s, x = D(x)
//    *r = syms->slot_freqs[bucket2] * (x >> scale_bits) + xm - syms->slot_adjust[bucket2];
//    return syms->sym_id[bucket2];
//}

`timescale 1ns / 1ns
module rans_decoder(
input wire [31:0]RansState,
input wire [31:0]slot_freqsLookup,
input wire [31:0]slot_adjustLookup,
input wire [31:0]dividerLookup,
input wire [31:0]sym_idLookup,
output wire [8:0]slot_freqsLookupIndex,
output wire [8:0]slot_adjustLookupIndex,
output wire [8:0]sym_idLookupIndex,
output wire [7:0]dividerLookupIndex,
output wire [31:0]NewRansState,
output wire [7:0]dec_byte
);


parameter SCALE_BITS = 32'h00000010;
parameter LOG2NSYMS =  32'h00000008;

wire [31:0]x;
wire [31:0]x_mult_input;
wire [31:0]xm;
wire [31:0]mask;
wire [31:0]bucket_id;
wire [31:0]bucket2;
wire [31:0]bucket2plusOne;
wire [31:0]multResult;
wire [31:0]bucket2Final;
wire[31:0]sym_id;

assign mask[31:0] = (32'h1 << SCALE_BITS) - 1;
assign x[31:0] = RansState[31:0];
assign xm = x[31:0] & mask[31:0];
assign bucket_id[31:0] = xm[31:0] >> (SCALE_BITS - LOG2NSYMS);
assign bucket2[31:0] = bucket_id[31:0] * 2;
assign bucket2plusOne[31:0] = bucket2[31:0] + 1;
assign bucket2Final = (xm < dividerLookup[31:0]) ? bucket2plusOne[31:0] : bucket2[31:0];   
assign x_mult_input[31:0] = (x >> SCALE_BITS);
assign NewRansState = multResult + xm - slot_adjustLookup;
assign slot_freqsLookupIndex[8:0] = bucket2Final[8:0]; 
assign slot_adjustLookupIndex[8:0] = bucket2Final[8:0]; 
assign sym_idLookupIndex[8:0] = bucket2Final[8:0];
assign dividerLookupIndex[7:0] = bucket_id[7:0];   
assign sym_id[31:0] = sym_idLookup[31:0];
assign dec_byte[7:0] = sym_id[7:0];

Mult32	Mult32_inst (
	.dataa ( slot_freqsLookup[15:0] ),
	.datab ( x_mult_input[15:0] ),
	.result ( multResult)
	);

endmodule




