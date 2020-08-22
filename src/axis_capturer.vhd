-------------------------------------------------------
--! @file  axis_capturer.vhd
--! @brief
--! @todo
--! @defgroup axis_capturer
-------------------------------------------------------

--! Standard library.
library ieee;
--! Logic elements.
use ieee.std_logic_1164.all;
--! arithmetic functions.
use ieee.numeric_std.all;
--! @brief   implementation
--! @details implementation of xxx
--! @ingroup axis_capturer

entity axis_capturer is
  generic (
    g_AXIS_DATA_WIDTH : integer := 16; -- width of the AXIS data
    g_AXI_ADDR_WIDTH  : integer := 4
  );
  port (
    -- AXI-Stream clock
    axis_aclk      : in std_logic;
    axis_resetn    : in std_logic;
    -- AXI-Stream Slaves
    s0_axis_tdata  : in std_logic_vector(g_AXIS_DATA_WIDTH - 1 downto 0);
    s0_axis_tvalid : in std_logic;
    -- AXI-Stream Master
    m0_axis_tdata  : out std_logic_vector(g_AXIS_DATA_WIDTH - 1 downto 0);
    m0_axis_tvalid : out std_logic;
    m0_axis_tlast  : out std_logic;
    m0_axis_tready : in std_logic
  );
end axis_capturer;

architecture rtl of axis_capturer is
  -- constants
  constant c_COUNTER_WIDTH : integer                                          := 12;
  -- signals
  -- r0
  signal r0_counter        : std_logic_vector(c_COUNTER_WIDTH - 1 downto 0)   := (others => '0');
  signal r0_axis_tdata     : std_logic_vector(g_AXIS_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal r0_axis_tvalid    : std_logic                                        := '0';
  signal r0_axis_tlast     : std_logic                                        := '0';
begin

  -- counter for TLAST, every 4096 data
  process (axis_aclk)
  begin
    if rising_edge(axis_aclk) then
      if axis_resetn = '0' then
        r0_counter <= (others => '0');
      else
        if s0_axis_tvalid = '1' and m0_axis_tready = '1' then
          r0_counter <= std_logic_vector(unsigned(r0_counter) + 1);
          if r0_counter = x"FFF" then
            r0_axis_tlast <= '1';
          else
            r0_axis_tlast <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;

  -- reg0 to sync w TLAST
  process (axis_aclk)
  begin
    if rising_edge(axis_aclk) then
      if axis_resetn = '0' then
        r0_axis_tdata  <= (others => '0');
        r0_axis_tvalid <= '0';
      else
        r0_axis_tdata  <= s0_axis_tdata;
        r0_axis_tvalid <= s0_axis_tvalid;
      end if;
    end if;
  end process;

  -- assign outputs
  m0_axis_tdata  <= r0_axis_tdata;
  m0_axis_tvalid <= r0_axis_tvalid;
  m0_axis_tlast  <= r0_axis_tlast;

end rtl;