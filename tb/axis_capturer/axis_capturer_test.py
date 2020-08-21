import cocotb
from cocotb.triggers import Timer, RisingEdge, FallingEdge
from cocotb.result import TestFailure
from cocotb.clock import Clock

# Constants
c_CLK_PERIOD = 4
# ==============================================================================
@cocotb.test(skip = False, stage= 1)
def axis_capturer_test(dut):
    log = cocotb.logging.getLogger("cocotb.test") #logger instance
    # Init values
    dut.axis_resetn <= 0
    dut.s0_axis_tdata <= 0
    dut.s0_axis_tvalid <= 0
    # Clocks
    axis_aclk = Clock(dut.axis_aclk, c_CLK_PERIOD, units='ns')
    cocotb.fork(axis_aclk.start(start_high=True))
    # Deactivate reset
    yield Timer(c_CLK_PERIOD * 5, units='ns')
    dut.axis_resetn <= 1
    #Driver
    for i in range(0,20000):
        dut.s0_axis_tdata <= i
        dut.s0_axis_tvalid <= 1
        yield RisingEdge(dut.axis_aclk)
    #Stop
    dut.s0_axis_tdata <= 0
    dut.s0_axis_tvalid <= 0
    yield Timer(5*c_CLK_PERIOD, units='ns')