library IEEE;
use ieee.std_logic_1164.all;
use work.CPU_package.all;

ENTITY multiplexer_TB is
END ENTITY;

ARCHITECTURE test OF multiplexer_TB IS
  
  component Multiplexer
     PORT(  
      sel   : IN std_logic_vector(1 downto 0);  
      data_in_3 : IN data_word; --added by jonthe because if seemed wierd not to include this one.
      data_in_2 : IN data_word;  
      data_in_1 : IN data_bus; -- Potential type problem...  
      data_in_0 : IN data_word;  
      data_out : OUT data_word
      );  
  end component;
  
  signal sel : std_logic_vector(1 downto 0) := "00";
  signal data_in_3 : data_word := "0011";
  signal data_in_2 : data_word := "0010";
  signal data_in_1 : data_bus  := "0001";
  signal data_in_0 : data_word := "0000";
  signal data_out : data_word;
  
  BEGIN
    
  unit: Multiplexer port map(sel, data_in_3, data_in_2, data_in_1, data_in_0, data_out);
  
  test: process
		begin
		
		sel <= "00";
		wait for 20 ns;
		sel <= "01";
		wait for 20 ns;
		sel <= "10";
		wait for 20 ns;
		sel <= "11";
		wait for 20 ns;
		
	end process;
  
  
  
END ARCHITECTURE;