library IEEE;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.cpu_package.all;

ENTITY Multiplexer IS  
    PORT(  
      sel   : IN unsigned(1 downto 0);  
      data_in_3 : IN data_word; --added by jonthe because if seemed wierd not to include this one.
      data_in_2 : IN data_word;  
      data_in_1 : IN data_bus; -- Potential type problem...  
      data_in_0 : IN data_word;  
      data_out : OUT data_word
      );  
      
END ENTITY Multiplexer;  
  
ARCHITECTURE RTL OF Multiplexer IS   
  
  BEGIN
  process(sel, data_in_0, data_in_1, data_in_2, data_in_3)
    begin
    
    case sel is
      when "00" => data_out <= data_in_0;
      when "01" => data_out <= data_in_1;
      when "10" => data_out <= data_in_2;
      when "11" => data_out <= data_in_3;
      when others => NULL;
    end case;
    
  end process;
   
END ARCHITECTURE;