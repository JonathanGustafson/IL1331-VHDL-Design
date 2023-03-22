library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cpu_package.all;

ENTITY RegisterFile IS  
  
   PORT(
     
    clk : IN std_logic; 
    data_in : IN data_word; 
    data_out_1  : OUT data_word; 
    data_out_0  : OUT data_word; 
    sel_in  : IN std_logic_vector (1 downto 0);   
    sel_out_1   : IN std_logic_vector (1 downto 0);   
    sel_out_0   : IN std_logic_vector (1 downto 0);  
    rw_reg  : in std_logic --write = 0 
    
    ); 
  
END ENTITY RegisterFile;  
  
ARCHITECTURE RTL OF RegisterFile IS  

  type data_words is array(3 downto 0) of data_word;
  signal registers: data_words;

  BEGIN
    process(clk)
      begin
        if rising_edge(clk) then
          if rw_reg = '0' then
            registers(to_integer(unsigned(sel_in))) <= data_in;
          end if;
        end if;
    end process;
      
      data_out_1 <= registers(to_integer(unsigned(sel_out_1)));
      data_out_0 <= registers(to_integer(unsigned(sel_out_0)));
      
END ARCHITECTURE;
