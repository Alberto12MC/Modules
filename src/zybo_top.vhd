-------------------------------------------------------
--! @file  zybo_top.vhd
--! @brief sum calculation
--! @todo
--! @defgroup zybo
-------------------------------------------------------

--! Standard library.
library ieee;
--! Logic elements.
use ieee.std_logic_1164.all;
--! arithmetic functions.
use ieee.numeric_std.all;
--! modulos propios
use work.zybo_regs_pkg.all;

--! @brief   implementation
--! @details implementation of xxx
--! @ingroup zybo

entity zybo_top is
  generic(
      AXI_ADDR_WIDTH : integer := 4  -- width of the AXI address bus
  );
  port (
         clk      : in std_logic;
         reset    : in std_logic;
         sw0_in   : in std_logic;
         sw1_in   : in std_logic;
         sw2_in   : in std_logic;
         sw3_in   : in std_logic;
         bt0_in   : in std_logic;
         bt1_in   : in std_logic;
         bt2_in   : in std_logic;
         bt3_in   : in std_logic;
         led0_out : out std_logic;
         led1_out : out std_logic;
         led2_out : out std_logic;
         led3_out : out std_logic;
         led5r_out : out std_logic;
         led5g_out : out std_logic;
         led5b_out : out std_logic;
         led6r_out : out std_logic;
         led6g_out : out std_logic;
         led6b_out : out std_logic;
         -- AXI
         -- Clock and Reset
         axi_aclk    : in  std_logic;
         axi_aresetn : in  std_logic;
         -- AXI Write Address Channel
         s_axi_awaddr  : in  std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
         s_axi_awprot  : in  std_logic_vector(2 downto 0);
         s_axi_awvalid : in  std_logic;
         s_axi_awready : out std_logic;
         -- AXI Write Data Channel
         s_axi_wdata   : in  std_logic_vector(31 downto 0);
         s_axi_wstrb   : in  std_logic_vector(3 downto 0);
         s_axi_wvalid  : in  std_logic;
         s_axi_wready  : out std_logic;
         -- AXI Read Address Channel
         s_axi_araddr  : in  std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
         s_axi_arprot  : in  std_logic_vector(2 downto 0);
         s_axi_arvalid : in  std_logic;
         s_axi_arready : out std_logic;
         -- AXI Read Data Channel
         s_axi_rdata   : out std_logic_vector(31 downto 0);
         s_axi_rresp   : out std_logic_vector(1 downto 0);
         s_axi_rvalid  : out std_logic;
         s_axi_rready  : in  std_logic;
         -- AXI Write Response Channel
         s_axi_bresp   : out std_logic_vector(1 downto 0);
         s_axi_bvalid  : out std_logic;
         s_axi_bready  : in  std_logic
  );
end zybo_top;

architecture rtl of zybo_top is
signal r0_count : std_logic_vector(27 downto 0) := (others => '0');
signal r0_pulse : std_logic_vector(2 downto 0) := (others => '0');
signal r0_limit_count : std_logic_vector(31 downto 0) := (others => '0');
signal s_user2regs : user2regs_t;
signal s_regs2user : regs2user_t;

begin

  zybo_regs_i : zybo_regs
  generic map (
    AXI_ADDR_WIDTH => AXI_ADDR_WIDTH
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

  regs_axi_regs : process(clk)
  begin
    if rising_edge(clk) then
      r0_limit_count <= s_regs2user.count_value;
    end if;
  end process;

  contador_pulsos : process(clk)
  begin
    if rising_edge(clk) then
        if (r0_count < r0_limit_count) then
          r0_count <= std_logic_vector(unsigned(r0_count) + 1);
          r0_pulse <= r0_pulse;
        else
          r0_count <= (others => '0');
          r0_pulse <= std_logic_vector(unsigned(r0_pulse) + 1);
        end if;
    end if;
  end process;

  led0_out <= sw0_in or bt0_in;
  led1_out <= sw1_in or bt1_in;
  led2_out <= sw2_in or bt2_in;
  led3_out <= sw3_in or bt3_in;
  led5r_out <= r0_pulse(0);
  led5g_out <= not r0_pulse(2);
  led5b_out <= r0_pulse(1);
  led6r_out <= r0_pulse(2);
  led6g_out <= r0_pulse(1);
  led6b_out <= not r0_pulse(0);
end rtl;
