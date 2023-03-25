library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

package CPU_Package is
  
  constant adress_size : integer := 8;
  constant data_size : integer := 8;
  constant operation_size : integer := 4;
  constant instruction_size : integer := 10;
  
  subtype data_word is std_logic_vector((data_size-1) downto 0);
  subtype adress_bus is std_logic_vector((adress_size-1) downto 0);
  subtype data_bus is std_logic_vector((data_size-1) downto 0);
  subtype instruction_bus is std_logic_vector((instruction_size-1) downto 0);
  subtype program_word is std_logic_vector((instruction_size-1) downto 0);
  subtype command_word is std_logic_vector((operation_size-1) downto 0);
  
  function add_overflow(a, b : std_logic_vector)
		return std_logic_vector;
		
	function sub_overflow(a, b : std_logic_vector)
		return std_logic_vector;
  
end package;

package body CPU_Package is
  
  --addition function that adds one bit to the result which is used to check for overflow
  function add_overflow(a, b : std_logic_vector)
    return std_logic_vector is
		variable y : std_logic_vector(a'length downto 0);
		
		begin
		  y := ('0' & a) + ('0' & b); --Add a zero to both a and b to extend to n+1 bits
		  return y;  
		
  end function;
  
  --subtraction function that adds one bit to the result which is used to check for overflow
  function sub_overflow(a, b : std_logic_vector)
  return std_logic_vector is
  variable y : std_logic_vector(a'length downto 0);
  
  begin
    y := ('0' & a) - ('0' & b); --Add a zero to both a and b to extend to n+1 bits
    return y;
    
end function;
  
end package body;