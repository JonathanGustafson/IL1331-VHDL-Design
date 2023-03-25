library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all; 
use work.all;
use work.CPU_Package.all;

entity Enchip is
      port(
        clk_enchip        : in std_logic; -- fast clock
        reset_enchip      : in std_logic; -- active high
        stop_enchip       : in std_logic; -- stops statemachine clk
        choice            : in std_logic; -- address(=0) or data(=1)
        peek_LEDs         : OUT data_bus;
        Q_enchip          : out data_bus
      ); -- output
end entity Enchip;


architecture Structure of Enchip is
  
  component CPU is
    PORT(  
        o_adr     : OUT adress_bus; 
        i_instr   : IN instruction_bus;  
        io_data   : INOUT data_bus;  
        o_rw      : OUT std_logic;  -- read on high, write on low   
        o_ROM_en  : OUT std_logic;  -- active low  
        o_RWM_en  : OUT std_logic;  -- active low    
        o_IO_en   : OUT std_logic; 
        i_clk     : IN std_logic;  
        i_reset   : IN std_logic    -- active high  
		    --i_stop 	  : IN std_logic
        );   
  end component;
  
  component rom is
    PORT(
        adr   : IN adress_bus; 
        data  : OUT instruction_bus; 
        ce_n  : IN std_logic            -- active low
        );
  end component;
  
  component ram is
      PORT( 
        adr   : IN adress_bus; 
        data  : INOUT data_bus; 
        clk   : IN std_logic; 
        ce_n  : IN std_logic;   -- active low 
        rw    : IN std_logic      -- r=1, w=0
        );  
  end component;
  
  component clock_divider is
    port(
      stop_clk  : in std_logic;
      in_clk    : in std_logic;
      clk_1hz   : out std_logic
      );
  end component;
  
  component out_buffer is
    port(
        clk, out_en : IN std_logic;
        data_in     : IN data_word;
        Q           : OUT data_word
    );
  end component;
  
  --signals
  signal adress : adress_bus; --adress mellan cpu, rom och ram
  signal instruction: instruction_bus; -- instruction från rom till cpu 
  signal io_data_enchip: data_bus; -- data från cpu-ram, ram-cpu, ska va data_bus -- va data_word förrut
  signal rw_enchip, ROM_EN_enchip, RWM_EN_enchip: std_logic; --rom, ram enable


  signal hz_clk : std_logic; -- 1hz clk

  signal out_en_enchip : std_logic;
  
  BEGIN
    
    cpu_unit: CPU --"ELECTRUM"
      port map(
        o_adr     => adress,     
        i_instr   => instruction, 
        io_data   => io_data_enchip,
        o_rw      => rw_enchip,
        o_ROM_en  => ROM_EN_enchip,
        o_RWM_en  => RWM_EN_enchip,
        o_io_en   => out_en_enchip,--? kör outbufferns enable sålänge
        i_clk     => hz_clk,--hz_clk,
        i_reset   => reset_enchip
      );
      
    rom_unit: rom
      port map(
        adr => adress,
        data => instruction,
        ce_n => ROM_EN_enchip
      );  
      
    ram_unit: ram
      port map(
        adr => adress,
        data => io_data_enchip, 
        clk => hz_clk,--hz_clk,
        ce_n => RWM_EN_enchip,  
        rw => rw_enchip
      );
      
    clock_divider_unit: clock_divider 
      port map(
        stop_clk => stop_enchip,
        in_clk => clk_enchip,
        clk_1hz => hz_clk
      );
      
    out_buffer_unit: out_buffer
      port map(
        clk => hz_clk,--hz_clk,
        out_en => out_en_enchip,
        data_in => io_data_enchip,
        Q => Q_enchip
      ); 
    
    peek_LEDs <= adress when choice ='0' else io_data_enchip;
    
end architecture;