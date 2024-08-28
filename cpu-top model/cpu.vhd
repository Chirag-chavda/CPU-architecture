library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cpu is
port(
			clock : in std_logic;
			rst : in std_logic;
			op	 : out std_logic_vector(18 downto 0)
);
end cpu;

architecture Behavioral of cpu is

component pc is
    Port (
           clock : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           oe : in  STD_LOGIC;
           ld_pc : in  STD_LOGIC;
           input_pc : in  STD_LOGIC_VECTOR (7 downto 0);
           output_pc : out  STD_LOGIC_VECTOR (7 downto 0)
			  );
end component;

component reg is
    Port (
			  clock : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           load : in  STD_LOGIC;
           out_en : in  STD_LOGIC;
           input_reg : in  STD_LOGIC_VECTOR (18 downto 0);
           output_reg : out  STD_LOGIC_VECTOR (18 downto 0);
           output_reg_alu : out  STD_LOGIC_VECTOR (18 downto 0)
			  );
end component;

component mem is
	port(
		clock : in std_logic;
		load :in std_logic;
		oe	: in std_logic;
		data_in : in std_logic_vector(18 downto 0);
		addr_in : in std_logic_vector(7 downto 0);
		data_out : out std_logic_vector(18 downto 0)
	);
end component;

component reg_file is
    Port ( clock : in  STD_LOGIC;
           reg_wr : in  STD_LOGIC;
           reg_ip : in  STD_LOGIC_VECTOR (18 downto 0);
           reg_ip_sel : in  STD_LOGIC_VECTOR (1 downto 0);
           out_sel_a : in  STD_LOGIC_VECTOR (1 downto 0);
           out_sel_b : in  STD_LOGIC_VECTOR (1 downto 0);
           a_out : out  STD_LOGIC_VECTOR (18 downto 0);
           b_out: out  STD_LOGIC_VECTOR (18 downto 0));
end component;

component mar is 
port(
	clock : in std_logic;
	rst : in std_logic;
	load	: in std_logic;
	mar_ip	: in std_logic_vector(7 downto 0);
	mar_out  : out std_logic_vector(7 downto 0)
);
end component;

component alu is
port(
	en : in std_logic;
	alu_op : in std_logic_vector(5 downto 0);
	reg_a : in std_logic_vector(18 downto 0);
	reg_b : in std_logic_vector(18 downto 0);
	carry_out : out std_logic;
	zero_flag : out std_logic;
	res_out : out std_logic_vector(18 downto 0)
);
end component;

component control_unit is
    Port ( clock : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           inst : in  STD_LOGIC_VECTOR (5 downto 0);
           do : out  STD_LOGIC_VECTOR (28 downto 0);
			  zero : in STD_LOGIC
			  );
end component;

signal main_bus : std_logic_vector(18 downto 0);

signal clock_sig : std_logic;
signal halt_sig : std_logic;

signal pc_en_sig : std_logic;
signal pc_oe_sig : std_logic;
signal pc_ld_sig : std_logic;

signal inst_out : std_logic_vector(5 downto 0);
signal cu_out_sig : std_logic_vector(28 downto 0);
signal zero_flag_sig : std_logic;

signal mar_ld_sig : std_logic;
signal mar_mem_sig : std_logic_vector(7 downto 0);

signal mem_ld_sig : std_logic;
signal mem_oe_sig : std_logic;

signal inst_ld_sig : std_logic;
signal inst_oe_sig : std_logic;
signal inst_out_sig : std_logic_vector(18 downto 0);

signal reg_a_ld_sig : std_logic;
signal reg_a_oe_sig : std_logic;
signal reg_a_alu : std_logic_vector(18 downto 0);

signal reg_b_ld_sig : std_logic;
signal reg_b_oe_sig : std_logic;
signal reg_b_alu : std_logic_vector(18 downto 0);

signal reg_op_ld_sig : std_logic;
signal reg_op_oe_sig : std_logic;

signal regfile_wr : std_logic;
signal reg_a_ip : std_logic_vector(18 downto 0);
signal reg_b_ip : std_logic_vector(18 downto 0);
signal regfile_ipsel_sig : std_logic_vector(1 downto 0);
signal regfile_outsel_a_sig : std_logic_vector(1 downto 0);
signal regfile_outsel_b_sig : std_logic_vector(1 downto 0);

signal alu_en_sig : std_logic;
signal alu_op_sig : std_logic_vector(5 downto 0);

