`timescale 1ns/1ps
// YOU NEED write a testbench, simulation, everything OK -> PUT into simulator

module vga_must(
input wire sys_clk , //System Clock, 50MHz
input wire sys_rst_n , //Reset signal. Low level is effective

output wire hsync , //Line sync signal
output wire vsync , //Field sync signal
output wire [15:0] rgb //RGB565 color data

);

 ////
 //\* Parameter and Internal Signal \//
 ////

 //wire define
 wire vga_clk ; //VGA working clock, 25MHz
 wire [9:0] pix_x ; //x coordinate of current pixel
 wire [9:0] pix_y ; //y coordinate of current pixel
 wire [15:0] pix_data; //color information



 pll pll_inst
 (
 .sys_clk(sys_clk),
 .sys_rst_n(sys_rst_n),

 .vga_clk(vga_clk) // connector1
 );


 vga_pic_must vga_pic_inst
 (
 .vga_clk (vga_clk ), 
 .sys_rst_n (sys_rst_n ), 
 .pix_x (pix_x ), //x coordinate of current pixel, connector2
 .pix_y (pix_y ), //y coordinate of current pixel, connector3

 .pix_data (pix_data ) //color information, connector4
 );


 vga_ctrl vga_ctrl_inst
 (
 .vga_clk (vga_clk ), 
 .sys_rst_n (sys_rst_n ), 
 .pix_data (pix_data ), //color information

 .pix_x (pix_x ), //x coordinate of current pixel
 .pix_y (pix_y ), //y coordinate of current pixel
 .hsync (hsync ),
 .vsync (vsync ), 
 .rgb (rgb ) //RGB565 color data
 );

 endmodule