library IEEE;
use IEEE.std_logic_1164.all;
use work.CPU_package.all;

entity ALU_TB is
end entity;

Architecture test of ALU_TB is
  
  component ALU
    PORT(  
      Op : IN std_logic_vector(2 downto 0); 
      A : IN data_word;  
      B : IN data_word; 
      En : IN std_logic; 
      clk : IN std_logic; 
      y  : OUT data_word; 
      n_flag: OUT std_logic; 
      z_flag: OUT std_logic;  
      o_flag: OUT std_logic  
   );
  end component;
 
  signal s_Op : std_logic_vector(2 downto 0):= (others => '0');   --default to all zeros
	signal s_A : data_word := (others => '0');                      --default to all zeros
	signal s_B : data_word := (others => '0');                      --default to all zeros
	signal s_En : std_logic := '1';
	signal s_clk : std_logic := '0';
	signal s_y : data_word;
	signal s_n_flag : std_logic;
	signal s_z_flag : std_logic;
	signal s_o_flag : std_logic;
	
	begin
	
	UUT: ALU port map(s_Op, s_A, s_B, s_En, s_clk, s_y, s_n_flag, s_z_flag, s_o_flag);
	
	--Generate simple clock  
	s_clk <= not s_clk after 5 ns;
	
	--Go through all combinations of numbers for A
	s_A(0) <= not s_A(0) after 10 ns;
	s_A(1) <= not s_A(1) after 20 ns;
	s_A(2) <= not s_A(2) after 40 ns;
	s_A(3) <= not s_A(3) after 80 ns;
	
	--Go through all combinations of numbers for B
	--Note that it does not get same values as A at time T
	s_B(0) <= not s_B(0) after 80 ns;
	s_B(1) <= not s_B(1) after 10 ns;
	s_B(2) <= not s_B(2) after 20 ns;	
	s_B(3) <= not s_B(3) after 40 ns;  
	
	--Go through all combinations of operations
	--stop simulation at about 1000 ns (since we dont care about operation "111")
	s_Op(0) <= not s_Op(0) after 160 ns;
	s_Op(1) <= not s_Op(1) after 320 ns;
	s_Op(2) <= not s_Op(2) after 640 ns;
	
	end Architecture;