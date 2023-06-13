library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.CPU_Package.all;

--UPDATE CHECK 23-03-2023 kl 15:55

ENTITY controller IS
 PORT( 
      adr  : OUT adress_bus; -- unsigned 
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
      );    
END ENTITY;

ARCHITECTURE RTL OF controller IS

--states
type fsm_state is (controller_reset, fetch_instruction, load_instruction, decode_instruction, write_result, load_data, store_data, load_immediate, nop, branch);
signal next_state : fsm_state;

--breaking down the instruction into aliases for better readability
signal instruction : std_logic_vector(instruction_size-1 downto 0);
alias instr_alu_en : std_logic is instruction(9); --enable when low
alias instr_op  : std_logic_vector(2 downto 0) is instruction(8 downto 6);
alias instr_r1  : std_logic_vector(1 downto 0) is instruction(5 downto 4);
alias instr_r2  : std_logic_vector(1 downto 0) is instruction(3 downto 2);
alias instr_r3  : std_logic_vector(1 downto 0) is instruction(1 downto 0);
alias instr_mem : std_logic_vector(3 downto 0) is instruction(3 downto 0);
alias instr_d3d2d1d0 : std_logic_vector(3 downto 0) is instruction(3 downto 0); 

--Program counter
signal PC_step : std_logic := '0'; 
signal PC_load_en : std_logic;
signal PC_load_val : unsigned(adress_size-1 downto 0);
signal PC_current_value : unsigned(adress_size-1 downto 0);

component counter is
      port(
            clk      : in std_logic;
            load_en  : in std_logic; -- active on high
            load_val : in unsigned(adress_size-1 downto 0);
            step     : in std_logic;
            current_value : out unsigned(adress_size-1 downto 0)
      );
end component;

BEGIN

PC : counter port map(clk, PC_load_en, PC_load_val, PC_step, PC_current_value); --Program counter

process(clk,reset)
variable current_state : fsm_state;

