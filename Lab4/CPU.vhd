library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.CPU_Package.all;

ENTITY CPU is  
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
END ENTITY CPU;  

architecture Structure of CPU is  

    component ALU is
		port(
			op    : IN unsigned(2 downto 0);
			a     : IN data_word;       
			b     : IN data_word;
			en    : IN std_logic;
			clk   : IN std_logic;
			y     : OUT data_word;
			n_flag: OUT std_logic;
			z_flag: OUT std_logic;
			o_flag: OUT std_logic
		); 
	  end component;

    component data_buffer is
		port(
			out_en   : in std_logic;
			data_in  : in data_word;
			data_out : out data_word
		);
	  end component;

    component Controller is
		port( 
			adr      : out adress_bus; -- unsigned
			data     : in program_word; -- unsigned
			rw_m     : out std_logic;   -- read on high
			RWM_en   : out std_logic;   -- active low
			ROM_en   : out std_logic;   -- active low
      		IO_en    : out std_logic; -- active high 
			clk      : in std_logic;
			reset    : in std_logic;    -- active high
			rw_reg   : out std_logic;   -- read on high
			sel_op_1 : out unsigned(1 downto 0);
			sel_op_0 : out unsigned(1 downto 0);
			sel_in   : out unsigned(1 downto 0);
			sel_mux  : out unsigned(1 downto 0);
			alu_op   : out unsigned(2 downto 0);
			alu_en   : out std_logic;   -- active high
			z_flag   : in std_logic;    -- active high
			n_flag   : in std_logic;    -- active high
			o_flag   : in std_logic;    -- active high
			out_en   : out std_logic;   -- active high
			data_imm : out data_word   -- signed
			--stopp : in std_logic
		); 
	end component;

	component multiplexer is 
		port(
			sel       : in unsigned(1 downto 0);	
			data_in_3 : in data_word;
			data_in_2 : in data_word;
			data_in_1 : in data_bus; -- potiential type problem...
			data_in_0 : in data_word;
			data_out  : out data_word
		);
	end component;
	
	component register_file is 
		port(
			clk        : in std_logic;
			data_in    : in data_word;
			data_out_1 : out data_word;
			data_out_0 : out data_word;
			sel_in     : in unsigned(1 downto 0);
			sel_out_1  : in unsigned(1 downto 0);
			sel_out_0  : in unsigned(1 downto 0);
			rw_reg     : in std_logic
		);
	end component;

	-- ALU output
	signal s_Y : data_word;
	signal s_N_FLAG, s_Z_FLAG, s_O_FLAG : std_logic;

		
	-- Controller output
	signal s_ALU_EN, s_OUT_EN : std_logic;
	signal s_ALU_OP : unsigned(2 downto 0);
	signal s_DATA_IMM : data_word;
	signal s_SEL_MUX : unsigned(1 downto 0);
	signal s_SEL_IN, s_SEL_OP_0, s_SEL_OP_1 : unsigned(1 downto 0);
	signal s_RW_REG : std_logic;
    
	-- Multiplexer output
	signal s_MUX_DATA_OUT : data_word;

	-- Register File output
	signal s_DATA_OUT_0, s_DATA_OUT_1 : data_word;
	
	
	--other signals
	signal mux_data_in_3 : data_word := (others => '0');

begin
  
	ALU_unit : ALU 
		port map(
			op     => s_ALU_OP,
			a      => s_DATA_OUT_1,
			b      => s_DATA_OUT_0,
			en     => s_ALU_EN,
			clk    => i_clk,
			y      => s_Y,
			n_flag => s_N_FLAG,
			z_flag => s_Z_FLAG,
			o_flag => s_O_FLAG
		);
	
	data_buffer_unit : data_buffer 
		port map(
			out_en   => s_OUT_EN,
			data_in  => s_DATA_OUT_1,
			data_out => io_data
		);
	
	controller_unit : Controller 
		port map(
			adr      => o_adr,
			data     => i_instr, -- (io_data )?
			rw_m     => o_rw,
			RWM_en   => o_RWM_en,
			ROM_en   => o_ROM_en,
			IO_en    => o_io_en,
			clk      => i_clk,
			reset    => i_reset,
			rw_reg   => s_RW_REG,
			sel_op_1 => s_SEL_OP_1,
			sel_op_0 => s_SEL_OP_0,
			sel_in   => s_SEL_IN,
			sel_mux  => s_SEL_MUX,
			alu_op   => s_ALU_OP,
			alu_en   => s_ALU_EN,
			z_flag   => s_Z_FLAG,
			n_flag   => s_N_FLAG,
			o_flag   => s_O_FLAG,
			out_en   => s_OUT_EN,
			data_imm => s_DATA_IMM
			--stopp     => i_stop
		);
	
	multiplexer_unit : multiplexer 
		port map(
			sel       => s_SEL_MUX,
			data_in_3 => mux_data_in_3, 
			data_in_2 => s_DATA_IMM,
			data_in_1 => io_data,
			data_in_0 => s_Y,
			data_out  => s_MUX_DATA_OUT
		);
	
	register_file_unit : register_file 
		port map(
			clk        => i_clk,
			data_in    => s_MUX_DATA_OUT,
			data_out_1 => s_DATA_OUT_1,
			data_out_0 => s_DATA_OUT_0,
			rw_reg     => s_RW_REG,
			sel_in     => s_SEL_IN,
			sel_out_1  => s_SEL_OP_1,
			sel_out_0  => s_SEL_OP_0
		);

end architecture;
