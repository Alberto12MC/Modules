from cocotb_test.run import run
import pytest
import os

#SIM=ghdl pytest -s cocotest_fsm.py
def test_fsm():
    run(
        vhdl_sources=["$(PWD)/../../../../src/FSM/fsm_pkg.vhd",
                    "$(PWD)/../../../../src/FSM/fsm.vhd"],
        simulation_args=["--wave=wave.ghw"],
        toplevel="fsm",
        module="fsm_tb",
        toplevel_lang="vhdl"
    )
