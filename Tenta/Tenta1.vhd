----------------------------------------------------------------

-- ?)

library ieee;
use std_logic_1164.all;
use std_logic_signed;

entity alu is

    port(
        A,B,C : IN std_logic_vector(3 downto 0);
        reset, clk : IN std_logic;
        CTRL : IN std_logic_vector(2 downto 0);
        Q : OUT std_logic_vector(3 downto 0);
    );

end alu;

architecture behaviour of alu is

    begin

    

    process(clk, reset)
    begin

    if(reset '0') then

        Q <= '0';

    end if;

        case OpCode is

            when "000" => Q <= A + "0001"; --elr typ to_unsigned(to_integer(A)+1)
            when "001" => Q <= (A + B + "0001");
            when "010" => Q <= A;
            when "011" => Q <= A + B;

            when "100" => Q <= A - 1;
            when "101" => Q <= A - B;
            when "110" => Q <= B;
            when "111" => Q <= (A - B + 1);

            when others NULL;

        end case;

    end process;

end architecture;

-----------------------------------------------------------------------------------

--4)

library ieee;
use std_logic_1164.all;

entity fsm is

    port(
        reset : IN std_logic;
        k,clk : IN std_logic; 
        q : OUT std_logic;
    );

end entity;

architecture RTL of fsm is

begin

type STATES is (E011, E010, E001, E111, ES1, ES2, ES8, ES12);
signal curr_state, next_state : STATES;

process(curr_state, k)
begin

case curr_state is 
    when "E011" => q <= 0;
        if(k = '0') 
            next_state <= ES1;
        elsif (k = '1') 
            next_state <= ES8;
        end if;
        -- ...
end case;

end process;

process(clk, reset) 
begin
    if(reset = '0') then
        curr_state <= E111;
    elsif(rising_edge(clk)) then
        curr_state <= next_state;
    end if;
end process;


end architecture;

-------------------------------------------------------------------------------

--5)

library ieee;
use std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 

entity excess3 is
    port(
        Din : IN std_logic_vector(3 downto 0);
        Q : OUT  std_logic_vector(3 downto 0);
        clk, reset, CEn, UD, LEn : IN std_logic
    );
end entity;

architecture RTL of excess3 is

signal Q : std_logic_vector(3 downto 0);

begin
    
    process(reset,clk)
    begin

        if(reset = '0') then
            Q <= "0011";

        elsif(rising_edge(clk)) then
            if (LEn = '0') then
                if(Din < 3 and Din > 12) then
                    Q <= "0011";
                else
                    Q <= Din;
                end if;

            else
                if (CEn = '0') then
                    if   (UD = '1') then Q <= Q + "0001";

                        if(Q = "1100") then
                            Q <= "0011"
                        else
                            Q <= Q + 1;
                        end if;

                    elsif(UD = '0') then 
                        if(Q = "0011") then
                            Q <= "1100";
                        else
                            Q <= Q - 1;
                        end if;
                    end if;
                end if;
            end if;
        end if
        
    end process;

end architecture;