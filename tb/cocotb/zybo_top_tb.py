import cocotb
from cocotb.triggers import Timer, RisingEdge, FallingEdge, ClockCycles
from cocotb.result import TestFailure
from cocotb.clock import Clock
from cocotb.binary import BinaryValue
from cocotb.scoreboard import Scoreboard
from cocotb.monitors import Monitor
from cocotb.regression import TestFactory
from cocotb.drivers.amba import AXI4LiteMaster
from cocotb.drivers.amba import AXIProtocolError
from cocotb.wavedrom import trace, Wavedrom

import numpy as np
import math
import sys, os
import matplotlib.pyplot as plt


# Constants
c_ADDRESS = 0x00000000
c_DATA = 0x02000000
c_CLK_PERIOD = 10 #ns

# ==============================================================================
@cocotb.test(skip = False, stage = 1)
def zybo_test(dut):
    # Setting up clocks
    clk_100MHz = Clock(dut.clk, c_CLK_PERIOD, units='ns')
    cocotb.fork(clk_100MHz.start())
    axi_aclk_100MHz = Clock(dut.axi_aclk, c_CLK_PERIOD, units='ns')
    cocotb.fork(axi_aclk_100MHz.start())
    # Setting init values
    dut.reset <= 1
    dut.sw0_in   <= 0;
    dut.sw1_in   <= 0;
    dut.sw2_in   <= 0;
    dut.sw3_in   <= 0;
    dut.bt0_in   <= 0;
    dut.bt1_in   <= 0;
    dut.bt2_in   <= 0;
    dut.bt3_in   <= 0;
    dut.axi_aresetn <= 0
    # AXI-Lite Master object
    axil_m = AXI4LiteMaster(dut, "s_axi", dut.axi_aclk)
    # Wait one cycle and deactivate resets
    yield Timer(c_CLK_PERIOD)
    dut.reset <= 0
    dut.axi_aresetn <= 1
    yield Timer(c_CLK_PERIOD)
    # AXI-Lite read
    dut._log.info("AXI-Lite: Reading address 0x%02X" % (c_ADDRESS))
    s_value_read = yield axil_m.read(c_ADDRESS)
    # Check
    if s_value_read != c_DATA:
        raise TestFailure("Register at address 0x%08X should have been: \
                               0x%08X but was 0x%08X" % (c_ADDRESS, c_DATA, int(s_value_read)))

    dut._log.info("Read: 0x%08X From Address: 0x%08X" % (int(s_value_read), c_ADDRESS))
    # AXI-Lite write
    yield axil_m.write(c_ADDRESS, 0x00000001)
    yield Timer(c_CLK_PERIOD)
    # Wavedrom
    args = [dut.sw0_in, dut.led0_out, dut.led5r_out]
    with trace(*args, clk=dut.clk) as waves:
        yield ClockCycles(dut.clk, 6)
        yield axil_m.write(c_ADDRESS, 0x00000001)
        yield ClockCycles(dut.clk, 1)
        dut._log.info(waves.dumpj(header = {'text':'WaveDrom example', 'tick':0}))
        waves.write('wavedrom.json', header = {'tick':0}, config = {'hscale':3})
