--! Standard library.
library ieee;
--! Logic elements.
use ieee.std_logic_1164.all;
--! Arithmetic functions.
use ieee.numeric_std.all;
--
library std;
use std.textio.all;
--
library src_lib;
-- use src_lib.types_declaration_zybo_top_pkg.all;
--
-- vunit
library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;

-- OSVVM
library osvvm;
use osvvm.RandomPkg.all;

entity zybo_top_tb is
  --vunit
  generic (runner_cfg : string);
end;

architecture bench of zybo_top_tb is

  -- Generics
  constant AXI_ADDR_WIDTH : integer := 32;
  -- clock period
  constant clk_period : time := 5 ns;
  constant axi_aclk_period : time := 5 ns;
  -- Signal ports
  signal clk           : std_logic;
  signal reset         : std_logic;
  signal sw0_in        : std_logic;
  signal sw1_in        : std_logic;
  signal sw2_in        : std_logic;
  signal sw3_in        : std_logic;
  signal bt0_in        : std_logic;
  signal bt1_in        : std_logic;
  signal bt2_in        : std_logic;
  signal bt3_in        : std_logic;
  signal led0_out      : std_logic;
  signal led1_out      : std_logic;
  signal led2_out      : std_logic;
  signal led3_out      : std_logic;
  signal led5r_out     : std_logic;
  signal led5g_out     : std_logic;
  signal led5b_out     : std_logic;
  signal led6r_out     : std_logic;
  signal led6g_out     : std_logic;
  signal led6b_out     : std_logic;
  signal axi_aclk      : std_logic;
  signal axi_aresetn   : std_logic;
  signal s_axi_awaddr  : std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
  signal s_axi_awprot  : std_logic_vector(2 downto 0);
  signal s_axi_awvalid : std_logic;
  signal s_axi_awready : std_logic;
  signal s_axi_wdata   : std_logic_vector(31 downto 0);
  signal s_axi_wstrb   : std_logic_vector(3 downto 0);
  signal s_axi_wvalid  : std_logic;
  signal s_axi_wready  : std_logic;
  signal s_axi_araddr  : std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
  signal s_axi_arprot  : std_logic_vector(2 downto 0);
  signal s_axi_arvalid : std_logic;
  signal s_axi_arready : std_logic;
  signal s_axi_rdata   : std_logic_vector(31 downto 0);
  signal s_axi_rresp   : std_logic_vector(1 downto 0);
  signal s_axi_rvalid  : std_logic;
  signal s_axi_rready  : std_logic;
  signal s_axi_bresp   : std_logic_vector(1 downto 0);
  signal s_axi_bvalid  : std_logic;
  signal s_axi_bready  : std_logic;

  constant BASEADDR : std_logic_vector(31 downto 0) := x"00000000";
  constant axil_bus : bus_master_t := new_bus(data_length => 32, address_length => 32);
  constant COUNT_VALUE : std_logic_vector(31 downto 0) := std_logic_vector'("00000010000000000000000000000000");

begin
  -- AXI-Lite BFM
  axi_lite_master_inst: entity vunit_lib.axi_lite_master
    generic map (
      bus_handle => axil_bus)
    port map (
      aclk    => clk,
      arready => s_axi_arready,
      arvalid => s_axi_arvalid,
      araddr  => s_axi_araddr,
      rready  => s_axi_rready,
      rvalid  => s_axi_rvalid,
      rdata   => s_axi_rdata,
      rresp   => s_axi_rresp,
      awready => s_axi_awready,
      awvalid => s_axi_awvalid,
      awaddr  => s_axi_awaddr,
      wready  => s_axi_wready,
      wvalid  => s_axi_wvalid,
      wdata   => s_axi_wdata,
      wstrb   => s_axi_wstrb,
      bvalid  => s_axi_bvalid,
      bready  => s_axi_bready,
      bresp   => s_axi_bresp);

  -- Instance
  zybo_top_i : entity src_lib.zybo_top
  generic map (
    AXI_ADDR_WIDTH => AXI_ADDR_WIDTH
  )
  port map (
    clk           => clk,
    reset         => reset,
    sw0_in        => sw0_in,
    sw1_in        => sw1_in,
    sw2_in        => sw2_in,
    sw3_in        => sw3_in,
    bt0_in        => bt0_in,
    bt1_in        => bt1_in,
    bt2_in        => bt2_in,
    bt3_in        => bt3_in,
    led0_out      => led0_out,
    led1_out      => led1_out,
    led2_out      => led2_out,
    led3_out      => led3_out,
    led5r_out     => led5r_out,
    led5g_out     => led5g_out,
    led5b_out     => led5b_out,
    led6r_out     => led6r_out,
    led6g_out     => led6g_out,
    led6b_out     => led6b_out,
    axi_aclk      => axi_aclk,
    axi_aresetn   => axi_aresetn,
    s_axi_awaddr  => s_axi_awaddr,
    s_axi_awprot  => s_axi_awprot,
    s_axi_awvalid => s_axi_awvalid,
    s_axi_awready => s_axi_awready,
    s_axi_wdata   => s_axi_wdata,
    s_axi_wstrb   => s_axi_wstrb,
    s_axi_wvalid  => s_axi_wvalid,
    s_axi_wready  => s_axi_wready,
    s_axi_araddr  => s_axi_araddr,
    s_axi_arprot  => s_axi_arprot,
    s_axi_arvalid => s_axi_arvalid,
    s_axi_arready => s_axi_arready,
    s_axi_rdata   => s_axi_rdata,
    s_axi_rresp   => s_axi_rresp,
    s_axi_rvalid  => s_axi_rvalid,
    s_axi_rready  => s_axi_rready,
    s_axi_bresp   => s_axi_bresp,
    s_axi_bvalid  => s_axi_bvalid,
    s_axi_bready  => s_axi_bready
  );

  test_runner_watchdog(runner, 1 ms);

  main : process
    variable v_rdata_out : std_logic_vector(31 downto 0);
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if run("test_alive") then
        info("Hello world test_alive");
        axi_aresetn <= '0';
        wait for 10 * axi_aclk_period;
        axi_aresetn <= '1';
        -- Read reg 0
        -- read_axi_lite(net, axil_bus, BASEADDR, axi_resp_okay, v_rdata_out);
        read_bus(net, axil_bus, BASEADDR, v_rdata_out);
        info("Read value: " & to_string((unsigned(v_rdata_out))));
        check(COUNT_VALUE=v_rdata_out, "Reg value ");
        wait for 10 * axi_aclk_period;
        test_runner_cleanup(runner);
      end if;
    end loop;
  end process;

  axi_aclk_process :process
  begin
    axi_aclk <= '1';
    wait for axi_aclk_period/2;
    axi_aclk <= '0';
    wait for axi_aclk_period/2;
  end process;

  clk_process :process
  begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
  end process;

end;
