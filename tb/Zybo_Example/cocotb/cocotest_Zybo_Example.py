from cocotb_test.run import run
import pytest
import os

#SIM=ghdl pytest -s cocotest_Zybo_Example.py
def test_Zybo_Example():
    run(
        vhdl_sources=["$(PWD)/../../../../src/Zybo_Example/Zybo_Example_regs_pkg.vhd",
                    "$(PWD)/../../../../src/Zybo_Example/Zybo_Example_regs.vhd",
                    "$(PWD)/../../../../src/Zybo_Example/Zybo_Example_pkg.vhd",
                    "$(PWD)/../../../../src/Zybo_Example/Zybo_Example.vhd",],
        simulation_args=["--wave=wave.ghw"],
        toplevel="zybo_example",
        module="Zybo_Example_tb",
        toplevel_lang="vhdl"
    )
