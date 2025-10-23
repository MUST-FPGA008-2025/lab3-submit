`timescale 1ns/1ps
// Edit this module is enough for LAB3
// You need write testbench to test them all

module vga_pic_must(
input wire vga_clk , //VGA working clock, 25MHz
input wire sys_rst_n , //Reset signal. Low level is effective
input wire [9:0] pix_x , //X coordinate of current pixel
input wire [9:0] pix_y , //Y coordinate of current pixel

output reg [15:0] pix_data //Color information, RGB565

);

 parameter BLUE = 16'h001F, //Blue
 BLACK = 16'h0000, //Black
 WHITE = 16'hFFFF; //White

 //Generate color data according coordinates
 
 wire rule; // connector between the module and the "blue_mask" module 

 always@(*) begin // posedge vga_clk or negedge sys_rst_n
	 if(sys_rst_n == 1'b0)
		pix_data = BLACK;
	 else begin
		if (rule) pix_data =  BLUE;
        else pix_data = WHITE;
	 end
 end


blue_mask blue_inst(
.clk (vga_clk),
.x (pix_x),
.y (pix_y),

.is_blue (rule)
);

 endmodule