-------------------------------------------------------
--! @file  fsm.vhd
--! @brief
--! @todo
--! @defgroup fsm
-------------------------------------------------------

--! Standard library.
library ieee;
--! Logic elements.
use ieee.std_logic_1164.all;
--! arithmetic functions.
use ieee.numeric_std.all;

--! @brief   implementation
--! @details implementation of xxx
--! @ingroup fsm

entity fsm is
  port (
         -- Common
         clk   : in std_logic;
         reset : in std_logic;
         -- Inputs
         fsm_in_0 : in std_logic;
         fsm_in_1 : in std_logic;
         --Outputs
         fsm_out_0 : out std_logic;
         fsm_out_1 : out std_logic
  );
end fsm;

architecture rtl of fsm is
type fsm_states_type is (IDLE, FREE_MODE, FIXED_MODE);
signal fsm_state: fsm_states_type;
attribute enum_encoding: string;
attribute enum_encoding of fsm_states_type: type is "one_hot";

begin
  fsm_process: process(clk)
  begin
    if reset = '1' then
      fsm_state <= IDLE;
      fsm_out_0 <= '0';
      fsm_out_1 <= '0';
    elsif (rising_edge(clk)) then
      fsm_out_0 <= '0';
      fsm_out_1 <= '0';
      case fsm_state is
        when IDLE =>
          fsm_state <= FREE_MODE;
        when FREE_MODE =>
          fsm_out_0 <= '1';
          if fsm_in_0='1' then
            fsm_state <= FIXED_MODE;
          else
            fsm_state <= FREE_MODE;
          end if;
        when FIXED_MODE =>
          fsm_out_1 <= '1';
          if fsm_in_1='1' then
            fsm_state <= FREE_MODE;
          else
            fsm_state <= FIXED_MODE;
          end if;
        when others =>
          fsm_state <= IDLE;
      end case;
    end if;
  end process;

end rtl;
