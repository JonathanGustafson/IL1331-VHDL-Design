library IEEE;
use ieee.std_logic_1164.all;
use work.CPU_package.all;

ENTITY ram_TB is
END ENTITY;

ARCHITECTURE test OF ram_TB IS
  
  component ram
     PORT( 
        adr : IN adress_bus; 
        data : INOUT data_bus:= (others => 'Z'); 
        clk : IN std_logic := '0'; 
        ce_n : IN std_logic;   -- active low 
        rw : IN std_logic      -- r=1, w=0
        );  
  end component;
  
        signal adr : adress_bus; 
        signal data : data_bus; 
        signal clk : std_logic := '0'; 
        signal ce_n : std_logic;   -- active low 
        signal rw : std_logic;      -- r=1, w=0
  
  BEGIN
    
  unit: ram port map(adr, data, clk, ce_n, rw);
  
  clk <= not clk after 10 ns;
  
  test: process
  begin
    
    ce_n <= '0'; rw <= '0'; --write
    data <= "0001";
    adr <= "1010";
    wait for 20 ns;
    
    ce_n <= '1'; -- clear databus
    wait for 20 ns;
    
    ce_n <= '0'; rw <= '0'; --write
    data <= "1111";
    adr <= "1110";
    wait for 20 ns;
    
    ce_n <= '1'; -- clear databus
    wait for 20 ns;
    
    ce_n <= '0'; rw <= '1'; -- read
    adr <= "1010";
    wait for 20 ns;
    
    ce_n <= '1'; -- clear databus
    wait for 20 ns;
    
    ce_n <= '0'; rw <= '1'; -- read
    adr <= "1110";
    wait for 20 ns;
    
  end process;
  
END ARCHITECTURE;