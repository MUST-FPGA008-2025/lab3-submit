`timescale 1ns/1ps

module tb_blue_mask;
  // === DUT ports ===
  reg        clk;
  reg  [9:0] x;   // 0..639
  reg  [8:0] y;   // 0..479
  wire       is_blue;

  // === 40 ns clock period: toggle every 20 ns ===
  initial clk = 1'b0;
  always #20 clk = ~clk;


  // === Stimulus: no tasks; align sampling with the DUT's 1-cycle latency ===
  initial begin
    x = 0; y = 0;

    // Warm up two cycles
    @(posedge clk);
    @(posedge clk);

    // 1) (141, 39), blue
    @(negedge clk); x = 10'd141; y = 9'd39;   // change inputs on negedge to avoid race at posedge
    @(posedge clk);                            // cycle 1: DUT reads ROM word for (x,y)
    //@(posedge clk);                           

    // 2) (142, 39), white
    @(negedge clk); x = 10'd142; y = 9'd39; // cycle 2: you can see the is_blue result from the previous coordinate
    @(posedge clk);
    //@(posedge clk);

    // 3) (143, 39), blue
    @(negedge clk); x = 10'd143; y = 9'd39;
    @(posedge clk);// white?
    //@(posedge clk);

    // 4) (140, 40), blue
    @(negedge clk); x = 10'd140; y = 9'd40;
    @(posedge clk);
    //@(posedge clk);


    @(posedge clk);
    @(posedge clk);
    $stop;
  end

  // === DUT instance ===
  blue_mask uut (
    .clk     (clk),
    .x       (x),
    .y       (y),
    .is_blue (is_blue)
  );

endmodule
