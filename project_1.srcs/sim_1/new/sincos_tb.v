`timescale 1ns / 1ps

module sincos_tb ();

  // Parameters for clock frequency, PI values, and phase increment
  localparam CLK_PERIOD = 10;    // To create 100 MHz clock
  localparam signed [15:0] PI_POS = 16'b0110_0100_1000_1000;  // +pi in fixed-point 1.2.13
  localparam signed [15:0] PI_NEG = 16'b1001_1011_0111_1000;  // -pi in fixed-point 1.2.13
  localparam PHASE_INC = 256;    // Phase sweep value

  // Clock and reset signals
  reg clk = 1'b0;
  reg rst = 1'b1;

  // Phase and validity signals
  reg signed [15:0] phase = 0;
  reg phase_tvalid = 1'b0;

  // Output signals from the sincos module
  wire signed [15:0] cos, sin;
  wire sincos_tvalid;

  // Instantiate the sincos module
  sincos sincos_inst (
    .clk(clk),
    .phase(phase),
    .phase_tvalid(phase_tvalid),
    .cos(cos),
    .sin(sin),
    .sincos_tvalid(sincos_tvalid)
  );

  // Clock and reset generation
  initial begin
    clk = 1'b0;
    rst = 1'b1;
    #(CLK_PERIOD * 10);
    rst = 1'b0;
  end

  always begin
    clk = #(CLK_PERIOD / 2) ~clk;
  end

  // Drive phase input
  always @(posedge clk) begin
    if (rst) begin
        phase <= 0;
        phase_tvalid <= 1'b0;
    end else begin
        phase_tvalid <= 1'b1;
        // Sweep the phase around the unit circle
        if (phase + PHASE_INC < PI_POS) begin
            phase <= phase + PHASE_INC;
        end else begin
            phase <= PI_NEG;
        end
    end
end

endmodule
