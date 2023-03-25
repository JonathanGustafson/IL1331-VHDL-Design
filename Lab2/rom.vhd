library IEEE;
use ieee.std_logic_1164.all;
use work.cpu_package.all;

ENTITY rom IS 
   PORT(
        adr : IN adress_bus; 
        data : OUT instruction_bus; 
        ce_n : IN std_logic            -- active low
        );
                   
END ENTITY rom; 

ARCHITECTURE RTL OF rom IS 

  --type rom_array is array(0 to 2**adress_size) of std_logic_vector(adress_size downto 0);

BEGIN
  process(ce_n, adr)
    begin
      
      if ce_n = '0' then
        case adr is
        
        when "00000000" => data <= "1010110011"; -- LDI R3, 3
        when "00000001" => data <= "1001111110"; -- STR R3, 14
        when "00000010" => data <= "1010010001"; -- LDI R1, 1
        when "00000011" => data <= "1000001110"; -- LDR R0, 14
        when "00000100" => data <= "0110000010"; -- MOV R0, R2 
        when "00000101" => data <= "0000100110"; -- ADD R2, R1, R2
        when "00000110" => data <= "0001000100"; -- SUB R0, R1, R0 
        when "00000111" => data <= "1100001100"; -- BRZ 12 
        when "00001000" => data <= "1011000000"; -- NOP
        when "00001001" => data <= "1111000101"; -- BRA 5  
        when "00001100" => data <= "1001101111"; -- STR R2, 15
        when "00001101" => data <= "0111101000"; -- OUT R2 
        when "00001110" => data <= "1111001110"; -- BRA 14
        when others     => data <= "1011000000"; -- NOP
          
        end case;
      else
        data <= "ZZZZZZZZZZ";
      end if;
      
    end process;
    
END ARCHITECTURE;