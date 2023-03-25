library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;
use work.CPU_Package.all;

entity clock_divider_tb is
end entity;

architecture Testbench of clock_divider_tb is 

    component clock_divider is
        port(
          stop_clk : in std_logic;
          in_clk : in std_logic;
          clk_1hz : out std_logic
    );
    end component;
    
    signal s_stop_clk : std_logic := '0';
    signal s_in_clk : std_logic := '0';
    signal s_clk_1hz : std_logic;
    
    begin
    UUT: clock_divider port map(
    s_stop_clk, 
    s_in_clk, 
    s_clk_1hz);

    s_in_clk <= not s_in_clk after 20 ns;
    s_stop_clk <= not s_stop_clk after 4000 ns;

end architecture;