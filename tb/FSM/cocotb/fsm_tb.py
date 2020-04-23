import cocotb
from cocotb.triggers import Timer
from cocotb.clock import Clock

# Constants
c_CLK_PERIOD = 10 #ns

@cocotb.test(skip = False, stage = 1)
def fsm_test(dut):
    # Setting up clocks
    clk_100MHz = Clock(dut.clk, c_CLK_PERIOD, units='ns')
    cocotb.fork(clk_100MHz.start(start_high=False))
    # Setting init values
    dut.reset = 1
    dut.fsm_in_0 = 0
    dut.fsm_in_1 = 0
    # Wait one cycle and deactivate reset
    yield Timer(c_CLK_PERIOD, units='ns')
    dut.reset <= 0
    yield Timer(2*c_CLK_PERIOD, units='ns')
    assert dut.fsm_out_0 == 1 and dut.fsm_out_1 == 0, "FREE_MODE wrong"
    dut.fsm_in_0 <= 1
    yield Timer(2*c_CLK_PERIOD, units='ns')
    assert dut.fsm_out_0 == 0 and dut.fsm_out_1 == 1, "FIXED_MODE wrong"
    dut.fsm_in_1 <= 1
    yield Timer(c_CLK_PERIOD, units='ns')
    dut.fsm_in_0 <= 0
    yield Timer(c_CLK_PERIOD, units='ns')
    assert dut.fsm_out_0 == 1 and dut.fsm_out_1 == 0, "FREE_MODE wrong"
    yield Timer(4*c_CLK_PERIOD, units='ns')
    dut.reset <= 1
    dut.fsm_in_1 <= 0
    yield Timer(2*c_CLK_PERIOD, units='ns')
    assert dut.fsm_out_0 == 0 and dut.fsm_out_1 == 0, "IDLE wrong"
    yield Timer(3*c_CLK_PERIOD, units='ns')
