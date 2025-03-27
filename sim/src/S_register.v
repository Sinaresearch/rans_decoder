// *************************************
// State register
// Generic D type register with enable and loadable value
//
//*******************************************

module S_register(
input wire clk,
input wire [31:0]InitVal,
input wire [31:0]D,
output reg [31:0]Q,
input wire enable,
input wire init
);

always @(posedge clk)
begin
	if (init == 1'b1)
	begin
		Q <= InitVal;
	end
	else if (enable == 1'b1)
	begin
		Q <= D;
	end
	else
	begin
		Q <= Q;
	end
end

endmodule


