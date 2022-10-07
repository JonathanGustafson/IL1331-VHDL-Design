library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.CPU_Package.all;

ENTITY  counter_TB IS
END ENTITY;

ARCHITECTURE test OF counter_TB IS
  component counter is
    PORT(
      clk : IN std_logic;
      step : IN std_logic;
      current_value : OUT unsigned(3 downto 0)
    );
	end component;
	
	signal clk : std_logic := '0';
	signal step : std_logic := '0';
	signal current_value : unsigned(operation_size-1 downto 0) := (others => '0');
	
	
BEGIN
  
  unit : counter port map(clk, step, current_value);
    
    clk <= not clk after 10 ns;
    
    process begin
      step <= not step;
      wait for 40 ns;
    end process;
    
END ARCHITECTURE;