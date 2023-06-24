// ***************************************************************************************************************
// BHG_I2C_init_RS232_debugger_tb.v   V1.1, June 2023.
//
// V1.1 - Added parameters CLK_STRETCH
//      - Added define USE_SEPARATE_DIN_DOUT_OE               (***Not used in Modelsim simulation.)
//                     Replaces the 2xINOUTs I2C_scl/sda with
//                     with these 2xINs and 4xOUTs I2C_scl/sda_din/dout/oe
//
// Create and debug an I2C startup sequence with an integrated RS232 terminal editor,
// then, optionally disable the RS232 leaving a minimal initialization HDL.
//
//
// Written by Brian Guralnick.
// https://github.com/BrianHGinc / or / https://www.eevblog.com/forum/fpga/ User BrianHG.
//
//
//
// To simulate this project in Modelsim:
// 1) Run Modelsim all by itself.  You do not need your FPGA compiler studio.
// 2) Select 'File / Change Directory' and choose this project's folder.
// 3) In the transcript, type:                'do setup_i2c.do'.  (DONE!)
// 4) To re-compile and simulate again, type: 'do run_i2c.do'.    (DONE!)
//
// For public use.  Just be fair and give credit where it is due.
// ***************************************************************************************************************

`timescale 1 ps/1 ps
`include "BHG_I2C_init_RS232_debugger.sv"


module BHG_I2C_init_RS232_debugger_tb ();

localparam            CLK_IN_KHZ      = 50000     ; // Source  clk_in  frequency in KHz, typically at least 8x the desired I2C rate.  Recommend 25000-100000KHz.
localparam            I2C_KHZ         = 100       ; // Desired clk_out frequency in KHz, use 100, 400, or 1000.
localparam            RS232_BAUD      = 921600    ; // Desired RS232 baud rate.
localparam  bit       TRI_I2C_scl     = 0         ; // 0=I2C_scl & data output is tri-stated when inactive. 1=I2C_scl is always output enabled.
localparam  bit       CLK_STRETCH     = 1         ; // 0=High speed, 1=wait for slave to release the I2C_clk line.

localparam bit [63:0] RUNTIME_MS   = 3                      ; // Number of milliseconds to simulate.  (Must be 64 bit because of picosecond time calculation)
localparam bit [63:0] CLK_PERIOD   = 1000000000/CLK_IN_KHZ  ; // Period of simulated clock.

localparam            TX_TABLE_len                     = 4 ; // Optional, length of init table.
localparam bit [16:0] TX_TABLE_data [0:TX_TABLE_len-1] = '{   // Optional, init LUT data.  17'h {1'function,8'register_address,8'write_data},...
                                                        // ADV7513 HDMI transmitter setup.
                                                        
                                                        17'h1_0101,  //  1 Set rst_out high.
                                                        17'h1_0100,  //  2 Set rst_out low.
                                                        17'h1_0072,  //  3 Set ADV7513 HDMI transmitter's device address.
                                                        17'h0_9803   //  4 Must be set to 0x03 for proper operation
                                                        };

    reg  clk=0,rst=1,RS232_rxd=1; // Remember, a high on the RS232 rxd/txd means no data.
    wire rst_out, I2C_scl, I2C_sda, RS232_tx ;
    wire [2:0] I2C_ack_error ;
// ***********************************************************************************************************************************************
// Instantiate BHG_I2C_init_RS232_debugger.
// ***********************************************************************************************************************************************
    BHG_I2C_init_RS232_debugger #(  .CLK_IN_KHZ      ( CLK_IN_KHZ         ),  // Source  clk_in  frequency in KHz, typically at least 8x the desired I2C rate.
                                    .I2C_KHZ         ( I2C_KHZ            ),  // Desired clk_out frequency in KHz.
                                    .RS232_BAUD      ( RS232_BAUD         ),  // Desired RS232 baud rate.
                                    .TRI_I2C_scl     ( TRI_I2C_scl        ),  // 0=I2C_scl & data output is tri-stated when inactive. 1=I2C_scl is always output enabled.
                                    .CLK_STRETCH     ( CLK_STRETCH        ),  // 0=High speed, 1=wait for slave to release the I2C_clk line.
                                    .TX_TABLE_len    ( TX_TABLE_len       ),  // Optional, length of init table.
                                    .TX_TABLE_data   ( TX_TABLE_data      )   // Optional, init LUT data.
                        ) I2C (
                                    .clk_in          ( clk                ),  // System source clock.
                                    .rst_in          ( rst                ),  // Synchronous reset.
                                    .rst_out         ( rst_out            ),  // I2C sequencer generated reset output option.
                                    .I2C_ack_error   ( I2C_ack_error      ),  // Goes high when the I2C slave device does not return an ACK.

//                                    .I2C_scl_in      (                    ),  // I2C clock read from IO pin
//                                    .I2C_sda_in      (                    ),  // I2C data  read from IO pin
//                                    .I2C_scl_out     (                    ),  // I2C clock out  to   IO pin
//                                    .I2C_sda_out     (                    ),  // I2C data  out  to   IO pin
//                                    .I2C_scl_oe      (                    ),  // I2C output enable for scl IO pin
//                                    .I2C_sda_oe      (                    ),  // I2C output enable for sda IO pin

                                    .I2C_scl         ( I2C_scl            ),  // I2C clock, bidirectional pin.
                                    .I2C_sda         ( I2C_sda            ),  // I2C data, bidirectional pin.

                                    .RS232_rxd       ( RS232_rxd          ),  // RS232 input, receive from terminal.
                                    .RS232_txd       ( RS232_txd          )); // RS232 output, transmit to terminal.
// ***********************************************************************************************************************************************
    initial begin rst=1'b0;#(CLK_PERIOD*2);rst=1'b0;end                      // an ipso-de-facto 2 clock long reset pulse.
// ***********************************************************************************************************************************************
    always  begin clk=1'b1;#(CLK_PERIOD/2);clk=1'b0;#(CLK_PERIOD/2);end      // an ipso-de-facto source clock generator.
// ***********************************************************************************************************************************************
    always        #(RUNTIME_MS * 1000 * 1000 * 1000) $stop ;                 // Stop simulation at RUNTIME_MS (milliseconds).
// ***********************************************************************************************************************************************
endmodule
