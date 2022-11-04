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
      load_en  : in std_logic; -- active high
			load_val : in unsigned(operation_size-1 downto 0);
      current_value : OUT unsigned(3 downto 0);
      seven_seg_value : OUT unsigned(7 downto 0)
    );
	end component;
	
	signal clk : std_logic := '0';
	signal step : std_logic := '0';
	signal load_en  : std_logic := '0';
	signal load_val : unsigned(operation_size-1 downto 0);
	signal current_value : unsigned(3 downto 0) := (others => '0');
	signal seven_seg_value : unsigned(7 downto 0);
	
	
BEGIN
  
  UUT : counter port map(clk, step, load_en, load_val, current_value, seven_seg_value);
    
    clk <= not clk after 10 ns;
    
    process begin
      wait for 100 ns;
      step <= not step;
      wait for 40 ns;
    end process;
    
END ARCHITECTURE;
