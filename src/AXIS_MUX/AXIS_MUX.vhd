-------------------------------------------------------
--! @file  AXIS_MUX.vhd
--! @brief
--! @todo
--! @defgroup AXIS_MUX
-------------------------------------------------------

--! Standard library.
library ieee;
--! Logic elements.
use ieee.std_logic_1164.all;
--! arithmetic functions.
use ieee.numeric_std.all;
use work.AXIS_MUX_regs_pkg.all;
--! @brief   implementation
--! @details implementation of xxx
--! @ingroup AXIS_MUX

entity AXIS_MUX is
  generic(
      g_AXIS_DATA_WIDTH : integer := 32;  -- width of the AXIS data
      g_AXI_ADDR_WIDTH : integer := 4
  );
  port (
     -- AXI-Stream clock
     axis_aclk : in std_logic;
     -- AXI-Stream Slaves
     s0_axis_tdata  : in std_logic_vector(g_AXIS_DATA_WIDTH-1 downto 0);
     s0_axis_tvalid : in std_logic;
     s1_axis_tdata  : in std_logic_vector(g_AXIS_DATA_WIDTH-1 downto 0);
     s1_axis_tvalid : in std_logic;
     -- AXI-Stream Master
     m_axis_tdata  : out std_logic_vector(g_AXIS_DATA_WIDTH-1 downto 0);
     m_axis_tvalid : out std_logic;
     -- AXI-Lite
     -- Clock and Reset
     axi_aclk    : in  std_logic;
     axi_aresetn : in  std_logic;
     -- AXI Write Address Channel
     s_axi_awaddr  : in  std_logic_vector(g_AXI_ADDR_WIDTH - 1 downto 0);
     s_axi_awprot  : in  std_logic_vector(2 downto 0); -- sigasi @suppress "Unused port"
     s_axi_awvalid : in  std_logic;
     s_axi_awready : out std_logic;
     -- AXI Write Data Channel
     s_axi_wdata   : in  std_logic_vector(31 downto 0);
     s_axi_wstrb   : in  std_logic_vector(3 downto 0);
     s_axi_wvalid  : in  std_logic;
     s_axi_wready  : out std_logic;
     -- AXI Read Address Channel
     s_axi_araddr  : in  std_logic_vector(g_AXI_ADDR_WIDTH - 1 downto 0);
     s_axi_arprot  : in  std_logic_vector(2 downto 0); -- sigasi @suppress "Unused port"
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
end AXIS_MUX;

architecture rtl of AXIS_MUX is
  -- signals
  signal s_user2regs: user2regs_t;
  signal s_regs2user: regs2user_t;
  -- r0
  signal r0_resetn : std_logic;
  signal r0_select : std_logic;
begin

  -- AXI-Lite
  AXIS_MUX_regs_i : AXIS_MUX_regs
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

  -- Reg 
  process(axis_aclk)
  begin
    if rising_edge(axis_aclk) then
      r0_resetn <= s_regs2user.axis_mux_control_resetn(0);
      r0_select <= s_regs2user.axis_mux_control_select(0);
    end if;
  end process;

  -- MUX
  MUX: process(axis_aclk)
  begin
      if rising_edge(axis_aclk) then
        if r0_resetn = '0' then
          m_axis_tdata <= (others => '0');
          m_axis_tvalid <= '0';
        else
          if r0_select = '0' then
            m_axis_tdata <= s0_axis_tdata;
            m_axis_tvalid <= s0_axis_tvalid;
          else
            m_axis_tdata <= s1_axis_tdata;
            m_axis_tvalid <= s1_axis_tvalid;
          end if;
        end if;
      end if;
  end process;

end rtl;
