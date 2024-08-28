library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIc_UNSIGNED.ALL;

entity reg_file is
    Port ( clock : in  STD_LOGIC;
           reg_wr : in  STD_LOGIC;
           reg_ip : in  STD_LOGIC_VECTOR (18 downto 0);
           reg_ip_sel : in  STD_LOGIC_VECTOR (1 downto 0);
           out_sel_a : in  STD_LOGIC_VECTOR (1 downto 0);
           out_sel_b : in  STD_LOGIC_VECTOR (1 downto 0);
           a_out : out  STD_LOGIC_VECTOR (18 downto 0);
           b_out: out  STD_LOGIC_VECTOR (18 downto 0));
end reg_file;

architecture Behavioral of reg_file is

signal Q: STD_LOGIC_VECTOR (3 downto 0);

signal R0: STD_LOGIC_VECTOR (18 downto 0):= b"0000000000000000001";
signal R1: STD_LOGIC_VECTOR (18 downto 0):= b"0000000000000000010";
signal R2: STD_LOGIC_VECTOR (18 downto 0):= b"0000000000000000011";
signal R3: STD_LOGIC_VECTOR (18 downto 0):= b"0000000000000000100";

begin

Q <= "0001" when (reg_ip_sel = "00") else  --R0
	  "0010" when (reg_ip_sel = "01") else  --R1
	  "0100" when (reg_ip_sel = "10") else  --R2
	  "1000" when (reg_ip_sel = "11") else  --R3 
	  "0000";
	  
a_out <= R0 when OUT_SEL_A = "00" else
			R1 when OUT_SEL_A = "01" else
			R2 when OUT_SEL_A = "10" else
			R3;
			
b_out <= R0 when out_sel_b = "00" else
			R1 when out_sel_b = "01" else
			R2 when out_sel_b = "10" else
			R3;
			
process (clock,reg_wr)
begin
	if (clock'EVENT AND clock='1') then
	
		if (Q(0) = '1' AND reg_wr = '1') then
			R0 <= reg_ip;
			
	   elsif (Q(1) = '1' AND reg_wr = '1') then
			R1 <= reg_ip;
			
		elsif (Q(2) = '1' AND reg_wr= '1') then
			R2 <= reg_ip;
			
		elsif (Q(3) = '1' AND reg_wr = '1') then
			R3 <= reg_ip;
			
	   else
			R0 <= R0;
			R1 <= R1;
			R2 <= R2;
			R3 <= R3;
			
		end if;
	end if;

end process;	
	
end Behavioral;