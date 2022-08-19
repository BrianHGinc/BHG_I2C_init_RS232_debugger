# BHG_I2C_init_RS232_debugger
BHG_I2C_init_RS232_debugger is an I2C initializer with integrated RS232 debugger.

***************************************************************************************************************
BHG_I2C_init_RS232_debugger.v & testbench  V1.0, August 2022.
---------------------------------------------------------------------------------------------------------------
Create and debug an I2C startup sequence with an integrated RS232 terminal editor,
then, optionally disable the RS232 leaving a minimal initialization HDL.

Written by Brian Guralnick.
https://github.com/BrianHGinc / or / https://www.eevblog.com/forum/fpga/bhg_i2c_init_rs232_debugger-an-i2c-initializer-with-integrated-rs232-debugger/


To simulate this project in Modelsim:
 1) Run Modelsim all by itself.  You do not need your FPGA compiler studio.
 2) Select 'File / Change Directory' and choose this project's folder.
 3) In the transcript, type:                'do setup_i2c.do'.  (DONE!)
 4) To re-compile and simulate again, type: 'do run_i2c.do'.    (DONE!)

For public use.  Just be fair and give credit where it is due.
***************************************************************************************************************

Instructions:

 Parameter bit [16:0] TX_TABLE_data [0:TX_TABLE_len-1] is a 17 bit array which contains your startup sequence.

 In the TX_TABLE_data, you can specify multiple I2C device addresses, control an output port called .rst_out(),
specify delays from 1 to 256 milliseconds and write data to any I2C register address.

 When you include the `define ENABLE_RS232_EDITOR at the top of the code, a real-time RS232 logger, debugger and
editor will be included in the code.  The editor will allow you to read and write registers as well as reset
and re-initialize the startup sequence with any simple terminal software.


The structure is: 1'b Func, 8'h register_address, 8'h data.

  - When Func=1, the register_address=0, the 'data' will set the current I2C_Device_Address.
  - When Func=1, the register_address=1, the 'data' will specify the .rst_out() port value.
  - When Func=1, the register_address=2, the 'data' will specify a delay timer from 1 through 255 milliseconds. 0=256.
  - When Func=0, the 'data' will be written to the 'register_address' of the previously set I2C_Device_Address.


 In the RS232 debugger terminal, power-up will log the transmitted TX_TABLE_data initialization sequence, then
leave you with the last address and data sent to be edited.

![plot](https://github.com/BrianHGinc/BHG_I2C_init_RS232_debugger/blob/main/screenshots/BHG_I2C_init_RS232_debugger_ss.png)

 Pressing the W / R will quickly toggle the I2C_Device_Address between a read and write address.
Using backspace and entering new hex numbers will edit your command line.  Until you hit enter,
the edit line will not be transmitted.

 Pressing the 'ESC' key will reset the module, re-executing you pre-defined power-up 'TX_TABLE_data'.


Remember, at the top of 'BHG_I2C_init_RS232_debugger.v', there is a:

`define  ENABLE_RS232_EDITOR

 Once you have your startup-sequence, comment out this line to save a huge amount of FPGA resources
as all the RS232 editor's HDL will be removed from the code.


Enjoy.
