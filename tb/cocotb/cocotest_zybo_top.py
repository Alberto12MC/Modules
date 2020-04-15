from cocotb_test.run import run
import pytest
import os

#SIM=ghdl pytest -s cocotest_zyto_top.py
def test_zybo_top():
    run(
        vhdl_sources=["$(PWD)/../../../src/zybo_regs_pkg.vhd",
                    "$(PWD)/../../../src/zybo_regs.vhd",
                    "$(PWD)/../../../src/zybo_top_pkg.vhd",
                    "$(PWD)/../../../src/zybo_top.vhd",],
        simulation_args=["--wave=wave.ghw"],
        toplevel="zybo_top",
        module="zybo_top_tb",
        toplevel_lang="vhdl"
    )
