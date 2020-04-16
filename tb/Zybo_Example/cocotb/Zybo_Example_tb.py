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
from cocotb import SimLog, coroutine
from cocotb.drivers import BitDriver

import random
import numpy as np
import math
import sys, os
import matplotlib.pyplot as plt

# Constants
c_BASEADDRESS = 0x00000000
c_VERSION_OFFSET = 0x00000000
c_CONFIG_ID_OFFSET = 0x00000004
c_COUNT_OFFSET = 0x00000008
c_VERSION_VALUE = 0x00000001
c_CONFIG_ID_VALUE = 0x00000001
c_COUNT_VALUE = 0x02000000
c_CLK_PERIOD = 10 #ns
# ==============================================================================
class BitMonitor(Monitor):
    """Observe a single-bit input or output of the DUT."""
    def __init__(self, name, signal, clk, callback=None, event=None):
        self.name = name
        self.signal = signal
        self.clk = clk
        Monitor.__init__(self, callback, event)

    @coroutine
    def _monitor_recv(self):
        clkedge = RisingEdge(self.clk)

        while True:
            # Capture signal at rising edge of clock
            yield clkedge
            vec = self.signal.value
            self._recv(vec)
# ==============================================================================
class outMonitor(Monitor):
    def __init__(self, name, dut, callback=None, event=None):
        self.name = name
        self.dut = dut
        Monitor.__init__(self, callback, event)

    @cocotb.coroutine
    def _monitor_recv(self):
        clkedge = RisingEdge(self.dut.clk)
        while True:
            # Capture signal at rising edge of clock
            yield clkedge
            vec = self.dut.Zybo_Example_leds_rgb_out
            self._recv(vec)
# ==============================================================================
def input_gen():
    """Generator for input data applied by BitDriver.
    Continually yield a tuple with the number of cycles to be on
    followed by the number of cycles to be off.
    """
    while True:
        yield random.randint(1, 5), random.randint(1, 5)
# ==============================================================================
class TB(object):
    def __init__(self, dut):
        # Some internal state
        self.dut = dut
        self.stopped = False

        # Use the input monitor to reconstruct the transactions from the pins
        # and send them to our 'model' of the design.
        self.input_mon = BitMonitor(name="input", signal=dut.Zybo_Example_sw_in, clk=dut.clk,
                                    callback=self.model)

        # Create input driver and output monitor
        self.input_drv = BitDriver(signal=dut.Zybo_Example_sw_in, clk=dut.clk, generator=input_gen())
        self.output_mon = BitMonitor(name="output", signal=dut.Zybo_Example_leds_out, clk=dut.clk)

        # Create a scoreboard on the outputs
        self.expected_output = []
        self.scoreboard = Scoreboard(dut)
        self.scoreboard.add_interface(self.output_mon, self.expected_output)

    def model(self, transaction):
        if not self.stopped:
            self.expected_output.append(transaction)

    def start(self):
        self.input_drv.start()

    def stop(self):
        self.input_drv.stop()
        self.stopped = True
# ==============================================================================
def check(dut, act, exp):
    # Check
    if act != exp:
        raise TestFailure("Register at address 0x%08X should have been: \
                               0x%08X but was 0x%08X" % (c_BASEADDRESS+c_COUNT_OFFSET, c_COUNT_VALUE, int(act)))

    dut._log.info("Read: 0x%08X From Address: 0x%08X" % (int(act), c_BASEADDRESS+c_COUNT_OFFSET))
# ==============================================================================
@cocotb.test(skip = False, stage = 1)
def Zybo_Example_test(dut):
    # Setting up clocks
    clk_100MHz = Clock(dut.clk, c_CLK_PERIOD, units='ns')
    cocotb.fork(clk_100MHz.start(start_high=False))
    axi_aclk_100MHz = Clock(dut.axi_aclk, c_CLK_PERIOD, units='ns')
    cocotb.fork(axi_aclk_100MHz.start(start_high=False))

    # Setting init values
    dut.reset = 1
    dut.Zybo_Example_sw_in = 0
    dut.Zybo_Example_bt_in = 0
    dut.axi_aresetn = 0
    # AXI-Lite Master object
    axil_m = AXI4LiteMaster(dut, "s_axi", dut.axi_aclk)
    # tb
    tb=TB(dut)
    tb.start()
    # Wait one cycle and deactivate resets
    yield Timer(c_CLK_PERIOD, units='ns')
    dut.reset <= 0
    dut.axi_aresetn <= 1
    yield Timer(c_CLK_PERIOD, units='ns')


    # AXI-Lite read VERSION
    dut._log.info("AXI-Lite: Reading address 0x%02X" % (c_BASEADDRESS+c_VERSION_OFFSET))
    s_value_read = yield axil_m.read(c_BASEADDRESS+c_VERSION_OFFSET)
    # Check
    check(dut, s_value_read, c_VERSION_VALUE)

    # AXI-Lite read CONFIG_ID
    dut._log.info("AXI-Lite: Reading address 0x%02X" % (c_BASEADDRESS+c_CONFIG_ID_OFFSET))
    s_value_read = yield axil_m.read(c_BASEADDRESS+c_CONFIG_ID_OFFSET)
    # Check
    check(dut, s_value_read, c_CONFIG_ID_VALUE)

    # AXI-Lite read COUNT
    dut._log.info("AXI-Lite: Reading address 0x%02X" % (c_BASEADDRESS+c_COUNT_OFFSET))
    s_value_read = yield axil_m.read(c_BASEADDRESS+c_COUNT_OFFSET)
    # Check
    check(dut, s_value_read, c_COUNT_VALUE)

    # AXI-Lite write
    yield axil_m.write(c_BASEADDRESS+c_COUNT_OFFSET, 0x00000001)
    yield Timer(c_CLK_PERIOD, units='ns')

    # end tb
    tb.stop()

@cocotb.test(skip = False, stage = 2)
def Wavedrom_test(dut):
    # Setting up clocks
    clk_100MHz = Clock(dut.clk, c_CLK_PERIOD, units='ns')
    cocotb.fork(clk_100MHz.start(start_high=False))
    axi_aclk_100MHz = Clock(dut.axi_aclk, c_CLK_PERIOD, units='ns')
    cocotb.fork(axi_aclk_100MHz.start(start_high=False))

    # AXI-Lite Master object
    axil_m = AXI4LiteMaster(dut, "s_axi", dut.axi_aclk)

    # Setting init values
    dut.reset <= 1
    dut.Zybo_Example_sw_in <= 4
    dut.Zybo_Example_bt_in <= 0
    dut.axi_aresetn <= 0
    # Wait one cycle and deactivate resets
    yield Timer(c_CLK_PERIOD, units='ns')
    dut.reset <= 0
    dut.axi_aresetn <= 1
    yield Timer(c_CLK_PERIOD, units='ns')

    # AXI-Lite write
    yield axil_m.write(c_BASEADDRESS+c_COUNT_OFFSET, 0x00000001)
    yield Timer(c_CLK_PERIOD, units='ns')

    # Wavedrom
    args = [dut.Zybo_Example_sw_in, dut.Zybo_Example_leds_out, dut.Zybo_Example_leds_rgb_out]
    with trace(*args, clk=dut.clk) as waves:
        yield ClockCycles(dut.clk, 12)
        dut._log.info(waves.dumpj(header = {'text':'WaveDrom example', 'tick':0}))
        waves.write('wavedrom.json', header = {'tick':0}, config = {'hscale':3})
