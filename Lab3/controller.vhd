library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

ENTITY Controller IS
 PORT( adr  : OUT address_bus; -- unsigned 
       data  : IN program_word; -- unsigned 
       RW : OUT std_logic;  -- read on high, write on low 
       RWM_en  : OUT std_logic;  -- active low 
       ROM_en  : OUT std_logic;  -- active low 
       IO_en  : OUT std_logic; -- active high 
       clk  : IN std_logic;         reset  : IN std_logic;    -- active high 
       rw   : OUT std_logic;   -- read on high  
       sel_op_1  : OUT unsigned (1 downto 0);        
       sel_op_0  : OUT unsigned (1 downto 0); 
       sel_in  : OUT unsigned (1 downto 0); 
       sel_mux  : OUT unsigned (1 downto 0); 
       alu_op  : OUT unsigned (2 downto 0); 
       alu_en  : OUT std_logic;  -- active high   
       z_flag  : IN std_logic;   -- active high   
       n_flag  : IN std_logic;   -- active high   
       o_flag  : IN std_logic;  -- active high 
       out_en  : OUT std_logic;  -- active high 
       data_imm  : OUT data_word);  -- signed  
END ENTITY
