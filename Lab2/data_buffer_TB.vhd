library IEEE;
use ieee.std_logic_1164.all;
use work.CPU_package.all;

ENTITY data_buffer_TB is
END ENTITY;

ARCHITECTURE test OF data_buffer_TB IS
  
  component DataBuffer
    port(     
      out_en  : IN std_logic;   
      data_in : IN data_word;   
      data_out : OUT data_bus
    );
  end component;
  
  signal out_en : std_logic := '0';
  signal data_in : data_word := (others => '0');
  signal data_out : data_word;
  
  BEGIN
    
  unit: DataBuffer port map(out_en, data_in, data_out);
  
  out_en <= not out_en after 80 ns;
  
  data_in(0) <= not data_in(0) after 5 ns;
  data_in(1) <= not data_in(1) after 10 ns;
  data_in(2) <= not data_in(2) after 20 ns;
  data_in(3) <= not data_in(3) after 40 ns;
  
END ARCHITECTURE;