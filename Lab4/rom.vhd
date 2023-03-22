library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.cpu_package.all;
use work.all;

ENTITY rom IS 
   PORT(
        adr : IN adress_bus; 
        data : OUT instruction_bus; 
        ce_n : IN std_logic            -- active low
        );
                   
END ENTITY rom; 

ARCHITECTURE RTL OF rom IS 

  type rom_array is array(0 to (2 **(adress_size)-1)) of std_logic_vector((instruction_size-1) downto 0);
  
  constant mem : rom_array :=
    ( 
      0  => "1010110011", -- LDI R3, 3
      1  => "1001111110", -- STR R3, 14
      2  => "1010010001", -- LDI R1, 1
      3  => "1000001110", -- LDR R0, 14
      4  => "0110000010", -- MOV R0, R2 
      5  => "0000100110", -- ADD R2, R1, R2
      6  => "0001000100", -- SUB R0, R1, R0 
      7  => "1100001100", -- BRZ 12 
      8  => "1111000101", -- BRA 5  
      9  => "1001101111", -- STR R2, 15
      10 => "0111101000", -- OUT R2 
      11 => "1111001110", -- BRA 14
      12 => "1011000000", -- NOP 
      13 => "1011000000", -- NOP
      others => "1011000000" -- NOP
    );

BEGIN
  process(ce_n, adr)
    begin
      
      if ce_n = '0' then
        data <= mem(conv_integer(unsigned(adr)));
      else
        data <= "ZZZZZZZZZZ";
      end if;
      
    end process;
    
END ARCHITECTURE;