library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

ENTITY  counter IS
  PORT(
    clk : IN std_logic;
    step : IN std_logic;
    load_en  : IN std_logic; -- active on high
		load_val : IN unsigned(3 downto 0);
    current_value : OUT unsigned(3 downto 0);
    seven_seg_value : OUT unsigned(7 downto 0)
    );
END ENTITY;

ARCHITECTURE RTL OF counter IS
  
  signal count : unsigned(3 downto 0) := (others => '0');
	signal prev_step : std_logic := '0';
	
BEGIN
  process(clk)
    begin
      
      if rising_edge(clk) then
        
        if(load_en = '1') then
          count <= load_val; -- set count to the wanted load value

        elsif (step /= prev_step) then
          count <= count + 1;
          prev_step <= step;
        end if;
        
      end if;
      
  end process;

  process(count)
  begin
    -- convert count to 7seg combinations.
    case count is
        when "0000" => seven_seg_value <= "00111111"; -- 0
				when "0001" => seven_seg_value <= "00000110"; -- 1
				when "0010" => seven_seg_value <= "01011011"; -- 2
				when "0011" => seven_seg_value <= "01001111"; -- 3
				when "0100" => seven_seg_value <= "01100110"; -- 4
				when "0101" => seven_seg_value <= "01101101"; -- 5
				when "0110" => seven_seg_value <= "01111101"; -- 6
				when "0111" => seven_seg_value <= "00000111"; -- 7
				when "1000" => seven_seg_value <= "01111111"; -- 8
				when "1001" => seven_seg_value <= "01101111"; -- 9
				when "1010" => seven_seg_value <= "01110111"; -- A
				when "1011" => seven_seg_value <= "01111100"; -- B
				when "1100" => seven_seg_value <= "00111001"; -- C
				when "1101" => seven_seg_value <= "01011110"; -- D
				when "1110" => seven_seg_value <= "01111001"; -- E
				when "1111" => seven_seg_value <= "01110001"; -- F
				when others => seven_seg_value <= "00000000"; -- Nothing
    
    end case ;
  end process;

  current_value <= count;
    
END ARCHITECTURE;

