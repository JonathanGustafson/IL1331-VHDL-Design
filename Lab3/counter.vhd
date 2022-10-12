library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.CPU_Package.all;

ENTITY  counter IS
  PORT(
    clk : IN std_logic;
    step : IN std_logic;
    load_en  : in std_logic; -- active on high
		load_val : in unsigned(operation_size-1 downto 0);
    current_value : OUT unsigned(3 downto 0)
    );
END ENTITY;

ARCHITECTURE RTL OF counter IS
  
  signal count : unsigned(3 downto 0) := (others => '0');
	signal prev_step : std_logic := '0';
	
BEGIN
  process(clk)
    begin
      
      if rising_edge(clk) then
        
        if(load_en = '1') then
          count <= load_val; -- set count to the wanted load value

        elsif (step /= prev_step) then
          count <= count + 1;
          prev_step <= step;
        end if;
        
      end if;
      
  end process;
    
    current_value <= count;
    
END ARCHITECTURE;

