library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cpu_package.all;

ENTITY data_buffer IS  
  
 port ( 
  out_en  : IN std_logic;   
  data_in : IN data_word;   
  data_out : OUT data_bus
 );  
 
END ENTITY data_buffer;  
  
ARCHITECTURE RTL OF data_buffer IS  

  BEGIN
    
    process(out_en, data_in)
    begin
      if out_en = '1' then
        data_out <= data_in;
      else
        data_out <= (others => 'Z'); -- high impedance
      end if;
      
    end process;

END ARCHITECTURE; 
