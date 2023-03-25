library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;
use work.CPU_Package.all;

Entity enchip_tb is 
end Entity ; 

Architecture Testbench of enchip_tb is 

    Component enchip is
        port(
            clk_enchip      : in std_logic; -- fast clock
            reset_enchip    : in std_logic; -- active high
            stop_enchip     : in std_logic; -- stops statemachine clk
            choice          : in std_logic; -- address(=0) or data(=1)
            peek_LEDs       : OUT data_bus;
            Q_enchip        : out data_bus  -- output
    );
    end component;

--signaler
signal tb_clk_enchip      :  std_logic:= '0'; -- fast clock
signal tb_reset           :  std_logic:= '0'; -- active high
signal tb_stop_enchip     :  std_logic:= '0'; -- stops statemachine clk
signal tb_choice          :  std_logic:= '0'; -- address(=0) or data(=1)
signal tb_peek_LEDs       :  data_bus;
signal tb_Q_enchip        :  data_bus; -- output

begin   

UUT: Enchip port map(
    clk_enchip => tb_clk_enchip, 
    reset_enchip => tb_reset, 
    stop_enchip => tb_stop_enchip, 
    choice => tb_choice,
    peek_LEDs => tb_peek_LEDs,
    Q_enchip => tb_Q_enchip
    );

tb_clk_enchip <= not tb_clk_enchip after 5 ns;

process
begin

	wait for 5 ns;
  tb_reset <= '1';
	wait for 10 ns;
	tb_reset <= '0';
	wait for 5 ms;
  tb_stop_enchip <= '1';
	end process;

    
end architecture;
    
