library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cpu_package.all;

ENTITY ram IS 
  
   PORT( 
        adr : IN adress_bus; 
        data : INOUT data_bus; 
        clk : IN std_logic; 
        ce_n : IN std_logic;   -- active low 
        rw : IN std_logic      -- r=1, w=0
        );  
         
END ENTITY ram; 

ARCHITECTURE RTL OF ram IS 

  type data_buses is array(15 downto 0) of data_bus;
  signal mem : data_buses;

BEGIN
  
  process(clk)
  begin
    
    if rising_edge(clk) then
      if(ce_n = '0' and rw = '0') then
        
        mem(to_integer(unsigned(adr))) <= data;
    
      end if;
    end if;
  end process;
  
  --read from memory to databus when CE_n is low and RW is high, else high impedance
  data <= mem(to_integer(unsigned(adr))) when (ce_n = '0' and rw = '1') else (others => 'Z');
  
END ARCHITECTURE;