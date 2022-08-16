transcript on
if {[file exists work]} {
	vdel -lib work -all
}
vlib work
vmap work work

vlog -sv -work work {BHG_I2C_init_RS232_debugger_tb.v}
vsim -t 1ps -L work -voptargs="+acc"  BHG_I2C_init_RS232_debugger_tb

restart -force -nowave

# This line shows only the variable name instead of the full path and which module it was in
config wave -signalnamewidth 1

add wave -divider     "Input:"
add wave -hexadecimal rst
add wave -hexadecimal clk
add wave -divider     "Output:"
add wave -hexadecimal rst_out
add wave -hexadecimal I2C_scl
add wave -hexadecimal I2C_sda
add wave -hexadecimal I2C_ack_error
add wave -divider     "I2C seq ctl"
add wave -hexadecimal I2C/rr    
add wave -unsigned    I2C/mst_cnt
add wave -unsigned    I2C/ms_cnt_len
add wave -unsigned    I2C/mst_hold
add wave -unsigned    I2C/I2C_period
add wave -unsigned    I2C/per_pulse
add wave -unsigned    I2C/seq_pc
add wave -divider     "I2C cmd regs"
add wave -hexadecimal I2C/I2C_da
add wave -hexadecimal I2C/I2C_ra
add wave -hexadecimal I2C/I2C_wd
add wave -unsigned    I2C/txl
add wave -hexadecimal I2C/I2C_rd
add wave -divider     "Table pos"
add wave -unsigned    I2C/tpos
add wave -divider     "RS232:"
add wave -hexadecimal RS232_rxd    
add wave -hexadecimal RS232_txd    
#add wave -ascii       I2C/rs232_uart/tx_data
#add wave -hexadecimal I2C/rs232_uart/ena_tx


do run_i2c.do