begin

      if (reset = '1') then
            next_state <= controller_reset;

      elsif(rising_edge(clk)) then
      
      current_state := next_state;

      case current_state is

            when controller_reset =>
                  
                  --reset the programcounter to 0
			           PC_load_en  <= '1';
			           PC_load_val <= (others => '0');

                  --reset the other values to initial state
			           rw_m <= '0';       -- read on high, write on low
		             RWM_en <= '1';          
			           ROM_en <= '1';                 
			           rw_reg <= '0'; --write              
			           alu_en <= '0';
			           out_en <= '0';
                 IO_en <= '1'; 
                 sel_op_1   <= (others => '0');
			           sel_op_0   <= (others => '0');
			           sel_in     <= (others => '0');
			           sel_mux    <= (others => '0');
			           alu_op     <= (others => '0');
			           data_imm   <= (others => '0');

                  --select next_state
			           next_state  <= fetch_instruction;

            when fetch_instruction =>

                  PC_load_en <= '0'; --enable program counter 

                  adr <= adress_bus(PC_current_value);
                  --rw_m <= '1'; --disable (read on high)
                  RWM_en <= '1'; --disable
                  ROM_en <= '0'; --enable
                  rw_reg <= '1'; -- read
			            alu_en <= '0'; -- disable     
			            out_en <= '0'; -- disable  
                  IO_en  <= '0';
                  
                  next_state <= load_instruction;

            when load_instruction =>

                  PC_step <= NOT PC_step; -- change step to later increase program counter

                  instruction <= data;

                  next_state <= decode_instruction;

            when decode_instruction =>

                  if (instr_alu_en = '0') then --operation need ALU

                        RWM_en <= '1'; --diasble
                        ROM_en <= '1'; --disable
                        rw_reg <= '1'; --read
                        sel_op_1   <= to_unsigned(to_integer(unsigned(instr_r1)),instr_r1'length);
                        sel_op_0   <= to_unsigned(to_integer(unsigned(instr_r2)),instr_r2'length);
                        sel_in     <= to_unsigned(to_integer(unsigned(instr_r3)),instr_r3'length);
                        alu_op     <= to_unsigned(to_integer(unsigned(instr_op)),instr_op'length);
                        alu_en <= '1'; --enable
                        
                        if(instr_op = "111") then
                          out_en <= '1'; --enable
                          IO_en <= '1';
                        else
                          out_en <= '0'; --disable
                          IO_en <= '0';
                        end if;

                        next_state <= write_result;

                  else

                        case instr_op is
                     
                              when "000" => next_state <= load_data; --Load register (LDR)
                              when "001" => next_state <= store_data; --Store register (STR)
                              when "010" => next_state <= load_immediate; --Load Immediate (LDI)
                              when "011" => next_state <= nop; --NOP

                              when "100" => --Branch if Zero-flag (BRZ)
                                    if(z_flag = '1') then
                                          PC_load_en <= '1';
                                          PC_load_val(3 downto 0) <= to_unsigned(to_integer(unsigned(instr_mem)), instr_mem'length);
                                    end if;
                                    next_state <= branch;

                              when "101" => --Branch if N-flag (BRN)
                                    if(n_flag = '1') then
                                          PC_load_val(3 downto 0) <= to_unsigned(to_integer(unsigned(instr_mem)), instr_mem'length);
                                          PC_load_en <= '1';
                                    end if;
                                    next_state <= branch;

                              when "110" => --Branch if Overflow-Flag (BRO)
                                    if(o_flag = '1') then
                                          PC_load_val(3 downto 0) <= to_unsigned(to_integer(unsigned(instr_mem)), instr_mem'length);
                                          PC_load_en <= '1';
                                    end if;
                                    next_state <= branch;

                              when "111" => --Branch (BRA)
                                    PC_load_val(3 downto 0) <= to_unsigned(to_integer(unsigned(instr_mem)), instr_mem'length);
                                    PC_load_en <= '1';
                                    next_state <= branch;

                              when others => next_state <= NOP;

                        end case;
                  end if;

            when write_result =>

                  rw_reg      <= '0'; --write
                  sel_mux     <= "00";
                  sel_op_1    <= to_unsigned(to_integer(unsigned(instr_r1)),instr_r1'length);
                  sel_op_0    <= to_unsigned(to_integer(unsigned(instr_r2)),instr_r2'length);
                  sel_in      <= to_unsigned(to_integer(unsigned(instr_r3)),instr_r3'length);
                  --out_en      <= '1';
                  IO_en       <= '1';
                  
                  next_state <= fetch_instruction;

            when load_data =>
                  
                  adr(3 downto 0) <= instr_mem;
                  rw_m <= '1'; --set to read
                  RWM_en <= '0'; --enable
                  ROM_en <= '1'; --disable
                  rw_reg <= '0'; --set to write
                  sel_in <= to_unsigned(to_integer(unsigned(instr_r1)),instr_r1'length);
                  sel_mux <= "01"; --data in from ram
                  alu_en <= '0'; --disable
                  out_en <= '0'; --disable
                  IO_en <= '0';
                  
                  next_state <= fetch_instruction;

            when store_data =>

                  adr(3 downto 0) <= instr_mem;
                  rw_m <= '0'; --set to write
                  RWM_en <= '0'; --enable
                  ROM_en <= '1'; --disable
                  rw_reg <= '1'; --read
                  sel_op_1 <= to_unsigned(to_integer(unsigned(instr_r1)),instr_r1'length);
                  alu_en <= '0'; --disable
                  out_en <= '1'; --enable
                  IO_en <= '0';
                  
                  next_state <= fetch_instruction;

            when load_immediate =>  

                  RWM_en <= '1'; --disable
                  ROM_en <= '1'; --disable
                  rw_reg <= '0'; --set to write
                  sel_in <= to_unsigned(to_integer(unsigned(instr_r1)),instr_r1'length); --load immediate value to r1
                  sel_mux <= "10"; --select data_imm

                  alu_en <= '0'; --disable
                  out_en <= '0'; --disable
                  IO_en  <= '0';
                  data_imm(3 downto 0) <= instr_d3d2d1d0;

                  next_state <= fetch_instruction;

            when branch =>
                  next_state <= fetch_instruction;

            when NOP => 
                  next_state <= fetch_instruction;

      end case;
      end if;

end process;

END ARCHITECTURE;