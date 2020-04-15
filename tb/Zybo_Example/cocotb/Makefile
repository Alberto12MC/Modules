TOPLEVEL_LANG=vhdl
VHDL_SOURCES = $(PWD)/../../../src/Zybo_Example/Zybo_Example_regs_pkg.vhd
VHDL_SOURCES += $(PWD)/../../../src/Zybo_Example/Zybo_Example_regs.vhd
VHDL_SOURCES += $(PWD)/../../../src/Zybo_Example/Zybo_Example_pkg.vhd
VHDL_SOURCES += $(PWD)/../../../src/Zybo_Example/Zybo_Example.vhd
TOPLEVEL=Zybo_Example
MODULE=Zybo_Example_tb
SIM=ghdl
SIM_ARGS=--wave=salida.ghws
# COMPILE_ARGS := -fprofile-arcs -ftest-coverage -Wl,-lgcov
COMPILE_ARGS := -P/opt/Xilinx/vivado-lib-comp/xilinx-vivado/unisim/v08 -P/opt/Xilinx/vivado-lib-comp/xilinx-vivado/unifast/v08 -P/opt/Xilinx/vivado-lib-comp/xilinx-vivado/unimacro/v08 -P/opt/Xilinx/vivado-lib-comp/xilinx-vivado/secureip/v08
include $(shell cocotb-config --makefiles)/Makefile.inc
include $(shell cocotb-config --makefiles)/Makefile.sim
