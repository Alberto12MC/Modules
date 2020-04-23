TOPLEVEL_LANG=vhdl
VHDL_SOURCES = $(PWD)/../../../src/FSM/fsm_pkg.vhd
VHDL_SOURCES += $(PWD)/../../../src/FSM/fsm.vhd
TOPLEVEL=fsm
MODULE=fsm_tb
SIM=ghdl
SIM_ARGS=--wave=salida.ghws
include $(shell cocotb-config --makefiles)/Makefile.inc
include $(shell cocotb-config --makefiles)/Makefile.sim
