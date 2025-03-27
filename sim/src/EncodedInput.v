

// Generated file to hold the encoded data that will be decoded.  The variable "encoded_data" is what is decoded
// by this system.  Do not modify.  Rather, adjust the function in the C code, "export_EncodedInput()".

`timescale 1ns / 1ns
module EncodedInput(
input wire [31:0]ByteIndex,
output wire [23:0]EncBytes,
output wire [31:0]BottomWord,
output wire [31:0]EncodedFileSize
);

parameter NUMBYTES_AFTER_ENC = 196;
parameter WIDTH = 8;
parameter HIGH_BIT_POSITION = NUMBYTES_AFTER_ENC * WIDTH - 1;
 
wire [HIGH_BIT_POSITION:0]encoded_data;


// three bytes with byte zero at current byte index. Algorithm can encode up to three in one iteration.
// the number encoded varies depending on input data from 1 to 3 bytes.
wire [7:0]byteZero;
wire [7:0]byteOne;
wire [7:0]byteTwo;


assign EncodedFileSize = NUMBYTES_AFTER_ENC; 
assign byteZero[7:0] = encoded_data[((NUMBYTES_AFTER_ENC - ByteIndex - 1) * WIDTH) +:WIDTH];
assign byteOne[7:0] = encoded_data[((NUMBYTES_AFTER_ENC - ByteIndex - 2) * WIDTH) +:WIDTH];
assign byteTwo[7:0] = encoded_data[((NUMBYTES_AFTER_ENC - ByteIndex - 3) * WIDTH) +:WIDTH];
assign EncBytes[23:0] = {byteTwo[7:0],
						byteOne[7:0],
						byteZero[7:0]
						}; // if ByteIndex is zero, EncBytes = 24'haa351c .


assign BottomWord[31:0] = {
encoded_data[((NUMBYTES_AFTER_ENC - 4) * WIDTH) +:8],
encoded_data[((NUMBYTES_AFTER_ENC - 3) * WIDTH) +:8],
encoded_data[((NUMBYTES_AFTER_ENC - 2) * WIDTH) +:8],
encoded_data[((NUMBYTES_AFTER_ENC - 1) * WIDTH) +:8]
};

assign encoded_data[HIGH_BIT_POSITION:0] = 
{8'h1c, 8'h35, 8'haa, 8'h25, 8'he9, 8'hbb, 8'h60, 8'ha8, 8'h60, 8'h05, 8'h27, 8'h8f, 8'h6b, 8'h87, 8'hdb, 8'h02, 
8'h6a, 8'h5b, 8'he6, 8'hb7, 8'h30, 8'ha4, 8'h39, 8'h68, 8'h2c, 8'h3a, 8'h02, 8'h76, 8'h97, 8'h64, 8'h4d, 8'ha6, 
8'hfa, 8'hba, 8'hee, 8'haa, 8'hb8, 8'hf1, 8'h91, 8'h7a, 8'hd2, 8'hde, 8'hc5, 8'h5b, 8'h76, 8'h2f, 8'hc6, 8'h35, 
8'h23, 8'h75, 8'hd8, 8'hbe, 8'h61, 8'h93, 8'h9c, 8'hf4, 8'h24, 8'hd6, 8'hb5, 8'he3, 8'hcd, 8'h6b, 8'hb9, 8'h7c, 
8'h58, 8'hd6, 8'h7f, 8'h79, 8'h35, 8'h23, 8'h0d, 8'hd0, 8'hf8, 8'h30, 8'hfa, 8'h3f, 8'h37, 8'hae, 8'ha1, 8'hc5, 
8'h9c, 8'hed, 8'h8d, 8'he2, 8'h09, 8'h72, 8'h66, 8'ha8, 8'h49, 8'hd3, 8'h7f, 8'h55, 8'h55, 8'hcd, 8'h67, 8'h70, 
8'hf7, 8'h01, 8'hdd, 8'hec, 8'h06, 8'h57, 8'hc6, 8'h93, 8'h98, 8'h0d, 8'h78, 8'h12, 8'haa, 8'h25, 8'hce, 8'h65, 
8'h37, 8'h80, 8'h10, 8'h9c, 8'hd1, 8'hc1, 8'h86, 8'h43, 8'h88, 8'hcc, 8'h91, 8'h92, 8'h46, 8'hdd, 8'h35, 8'h96, 
8'h80, 8'h47, 8'hb5, 8'he5, 8'h5e, 8'hc2, 8'h6e, 8'h9f, 8'h02, 8'h45, 8'hc5, 8'h6f, 8'h76, 8'hbe, 8'h0b, 8'h24, 
8'h34, 8'h21, 8'h44, 8'h5b, 8'h4d, 8'hfc, 8'h85, 8'h3f, 8'h41, 8'h4a, 8'hbf, 8'h7c, 8'h35, 8'h88, 8'ha2, 8'h87, 
8'h22, 8'hd4, 8'h56, 8'h41, 8'h9e, 8'h26, 8'ha6, 8'hfd, 8'h8a, 8'h88, 8'h4c, 8'he3, 8'h6e, 8'h86, 8'h57, 8'hba, 
8'hb1, 8'hc2, 8'he7, 8'h46, 8'h04, 8'h81, 8'h08, 8'hf0, 8'he0, 8'h9b, 8'h43, 8'hbe, 8'ha3, 8'h5a, 8'h06, 8'h9a, 
8'h77, 8'h98, 8'h27, 8'hb7};

endmodule