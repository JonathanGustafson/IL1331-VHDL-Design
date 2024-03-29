library IEEE;
use ieee.std_logic_1164.all;
use work.CPU_package.all;

ENTITY register_file_TB is
END ENTITY;

ARCHITECTURE test OF register_file_TB IS
  
  component RegisterFile
    port(
      clk : IN std_logic;
      data_in : IN data_word;
      data_out_1 : OUT data_word;
      data_out_0 : OUT data_word;
      sel_in : IN std_logic_vector(1 downto 0);
      sel_out_1 : IN std_logic_vector(1 downto 0);
      sel_out_0 : IN std_logic_vector(1 downto 0);
      rw_reg : IN std_logic
    );
  end component;
  
  signal clk : std_logic := '0';
  signal data_in : data_word;
  signal data_out_1 : data_word;
  signal data_out_0 : data_word;
  signal sel_in : std_logic_vector(1 downto 0);
  signal sel_out_1: std_logic_vector(1 downto 0);
  signal sel_out_0 : std_logic_vector(1 downto 0);
  signal rw_reg : std_logic;
  
  BEGIN
    
  unit: RegisterFile port map(clk, data_in, data_out_1, data_out_0, sel_in, sel_out_1, sel_out_0, rw_reg);

  --generate simple clock
  clk <= not clk after 5 ns;
  
  test: process
  begin
  --simulate writing
  sel_in <= "00";
  data_in <= "00000001";
  rw_reg <= '0';
  wait for 10 ns;  
  sel_in <= "01";
  data_in <= "00000011";
  rw_reg <= '0';
  wait for 10 ns;  
  sel_in <= "10";
  data_in <= "00000111";
  rw_reg <= '0';
  wait for 10 ns;  
  sel_in <= "11";
  data_in <= "00001111";
  rw_reg <= '0';
  wait for 10 ns;  

  --simulate reading
  rw_reg  <= '1';
  sel_out_1 <= "00";
  sel_out_0 <= "00";
  wait for 10 ns;
  rw_reg  <= '1';
  sel_out_1 <= "01";
  sel_out_0 <= "01";
  wait for 10 ns;
  rw_reg  <= '1';
  sel_out_1 <= "10";
  sel_out_0 <= "10";
  wait for 10 ns;
  rw_reg  <= '1';
  sel_out_1 <= "11";
  sel_out_0 <= "11";
  wait for 10 ns;
  end process;
  
END ARCHITECTURE;