`timescale 1ns/1ps

module tb_pll();

parameter RST_DELAY = 100;
parameter SIM_TIME = 1000;

//Declare artificial inputs
reg artificial_sys_clk;
reg artificial_rst_n;
//declare record output
wire recorder_vga_clk;


//generate artificial inputs
initial begin
  artificial_sys_clk <= 1'b1;
  artificial_rst_n <= 1'b0;
  #RST_DELAY;
  artificial_rst_n <= 1'b1;
  
  #SIM_TIME;
  $display("Simulation completed at time %0t ns",$time);
  $finish;
end

always begin
  #10 artificial_sys_clk <= ~artificial_sys_clk;
end

//instance 
pll pll_inst
(
  .sys_clk(artificial_sys_clk),
  .sys_rst_n(artificial_rst_n),
  
  .vga_clk(recorder_vga_clk)
);
endmodule