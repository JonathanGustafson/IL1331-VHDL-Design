library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.CPU_Package.all;

ENTITY controller IS
 PORT( adr  : OUT address_bus; -- unsigned 
       data  : IN program_word; -- unsigned 
       rw_m : OUT std_logic;  -- read on high, write on low 
       RWM_en  : OUT std_logic;  -- active low 
       ROM_en  : OUT std_logic;  -- active low 
       IO_en  : OUT std_logic; -- active high 
       clk  : IN std_logic;         
       reset  : IN std_logic;    -- active high 
       rw_reg   : OUT std_logic;   -- read on high  
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
       data_imm  : OUT data_word   -- signed
       stop : IN std_logic;
       );    
END ENTITY

ARCHITECTURE RTL OF controller IS

component counter is
      port(
            clk      : in std_logic;
            load_en  : in std_logic; -- active on high
            load_val : in unsigned(operation_size-1 downto 0);
            step     : in std_logic;
            current_value : out unsigned(3 downto 0);
      );
end component;

--states
type fsm_state is (controller_reset, fetch_intstruction, load_instruction, decode_instruction, write_result, load_data, store_data, load_immediate);
signal next_state : fsm_state;

--breaking down the instruction into aliases for better readability
signal instruction : std_logic_vector(instruction_size-1 downto 0);
alias instr_alu_en : std_logic is instruction(9);
alias instr_opcode  : std_logic_vector(2 downto 0) is instr(8 downto 6);
alias instr_r1  : std_logic_vector(1 downto 0) is instr(5 downto 4);
alias instr_r2  : std_logic_vector(1 downto 0) is instr(3 downto 2);
alias instr_r3  : std_logic_vector(1 downto 0) is instr(1 downto 0);
alias instr_mem : std_logic_vector(3 downto 0) is instr(3 downto 0);
alias instr_d3d2d1d0 : std_logic_vector(3 downto 0) is instr(3 downto 0); 

-- program counter
signal PC_step : std_logic := '0'; 
signal PC_load_en : std_logic;
signal PC_load_val : unsigned(operation_size-1 downto 0);
signal PC_current_value : unsigned(operation_size-1 downto 0);

BEGIN

PC : counter port map(clk, PC_step, PC_curent_value, PC_load_en, PC_load_val);

process(clk,reset,stop)
variable current_state : fsm_state;

begin

      if reset = '1';
      next_state <= controller_reset;

      elseif(rising_edge(clk)) then
      case current_state is

            when controller_reset =>
                  
                  --reset the programcounter to 0
			PC_load_en  <= '1';
			PC_load_val <= (others => '0');

                  --reset the other values to initial state
			rw_m <= '0';
			RWM_en <= '1';          
			ROM_en <= '1';                   
			rw_reg <= '0';                
			sel_op_1 <= (others => '0');
			sel_op_0 <= (others => '0');
			sel_in <= (others => '0');
			sel_mux <= (others => '0');
			alu_op <= (others => '0');
			alu_en <= '0';
			out_en <= '0';
			data_imm <= (others => '0');

                  --select next_state
			next_state  <= fetch_instruction;

            when fetch_instruction =>

                  PC_load_en <= '0' --enable program counter

                  adr <= address_bus(PC_current_value);
                  rw_m := '1';
                  RWM_en :='1'; --disable
                  ROM_en :='0'; --enable
                  rw_reg <= '1'; -- disable
			alu_en <= '0'; -- disable     
			out_en <= '0'; -- disable  
                  
                  next_state <= load_instruction;
            when load_instruction =>
                  next_state <= decode_instruction;
            when decode_instruction =>
            when write_result =>
            when load_data =>
            when store_data =>
            when load_immediate =>

      end case;
      end if;

end process;

END ARCHITECTURE