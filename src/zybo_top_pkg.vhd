-------------------------------------------------------
--! @file  zybo_top_pkg.vhd
--! @brief Core package
--! @todo
--! @defgroup zybo
-------------------------------------------------------

--! Standard library.
library ieee;
--! Logic elements.
use ieee.std_logic_1164.all;
--! arithmetic functions.
use ieee.numeric_std.all;

--! @brief   package
--! @details package of xxx
--! @ingroup zybo

package zybo_top_pkg is

  component zybo_top is
    generic (
      AXI_ADDR_WIDTH : integer := 4
    );
    port (
      clk           : in  std_logic;
      reset         : in  std_logic;
      sw0_in        : in  std_logic;
      sw1_in        : in  std_logic;
      sw2_in        : in  std_logic;
      sw3_in        : in  std_logic;
      bt0_in        : in  std_logic;
      bt1_in        : in  std_logic;
      bt2_in        : in  std_logic;
      bt3_in        : in  std_logic;
      led0_out      : out std_logic;
      led1_out      : out std_logic;
      led2_out      : out std_logic;
      led3_out      : out std_logic;
      led5r_out     : out std_logic;
      led5g_out     : out std_logic;
      led5b_out     : out std_logic;
      led6r_out     : out std_logic;
      led6g_out     : out std_logic;
      led6b_out     : out std_logic;
      axi_aclk      : in  std_logic;
      axi_aresetn   : in  std_logic;
      s_axi_awaddr  : in  std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
      s_axi_awprot  : in  std_logic_vector(2 downto 0);
      s_axi_awvalid : in  std_logic;
      s_axi_awready : out std_logic;
      s_axi_wdata   : in  std_logic_vector(31 downto 0);
      s_axi_wstrb   : in  std_logic_vector(3 downto 0);
      s_axi_wvalid  : in  std_logic;
      s_axi_wready  : out std_logic;
      s_axi_araddr  : in  std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
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
  end component;

end package;
