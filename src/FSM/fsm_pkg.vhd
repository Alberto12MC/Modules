-------------------------------------------------------
--! @file  fsm_pkg.vhd
--! @brief Core package
--! @todo
--! @defgroup fsm
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

package fsm_pkg is

  component fsm is
  port (
    clk       : in  std_logic;
    reset     : in  std_logic;
    fsm_in_0  : in  std_logic;
    fsm_in_1  : in  std_logic;
    fsm_out_0 : out std_logic;
    fsm_out_1 : out std_logic
  );
  end component;

end package;