begin

pc_inst : pc port map(
           clock       => clock_sig,
           rst       => rst,
           en        => pc_en_sig,
           oe        => pc_oe_sig,
           ld_pc     => pc_ld_sig,
           input_pc  => main_bus(7 downto 0),
           output_pc => main_bus(7 downto 0)
);

cu_inst : control_unit port map(
           clock  => clock_sig,
           rst  => rst,
           inst => inst_out, 
			  do   => cu_out_sig,
			  zero => zero_flag_sig
);

mar_inst : mar port map(
           clock     => clock_sig,
           rst     => rst,
           load    => mar_ld_sig,
			  mar_ip  => main_buS(7 downto 0),
			  mar_out => mar_mem_sig
);

mem_inst : mem port map(
           clock      => clock_sig,
           load     => mem_ld_sig,
			  oe  	  => mem_oe_sig,
			  addr_in  => mar_mem_sig,
			  data_in  => main_bus,
			  data_out => main_bus
);

instr_reg_inst : reg port map(
           clock 			  => clock_sig,
			  rst            => rst,
           load			  => inst_ld_sig,
			  out_en			  => inst_oe_sig,
			  input_reg		  => main_bus,
			  output_reg_alu => inst_out_sig
);

inst_out <= inst_out_sig(18 downto 13);
main_bus(12 downto 0) <= inst_out_sig(12 downto 0) when inst_oe_sig = '1' else (others => 'Z');

reg_A_inst : reg port map(
			  clock 			  => clock_sig,
			  rst            => rst,
           load			  => reg_a_ld_sig,
			  out_en			  => reg_a_oe_sig,
			  input_reg		  => reg_a_ip,
			  output_reg     => main_bus,
			  output_reg_alu => reg_a_alu
          		  
);

reg_B_inst : reg port map(
           clock 			  => clock_sig,
			  rst            => rst,
           load			  => reg_b_ld_sig,
			  out_en			  => reg_b_oe_sig,
			  input_reg		  => reg_b_ip,
			  output_reg     => main_bus,
			  output_reg_alu => reg_b_alu
);

reg_file_inst : reg_file port map(
           clock        => clock_sig,
           reg_wr     => regfile_wr,
           reg_ip     => main_bus,
           reg_ip_sel => regfile_ipsel_sig,
           out_sel_a  => regfile_outsel_a_sig,
           out_sel_b  => regfile_outsel_b_sig,
           a_out      => reg_a_ip,
           b_out      => reg_b_ip
);

reg_op_inst : reg port map(
           clock 			  => clock_sig,
			  rst            => rst,
           load			  => reg_op_ld_sig,
			  out_en			  => reg_op_oe_sig,
			  input_reg		  => main_bus,
			  output_reg     => open,
			  output_reg_alu => op          
);

alu_ins : alu port map(
           en        => alu_en_sig,
			  alu_op    => alu_op_sig,
			  reg_a     => reg_a_alu,
		     reg_b     => reg_b_alu,
	        carry_out => open,
			  zero_flag => zero_flag_sig,
		     res_out   => main_bus
);


clock_sig <= clock and (not halt_sig);

regfile_outsel_a_sig <= cu_out_sig (28 downto 27);
regfile_outsel_b_sig <= cu_out_sig (26 downto 25);
regfile_ipsel_sig    <= cu_out_sig (24 downto 23);
regfile_wr           <= cu_out_sig(22);
halt_sig 	         <= cu_out_sig(21);
reg_op_ld_sig     	<= cu_out_sig(20);
reg_op_oe_sig			<= cu_out_sig(19);
alu_op_sig	   		<= cu_out_sig(18 downto 13);
alu_en_sig	  			<= cu_out_sig(12);
pc_en_sig 	   		<= cu_out_sig(11);
pc_ld_sig	   		<= cu_out_sig(10);
pc_oe_sig 	   		<= cu_out_sig(9);
mar_ld_sig    			<= cu_out_sig(8);
mem_ld_sig  			<= cu_out_sig(7);
mem_oe_sig				<= cu_out_sig(6);
reg_a_ld_sig			<= cu_out_sig(5);
reg_a_oe_sig			<= cu_out_sig(4);
reg_b_ld_sig			<= cu_out_sig(3);
reg_b_oe_sig			<= cu_out_sig(2);
inst_ld_sig				<= cu_out_sig(1);
inst_oe_sig				<= cu_out_sig(0);

end Behavioral;

