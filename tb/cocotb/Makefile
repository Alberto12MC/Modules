TOPLEVEL_LANG=vhdl
VHDL_SOURCES = $(PWD)/../../src/zybo_regs_pkg.vhd
VHDL_SOURCES += $(PWD)/../../src/zybo_regs.vhd
VHDL_SOURCES += $(PWD)/../../src/zybo_top_pkg.vhd
VHDL_SOURCES += $(PWD)/../../src/zybo_top.vhd
TOPLEVEL=zybo_top
MODULE=zybo_top_tb
SIM=ghdl
SIM_ARGS=--wave=salida.ghws
# COMPILE_ARGS := -fprofile-arcs -ftest-coverage -Wl,-lgcov
COMPILE_ARGS := -P/opt/Xilinx/vivado-lib-comp/xilinx-vivado/unisim/v08 -P/opt/Xilinx/vivado-lib-comp/xilinx-vivado/unifast/v08 -P/opt/Xilinx/vivado-lib-comp/xilinx-vivado/unimacro/v08 -P/opt/Xilinx/vivado-lib-comp/xilinx-vivado/secureip/v08
include $(shell cocotb-config --makefiles)/Makefile.inc
include $(shell cocotb-config --makefiles)/Makefile.sim
