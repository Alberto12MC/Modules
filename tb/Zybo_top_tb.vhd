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
library bitvis_vip_axilite;
use bitvis_vip_axilite.axilite_bfm_pkg.all;
--
library uvvm_util;
context uvvm_util.uvvm_util_context;
use uvvm_util.methods_pkg.all;
-- vunit
library vunit_lib;
context vunit_lib.vunit_context;
-- use vunit_lib.array_pkg.all;
-- use vunit_lib.lang.all;
-- use vunit_lib.string_ops.all;
-- use vunit_lib.dictionary.all;
-- use vunit_lib.path.all;
-- use vunit_lib.log_types_pkg.all;
-- use vunit_lib.log_special_types_pkg.all;
-- use vunit_lib.log_pkg.all;
-- use vunit_lib.check_types_pkg.all;
-- use vunit_lib.check_special_types_pkg.all;
-- use vunit_lib.check_pkg.all;
-- use vunit_lib.run_types_pkg.all;
-- use vunit_lib.run_special_types_pkg.all;
-- use vunit_lib.run_base_pkg.all;
-- use vunit_lib.run_pkg.all;

entity zybo_top_tb is
  --vunit
  generic (runner_cfg : string);
end;

architecture bench of zybo_top_tb is

  -- Generics
  constant AXI_ADDR_WIDTH : integer := 0;
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

  constant C_AXILITE_BFM_CONFIG : t_axilite_bfm_config := C_AXILITE_BFM_CONFIG_DEFAULT;
  subtype ST_AXILite_32 is t_axilite_if (
  write_address_channel (
  awaddr(31 downto 0)),
  write_data_channel (
  wdata(31 downto 0),
  wstrb(3 downto 0)),
  read_address_channel (
  araddr(31 downto 0)),
  read_data_channel (
  rdata(31 downto 0))
  );
  signal axilite_if : ST_AXILite_32;
  constant BASEADDR : integer := to_integer(unsigned'(x"00000000"));

begin
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
    s_axi_awaddr  => axilite_if.write_address_channel.awaddr,
    s_axi_awprot  => axilite_if.write_address_channel.awprot,
    s_axi_awvalid => axilite_if.write_address_channel.awvalid,
    s_axi_awready => axilite_if.write_address_channel.awready,
    s_axi_wdata   => axilite_if.write_data_channel.wdata,
    s_axi_wstrb   => axilite_if.write_data_channel.wstrb,
    s_axi_wvalid  => axilite_if.write_data_channel.wvalid,
    s_axi_wready  => axilite_if.write_data_channel.wready,
    s_axi_araddr  => axilite_if.read_address_channel.araddr,
    s_axi_arprot  => axilite_if.read_address_channel.arprot,
    s_axi_arvalid => axilite_if.read_address_channel.arvalid,
    s_axi_arready => axilite_if.read_address_channel.arready,
    s_axi_rdata   => axilite_if.read_data_channel.rdata,
    s_axi_rresp   => axilite_if.read_data_channel.rresp,
    s_axi_rvalid  => axilite_if.read_data_channel.rvalid,
    s_axi_rready  => axilite_if.read_data_channel.rready,
    s_axi_bresp   => axilite_if.write_response_channel.bresp,
    s_axi_bvalid  => axilite_if.write_response_channel.bvalid,
    s_axi_bready  => axilite_if.write_response_channel.bready
  );

  main : process
    variable data_read  : std_logic_vector(31 downto 0);
    variable add        : unsigned(31 downto 0) := unsigned'(x"00000000");
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if run("test_alive") then
        info("Hello world test_alive");
        axi_aresetn <= '0';
        wait for 10 * axi_aclk_period;
        axi_aresetn <= '1';

        wait for 10 * axi_aclk_period;
        axilite_if <= init_axilite_if_signals(32, 32);
        wait for 10 * axi_aclk_period;
        axilite_read(x"00000000", v_data_out, "Read count", axi_aclk, axilite_if);
        wait for 100 * axi_aclk_period;
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
