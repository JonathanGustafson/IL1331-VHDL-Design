  library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clock_divider is
  port(
    stop_clk : in std_logic;
    in_clk : in std_logic;
    clk_1hz : out std_logic
    );
end entity;

architecture behaviour of clock_divider is

signal count : std_logic_vector(25 downto 0) := (others => '0');
--signal s_stop_clk : std_logic := '0';
signal s_clk_1hz : std_logic := '0'; --49999999

begin

    process(in_clk)
      begin
        if (rising_edge(in_clk)) then
            if (count < 0) then        --set to 49999999 for 1hz, set to 0 for ease of simulation
                count <= count + 1;
            else
                count <= (others => '0');
                s_clk_1hz <= not(s_clk_1hz);
            end if;
        end if;
      
        if(stop_clk = '0') then
          clk_1hz <= s_clk_1hz;
        end if;
    end process;

end architecture;