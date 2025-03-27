// ***********************************************
// Driver for rans decode
// Feeds data to the docoder and manages the Rans State and pointer to the input file.
// rans_decDriver.v
//
//*************************************************
`timescale 1ns / 1ns

module Fin_and_S_wrapper(
input wire clk,
input wire resetn,
input wire restart,
input wire [23:0]EncBytes, // 3 bytes pointed at by EncPtr;
input wire DecodeDone,
input wire [31:0]EncodedFileBottomWord,  // bottom(first) 32 bit word of encoded file used to seed the rans_state.
output wire [31:0]EncPtr,  // index into encoded input file, points to a byte. 0 is first byte 1 is second byte, etc
output wire [31:0]rans_state,
input wire[31:0]NewRansState,
output reg init,
input wire [7:0]SymID,
output wire [7:0]Result,
output wire Active
);

parameter CRITICAL_PIPE_LEN = 1;

reg [2:0]next_state;
reg [31:0]BytePosition;
reg [1:0]NumBytes;
reg EnableForever;
wire [1:0]HowMuchWeIncrement;

wire [7:0]byte_zero;
wire [7:0]byte_one;
wire [7:0]byte_two;

wire [31:0]LogicInPipe;
wire [31:0]Q_One;
wire done_init;

assign Result[7:0] = SymID;

assign LogicInPipe = renormed_State(NewRansState);  
assign HowMuchWeIncrement = NumIncrements(NewRansState); 
assign done_init = EnableForever;
assign byte_zero = EncBytes[7:0];
assign byte_one = EncBytes[15:8];
assign byte_two = EncBytes[23:16];
 
assign EncPtr[31:0] = BytePosition[31:0]; 

assign Active = done_init;
   
parameter RENORM_MAX = 24'h800000;


// Register S from that holds the Rans State
S_register State_S(
.clk(clk),
.InitVal(EncodedFileBottomWord),
.D(LogicInPipe),
.Q(rans_state),
.enable(done_init),
.init(init)
);

// Handle pointer to read from input file.  Byteposition is incremented by a variable amount based on decoding logic.
always @(posedge clk or negedge resetn)
begin
  if (init | ~resetn)  // second step of init.  Set up pointer to next 4 byte word.  Unique operation to Init.
  begin
    BytePosition <= 4;
  end
  else if (done_init)
  begin
	BytePosition <= BytePosition + HowMuchWeIncrement;
  end
  else 
  begin
	BytePosition <= BytePosition;
  end
end


// logic for renorm operation.
function [31:0]renormed_State;  
    input [31:0] instate;
    reg [31:0]state;  
    reg [1:0]InByteSel; 
	reg escape; 
begin 
	state = instate;
	InByteSel = 2'b0;
	escape = 1'b0;
 	while ((state < RENORM_MAX) && (escape == 1'b0))
	begin
        state = (state << 8) | SelStateByte(InByteSel);
	    InByteSel = InByteSel + 1;
	    if (InByteSel > 2) 
	    begin
			escape = 1'b1;
	    end
		else
		begin
			escape = 1'b0;
		end
	end
	renormed_State = state;  
end
endfunction

// Multiplexor to select input byte based on decoding logic.  Selects one of three bytes.  Input value 3 is illegal.
function [7:0]SelStateByte;
   input [1:0]InByteSel; 
begin
case (InByteSel)
   0:SelStateByte = byte_zero;
   1:SelStateByte = byte_one; 
   2:SelStateByte = byte_two;
default:
   SelStateByte = 8'hFF; 
endcase
end
endfunction


// logic to compute how much to increment state on each clock cycle.  Possible values are 0,1,2.  
function [1:0]NumIncrements;
input [31:0]instate;
reg [31:0]state;
reg [1:0]Iteration;
integer i;
begin
	Iteration = 0;
	state = instate;
	for (i=0; i<3; i=i+1)
	begin
		if (state < RENORM_MAX)
		begin
			state = (state << 8) | SelStateByte(i);
			Iteration = Iteration + 1;
		end
		else
		begin
			state = state;
		end
	end
NumIncrements = Iteration;
end
endfunction



// user interface driver for loading initial value and starting the decoding process.
parameter IDLE = 3'b000;
parameter INIT_NOW = 3'b001;
parameter INIT_STEP2 = 3'b011;


always @(posedge clk or negedge resetn)
begin
	if (~resetn)
	begin
		next_state <= IDLE;
		init <= 0;
		EnableForever <= 0;
	end
	else
	begin
		case(next_state)
		IDLE:
		begin
			init <= 0;
			EnableForever <= 0;
			next_state <= INIT_NOW;
		end
		INIT_NOW:
		begin
			init <= 1;
			EnableForever <= 0;
			next_state <= INIT_STEP2;
		end
        INIT_STEP2:
        begin
            init <= 0;
			EnableForever <= 1;
			if (restart)
			begin
				next_state <= INIT_NOW;
			end
			else
			begin
				next_state <= INIT_STEP2; 
			end         
        end
		endcase
	end
end
endmodule