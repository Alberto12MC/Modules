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

entity Zybo_Example_tb is
  --vunit
  generic (runner_cfg : string);
end;

architecture bench of Zybo_Example_tb is

  -- Generics
  constant g_AXI_ADDR_WIDTH : integer := 32;
  -- clock period
  constant clk_period : time := 5 ns;
  constant axi_aclk_period : time := 5 ns;
  -- Signal ports
  signal clk           : std_logic;
  signal reset         : std_logic;
  signal Zybo_Example_sw_in        : std_logic_vector(3 downto 0);
  signal Zybo_Example_bt_in        : std_logic_vector(3 downto 0);
  signal Zybo_Example_leds_out     : std_logic_vector(3 downto 0);
  signal Zybo_Example_leds_rgb_out : std_logic_vector(5 downto 0);
  signal axi_aclk      : std_logic;
  signal axi_aresetn   : std_logic;
  signal s_axi_awaddr  : std_logic_vector(g_AXI_ADDR_WIDTH - 1 downto 0);
  signal s_axi_awprot  : std_logic_vector(2 downto 0);
  signal s_axi_awvalid : std_logic;
  signal s_axi_awready : std_logic;
  signal s_axi_wdata   : std_logic_vector(31 downto 0);
  signal s_axi_wstrb   : std_logic_vector(3 downto 0);
  signal s_axi_wvalid  : std_logic;
  signal s_axi_wready  : std_logic;
  signal s_axi_araddr  : std_logic_vector(g_AXI_ADDR_WIDTH - 1 downto 0);
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

  constant BASEADDR : unsigned(31 downto 0) := unsigned'(x"00000000");
  constant ZYBO_EXAMPLE_VERSION_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000000");
  constant ZYBO_EXAMPLE_CONFIG_ID_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000004");
  constant ZYBO_EXAMPLE_COUNT_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000008");
  constant ZYBO_EXAMPLE_VERSION_VERSION_RESET : std_logic_vector(31 downto 0) := std_logic_vector'("00000000000000000000000000000001");
  constant ZYBO_EXAMPLE_CONFIG_ID_CONFIG_ID_RESET : std_logic_vector(31 downto 0) := std_logic_vector'("00000000000000000000000000000001");
  constant ZYBO_EXAMPLE_COUNT_VALUE_RESET : std_logic_vector(31 downto 0) := std_logic_vector'(x"02000000");
  constant axil_bus : bus_master_t := new_bus(data_length => 32, address_length => 32);

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
  Zybo_Example_i : entity src_lib.Zybo_Example
  generic map (
    g_AXI_ADDR_WIDTH => g_AXI_ADDR_WIDTH
  )
  port map (
    clk                       => clk,
    reset                     => reset,
    Zybo_Example_sw_in        => Zybo_Example_sw_in,
    Zybo_Example_bt_in        => Zybo_Example_bt_in,
    Zybo_Example_leds_out     => Zybo_Example_leds_out,
    Zybo_Example_leds_rgb_out => Zybo_Example_leds_rgb_out,
    axi_aclk                  => axi_aclk,
    axi_aresetn               => axi_aresetn,
    s_axi_awaddr              => s_axi_awaddr,
    s_axi_awprot              => s_axi_awprot,
    s_axi_awvalid             => s_axi_awvalid,
    s_axi_awready             => s_axi_awready,
    s_axi_wdata               => s_axi_wdata,
    s_axi_wstrb               => s_axi_wstrb,
    s_axi_wvalid              => s_axi_wvalid,
    s_axi_wready              => s_axi_wready,
    s_axi_araddr              => s_axi_araddr,
    s_axi_arprot              => s_axi_arprot,
    s_axi_arvalid             => s_axi_arvalid,
    s_axi_arready             => s_axi_arready,
    s_axi_rdata               => s_axi_rdata,
    s_axi_rresp               => s_axi_rresp,
    s_axi_rvalid              => s_axi_rvalid,
    s_axi_rready              => s_axi_rready,
    s_axi_bresp               => s_axi_bresp,
    s_axi_bvalid              => s_axi_bvalid,
    s_axi_bready              => s_axi_bready
  );

  test_runner_watchdog(runner, 1 ms);

  main : process
    variable v_rdata_out : std_logic_vector(31 downto 0);
    variable add : unsigned(31 downto 0);
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if run("test_alive") then
        info("Hello world test_alive");
        axi_aresetn <= '0';
        wait for 10 * axi_aclk_period;
        axi_aresetn <= '1';
        -- Read VERSION
        add := BASEADDR + ZYBO_EXAMPLE_VERSION_OFFSET;
        read_bus(net, axil_bus, std_logic_vector(add), v_rdata_out);
        info("AXI-Lite -> Read: " & to_string((unsigned(v_rdata_out))) & " at address: " & to_string((unsigned(add))));
        check(ZYBO_EXAMPLE_VERSION_VERSION_RESET=v_rdata_out, "Version wrong");
        wait for axi_aclk_period;
        -- Read CONFIG_ID
        add := BASEADDR + ZYBO_EXAMPLE_CONFIG_ID_OFFSET;
        read_bus(net, axil_bus, std_logic_vector(add), v_rdata_out);
        info("AXI-Lite -> Read: " & to_string((unsigned(v_rdata_out))) & " at address: " & to_string((unsigned(add))));
        check(ZYBO_EXAMPLE_CONFIG_ID_CONFIG_ID_RESET=v_rdata_out, "Config ID wrong");
        wait for axi_aclk_period;
        -- Read COUNT
        add := BASEADDR + ZYBO_EXAMPLE_COUNT_OFFSET;
        read_bus(net, axil_bus, std_logic_vector(add), v_rdata_out);
        info("AXI-Lite -> Read: " & to_string((unsigned(v_rdata_out))) & " at address: " & to_string((unsigned(add))));
        check(ZYBO_EXAMPLE_COUNT_VALUE_RESET=v_rdata_out, "Count wrong");
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
