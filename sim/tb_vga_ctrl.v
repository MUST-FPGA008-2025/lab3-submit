`timescale 1ns/1ps

module tb_vga_ctrl();

 
    parameter CLK_PERIOD = 40;
   
    parameter RESET_DURATION = 200;
  
    parameter SIM_DURATION = 3000000;

   
    reg  [15:0] pix_data;
    reg         vga_clk;
    reg         rst_n;

    wire [9:0]  pix_x;
    wire [9:0]  pix_y;
    wire        hsync;
    wire        vsync;
    wire [15:0] rgb;

    
    initial begin
        $dumpfile("signals_tb.vcd");
        $dumpvars(0, tb_vga_ctrl);
    end

   
    initial begin
        vga_clk = 1'b1;
       
        forever #(CLK_PERIOD / 2) vga_clk = ~vga_clk;
    end

    
    task reset_dut;
    begin
        $display("Applying reset at time %0t ns", $time);
        rst_n = 1'b0;
        #RESET_DURATION;  
        rst_n = 1'b1; 
        $display("Reset released at time %0t ns", $time);
    end
    endtask 
   
    initial begin
       
        reset_dut();

        @(posedge vga_clk);
        @(posedge vga_clk);
        
        $display("Main test sequence started at time %0t ns", $time);

       
        repeat(1000) @(posedge vga_clk);

        $display("Waiting for simulation to finish...", $time);
        #SIM_DURATION;
        $finish;
    end

    always @(posedge vga_clk or negedge rst_n) begin
        if (!rst_n) 
            pix_data <= 16'h0000;
        else 
            pix_data <= 16'hFFFF;
    end

  
    vga_ctrl vga_ctrl_inst (
        .vga_clk(vga_clk),
        .sys_rst_n(rst_n),
        .pix_data(pix_data),

        .pix_x(pix_x),
        .pix_y(pix_y),
        .hsync(hsync),
        .vsync(vsync),
        .rgb(rgb)
    );

endmodule
