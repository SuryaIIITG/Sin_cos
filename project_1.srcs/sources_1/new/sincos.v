`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.11.2024 19:10:19
// Design Name: 
// Module Name: sincos
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sincos (
  input clk,
  input [15:0] phase,
  input phase_tvalid,

  output [15:0] cos,
  output [15:0] sin,
  output sincos_tvalid
);

  // Instantiate the CORDIC IP
  cordic_0 cordic_0_inst (
    .aclk(clk),
    .s_axis_phase_tvalid(phase_tvalid),
    .s_axis_phase_tdata(phase),
    .m_axis_dout_tvalid(sincos_tvalid),
    .m_axis_dout_tdata({sin, cos})
  );

  // Declare a wire bundle to connect to the ILA
  wire [15:0] ila_phase;
  wire ila_phase_tvalid;
  wire [15:0] ila_cos;
  wire [15:0] ila_sin;
  wire ila_sincos_tvalid;

  // Assign monitored signals to ILA wires
  assign ila_phase = phase;
  assign ila_phase_tvalid = phase_tvalid;
  assign ila_cos = cos;
  assign ila_sin = sin;
  assign ila_sincos_tvalid = sincos_tvalid;

  // Instantiate the ILA
  ila_0 ila_0_inst (
    .clk(clk), // Clock input for ILA
    .probe0(ila_phase),          // Probe 0: Phase input
    .probe1(ila_phase_tvalid),   // Probe 1: Phase valid signal
    .probe2(ila_cos),            // Probe 2: Cosine output
    .probe3(ila_sin),            // Probe 3: Sine output
    .probe4(ila_sincos_tvalid)   // Probe 4: Sine-Cosine valid signal
  );

endmodule
