library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all; 
use work.CPU_Package.all;

ENTITY ALU IS  
   PORT(  
      Op : IN unsigned(2 downto 0); 
      A : IN data_word;  
      B : IN data_word; 
      En : IN std_logic; 
      clk : IN std_logic; 
      y  : OUT data_word; 
      n_flag: OUT std_logic; 
      z_flag: OUT std_logic;  
      o_flag: OUT std_logic  
   );  
END ALU;  

Architecture RTL of ALU is 

  constant ZERO : std_logic_vector(data_size-1 downto 0) := (others => '0');
  
  begin process(Op, A, B, En, clk)
    
    variable tmp : std_logic_vector(data_size downto 0) := (others => '0');
    
    begin
     if En = '1' and rising_edge(clk) then
      case Op is
        
      when "000" =>
        tmp := add_overflow(a,b);
        y <= tmp(tmp'left-1 downto 0);
      
      when "001" =>
        tmp := sub_overflow(a,b);
        y <= tmp(tmp'left-1 downto 0);
      
      when "010" =>
        y <= A and B;
      
      when "011" =>
        y <= A or B;
      
      when "100" => 
        y <= A xor B;
        
      when "101" => 
        y <= not A;
        
      when "110" =>
        y <= A;
    
      when others =>
        NULL;
      
      end case;
      
      --check msb (not caring about overflow bit)
      n_flag <= tmp(tmp'left-1);
      
      --check if output is 0
      if tmp(tmp'left-1 downto 0) = ZERO then z_flag <= '1'; else z_flag <= '0'; end if;
        
      --Check for overflow during add or sub operations
      if (Op = "000" or Op = "001") then o_flag <= tmp(tmp'left) xor tmp(tmp'left-1) xor a(a'left) xor b(b'left); end if;
      
    end if;
    
  end process;

end RTL;