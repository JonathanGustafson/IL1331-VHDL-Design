library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.CPU_Package.all;

entity controller_TB is
end entity;

architecture test of controller_TB is

    component controller is
      port(
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
        data_imm  : OUT data_word;   -- signed
        stop : IN std_logic
      );
    end component;

    component rom is port(
        adr : IN adress_bus; 
        data : OUT instruction_bus; 
        ce_n : IN std_logic            -- active low
    );
    end component;

    component ram is port(
        adr : IN adress_bus; 
        data : INOUT data_bus; 
        clk : IN std_logic; 
        ce_n : IN std_logic;   -- active low 
        rw : IN std_logic      -- r=1, w=0
        );
    end component;

        signal s_adr      : adress_bus; 
        signal s_data     : program_word;
        signal s_rw_m     : std_logic;
        signal s_RWM_en   : std_logic;
        signal s_ROM_en   : std_logic := '0';
        signal s_clk      : std_logic := '0';
        signal s_reset    : std_logic := '1';
        signal s_RW_reg   : std_logic;
        signal s_sel_op_1 : unsigned(1 downto 0);
        signal s_sel_op_0 : unsigned(1 downto 0);
        signal s_sel_in   : unsigned(1 downto 0);
        signal s_sel_mux  : unsigned(1 downto 0);
        signal s_alu_op   : unsigned(2 downto 0);
        signal s_alu_en   : std_logic;
        signal s_z_flag   : std_logic;
        signal s_n_flag   : std_logic;
        signal s_o_flag   : std_logic;
        signal s_out_en   : std_logic;
        signal s_data_imm : data_word;
        signal s_stop     : std_logic := '0';
begin

    ROM_unit : ROM port map(
		adr  => s_adr,
		data => s_data,
		ce_n   => s_ROM_en
	);

    UUT : Controller port map( 
        adr      => s_adr,
        data     => s_data,
        rw_m     => s_rw_m,
        RWM_en   => s_RWM_en,
        ROM_en   => s_ROM_en,
        clk      => s_clk,
        reset    => s_reset,
        rw_reg   => s_rw_reg,
        sel_op_1 => s_sel_op_1,
        sel_op_0 => s_sel_op_0,
        sel_in   => s_sel_in,
        sel_mux  => s_sel_mux,
        alu_op   => s_alu_op,
        alu_en   => s_alu_en,
        z_flag   => s_z_flag,
        n_flag   => s_n_flag,
        o_flag   => s_o_flag,
        out_en   => s_out_en,
        data_imm => s_data_imm,
        stop     => s_stop
    );

    s_clk <= NOT s_clk after 20 ns; -- 50 MHz

    process
	begin 

        wait for 300 ns;
        s_reset <= '0';
		wait for 999 ms;
	end process;
    

end architecture;