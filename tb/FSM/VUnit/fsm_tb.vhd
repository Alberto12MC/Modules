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
-- use src_lib.types_declaration_fsm_pkg.all;
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

entity fsm_tb is
  --vunit
  generic (runner_cfg : string);
end;

architecture bench of fsm_tb is

  -- Generics
  -- clock period
  constant clk_period : time := 10 ns;
  -- Signal ports
  signal clk       : std_logic;
  signal reset     : std_logic;
  signal fsm_in_0  : std_logic;
  signal fsm_in_1  : std_logic;
  signal fsm_out_0 : std_logic;
  signal fsm_out_1 : std_logic;

begin
  -- Instance
  fsm_i : entity src_lib.fsm
  port map (
    clk       => clk,
    reset     => reset,
    fsm_in_0  => fsm_in_0,
    fsm_in_1  => fsm_in_1,
    fsm_out_0 => fsm_out_0,
    fsm_out_1 => fsm_out_1
  );

  main : process
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if run("test_alive") then
        info("Hello world test_alive");
        wait for 100 ns;
        test_runner_cleanup(runner);

      elsif run("test_0") then
        info("Hello world test_0");
        reset <= '1';
        fsm_in_0 <= '0';
        fsm_in_1 <= '0';
        wait for clk_period;
        reset <= '0';
        wait for 2*clk_period;
        check(fsm_out_0='1' and fsm_out_1='0', "FREE_MODE wrong");
        fsm_in_0 <= '1';
        wait for 2*clk_period;
        check(fsm_out_0='0' and fsm_out_1='1', "FIXED_MODE wrong");
        fsm_in_1 <= '1';
        wait for clk_period;
        fsm_in_0 <= '0';
        wait for clk_period;
        check(fsm_out_0='1' and fsm_out_1='0', "FREE_MODE wrong");
        wait for 4*clk_period;
        reset <= '1';
        fsm_in_1 <= '0';
        wait for 2*clk_period;
        check(fsm_out_0='0' and fsm_out_1='0', "IDLE wrong");
        wait for 3*clk_period;
        test_runner_cleanup(runner);
      end if;
    end loop;
  end process;

  clk_process :process
  begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
  end process;

end;
