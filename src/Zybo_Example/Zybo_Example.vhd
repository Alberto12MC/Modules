-------------------------------------------------------
--! @file  Zybo_Example.vhd
--! @brief
--! @todo
--! @defgroup Zybo_Example
-------------------------------------------------------

--! Standard library.
library ieee;
--! Logic elements.
use ieee.std_logic_1164.all;
--! arithmetic functions.
use ieee.numeric_std.all;
--! modulos propios
use work.Zybo_Example_regs_pkg.all;

--! @brief   implementation
--! @details implementation of xxx
--! @ingroup Zybo_Example

entity Zybo_Example is
  generic(
      g_AXI_ADDR_WIDTH : integer := 4  -- width of the AXI address bus
  );
  port (
         -- Common
         clk   : in std_logic;
         reset : in std_logic;
         -- In
         Zybo_Example_sw_in : in std_logic_vector(3 downto 0);
         Zybo_Example_bt_in : in std_logic_vector(3 downto 0);
         -- Out
         Zybo_Example_leds_out     : out std_logic_vector(3 downto 0);
         Zybo_Example_leds_rgb_out : out std_logic_vector(5 downto 0);
         -- AXI
         axi_aclk      : in  std_logic;
         axi_aresetn   : in  std_logic;
         s_axi_awaddr  : in  std_logic_vector(g_AXI_ADDR_WIDTH - 1 downto 0);
         s_axi_awprot  : in  std_logic_vector(2 downto 0);
         s_axi_awvalid : in  std_logic;
         s_axi_awready : out std_logic;
         s_axi_wdata   : in  std_logic_vector(31 downto 0);
         s_axi_wstrb   : in  std_logic_vector(3 downto 0);
         s_axi_wvalid  : in  std_logic;
         s_axi_wready  : out std_logic;
         s_axi_araddr  : in  std_logic_vector(g_AXI_ADDR_WIDTH - 1 downto 0);
         s_axi_arprot  : in  std_logic_vector(2 downto 0);
         s_axi_arvalid : in  std_logic;
         s_axi_arready : out std_logic;
         s_axi_rdata   : out std_logic_vector(31 downto 0);
         s_axi_rresp   : out std_logic_vector(1 downto 0);
         s_axi_rvalid  : out std_logic;
         s_axi_rready  : in  std_logic;
         s_axi_bresp   : out std_logic_vector(1 downto 0);
         s_axi_bvalid  : out std_logic;
         s_axi_bready  : in  std_logic
  );
end Zybo_Example;

architecture rtl of Zybo_Example is
-- r0
signal r0_count       : std_logic_vector(31 downto 0) := (others => '0');
signal r0_tc          : std_logic;
signal r0_limit_count : std_logic_vector(31 downto 0) := (others => '0');
signal r0_leds_rgb    : std_logic_vector(2 downto 0) := ("100");
-- AXI regs
signal s_user2regs : user2regs_t;
signal s_regs2user : regs2user_t;

begin

  Zybo_Example_regs_i : Zybo_Example_regs
  generic map (
    AXI_ADDR_WIDTH => g_AXI_ADDR_WIDTH
  )
  port map (
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
    s_axi_bready  => s_axi_bready,
    user2regs     => s_user2regs,
    regs2user     => s_regs2user
  );
  s_user2regs.zybo_example_version_version <= ZYBO_EXAMPLE_VERSION_VERSION_RESET;
  s_user2regs.zybo_example_config_id_config_id <= ZYBO_EXAMPLE_CONFIG_ID_CONFIG_ID_RESET;
  r0_axi_regs : process(clk)
  begin
    if rising_edge(clk) then
      r0_limit_count <= s_regs2user.zybo_example_count_value;
    end if;
  end process;

  r0_counter : process(clk)
  begin
    if rising_edge(clk) then
        if (r0_count <= r0_limit_count) then
          r0_count <= std_logic_vector(unsigned(r0_count) + 1);
          r0_tc <= '0';
        else
          r0_count <= (others => '0');
          r0_tc <= '1';
        end if;
    end if;
  end process;

  r0_shift : process(clk)
  begin
    if rising_edge(clk) then
      if (r0_tc = '1') then
        r0_leds_rgb <= std_logic_vector(shift_right(unsigned(r0_leds_rgb),1));
        r0_leds_rgb(2) <= r0_leds_rgb(0);
      else
        r0_leds_rgb <= r0_leds_rgb;
      end if;
    end if;
  end process;

  -- assign outputs
  Zybo_Example_leds_out <= Zybo_Example_sw_in or Zybo_Example_bt_in;
  Zybo_Example_leds_rgb_out(0) <= r0_leds_rgb(0);
  Zybo_Example_leds_rgb_out(1) <= r0_leds_rgb(1);
  Zybo_Example_leds_rgb_out(2) <= r0_leds_rgb(2);
  Zybo_Example_leds_rgb_out(3) <= r0_leds_rgb(0);
  Zybo_Example_leds_rgb_out(4) <= r0_leds_rgb(1);
  Zybo_Example_leds_rgb_out(5) <= r0_leds_rgb(2);
end rtl;
