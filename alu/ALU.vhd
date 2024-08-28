library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity alu is
port(
	en : in std_logic;
	alu_op : in std_logic_vector(5 downto 0);
	reg_a : in std_logic_vector(18 downto 0);
	reg_b : in std_logic_vector(18 downto 0);
	carry_out : out std_logic;
	zero_flag : out std_logic;
	res_out : out std_logic_vector(18 downto 0)
);
end entity;

architecture behave of alu is 

signal result : std_logic_vector(19 downto 0);
begin
	
	process(reg_a,reg_b,alu_op,result)
	begin
	   
		if alu_op = "000000" then                       -- Addition
			result <= ext(reg_a,20) + ext(reg_b,20);
			
		elsif alu_op = "000001" then                    -- substraction
			result <= ext(reg_a,20) - ext(reg_b,20);
			
      elsif alu_op = "000010" then                    -- Increment
		   result <= ext(reg_a,20) + 1;
		
		elsif alu_op = "000011" then                    -- Decrement
		   result <= ext(reg_a,20) - 1;
			
		elsif alu_op = "000100" then                    -- AND
			result <= ext(reg_a,20) and ext(reg_b,20);
			
		elsif alu_op = "000101" then                    -- OR
			result <= ext(reg_a,20) or ext(reg_b,20);
			
		elsif alu_op = "000110" then                    -- XOR
			result <= ext(reg_a,20) xor ext(reg_b,20);
		
	   elsif alu_op = "000111" then                    -- NOT
			result <= not ext(reg_a,20);
			
		elsif alu_op = "001011" then                    -- CMP
			result <= ext(reg_b,20) - ext(reg_a,20);
			
		end if;

	end process;
	
carry_out<= result(19) ;
zero_flag<= '1' when result(18 downto 0) = "00000000" else '0';
res_out<=result(18 downto 0) when en='1' else (others=>'Z');	
	
end behave;
