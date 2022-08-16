vlog -sv -work work {BHG_I2C_init_RS232_debugger_tb.v}

restart -force
run -all

wave cursor active
wave refresh
wave zoom range 0us 400us
view signals
