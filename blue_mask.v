`timescale 1ns/1ps
module blue_mask #(
  parameter integer W = 640,
  parameter integer H = 480,
  parameter integer WORD_BITS = 32,
  parameter integer DEPTH = (W*H) / WORD_BITS // how many words for the image
)(
  input  wire               clk,
  input  wire [9:0]         x,       // 0..639  => 10 bits
  input  wire [8:0]         y,       // 0..479  => 9 bits
  output reg                is_blue  
);

  wire [18:0] idx       = y*W + x;  // max = 640*480 -1 =  307199 -> 19 bits
  wire [13:0] word_addr = idx[18:5]; // idx >> 5 (0..9599 -> 14 bits)
  wire [4:0]  bit_off   = idx[4:0];  // 0..31

  // ROM / BRAM
  reg [31:0] blue_rom [0:DEPTH-1];
  initial $readmemh("blue_bitmap_32pp.hex", blue_rom);


  reg [31:0] word_q;
  reg [4:0]  bit_off_q;


  always @(posedge clk) begin
    word_q    <= blue_rom[word_addr];
    bit_off_q <= bit_off;
    is_blue   <= word_q[bit_off_q]; // in fact, the is_blue is for the last pixel position

  end

endmodule
