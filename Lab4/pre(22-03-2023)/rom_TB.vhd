library IEEE;
use ieee.std_logic_1164.all;
use work.CPU_package.all;
use ieee.numeric_std.all;

ENTITY rom_TB is
END ENTITY;

ARCHITECTURE test OF rom_TB IS
  
  component rom
    PORT(
        adr : IN adress_bus; 
        data : OUT instruction_bus; 
        ce_n : IN std_logic            -- active low
        );
  end component;
  
  signal adr : adress_bus := (others => '0'); 
  signal data : instruction_bus; 
  signal ce_n :  std_logic := '0';           -- active low
  
  BEGIN
    
  unit: rom port map(adr, data, ce_n);
  
  ce_n <= not ce_n after 20 ns;
  adr <= adress_bus(to_unsigned(to_integer(unsigned(adr)) + 1, adr'length)) after 5 ns;
  
END ARCHITECTURE;
