library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.all;
use work.CPU_package.all;

entity out_buffer is
    port(
        clk, out_en : IN std_logic;
        data_in     : IN data_word;
        Q           : OUT data_word 
    );
end entity;

Architecture behave of out_buffer is
begin
    process(clk)
    begin
        if (rising_edge(clk) AND (out_en = '1')) then
                Q <= data_in;
        end if;
    end process;
end behave;


