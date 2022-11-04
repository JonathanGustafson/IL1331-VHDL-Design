library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clock_divider is
  port(
    stopp : in std_logic;
    ext_clk : in std_logic;
    clk_1hz : out std_logic
    );
end entity;

architecture behaviour of clock_divider is

signal count : std_logic_vector(25 downto 0) := (others => '0');
signal s_clk_1hz : std_logic;

begin

    process(ext_clk)
      begin
        if (rising_edge(ext_clk)) then
            if (count < 49999999) then
                count <= count + 1;
            else
                count <= (others => '0');
                s_clk_1hz <= not s_clk_1hz;
            end if;
        end if;

    end process;

    clk_1hz <= s_clk_1hz;

end architecture;