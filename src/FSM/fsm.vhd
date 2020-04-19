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
         fsm_out_1 : out std_logic;
         fsm_out_2 : out std_logic
  );
end fsm;

architecture rtl of fsm is
type fsm_states_type is (idle, read1, read2);
signal fsm_state: fsm_states_type;

begin
  fsm_process: process(clk, reset)
  begin
    if reset = '1' then
      state <= S0;
      Z <= '0';
    elsif (rising_edge(clk)) then
      case fsm_state is
        when S0 =>
          if X = '0' then
            state <= S0;
          elsif X = '1' then
            state <= S1;
          end if;
            Z <= '0';
        when S1 =>

        when others =>
          state <= idle;
          Z <= '0';
      end case;
    end if;
  end process;

end rtl;
