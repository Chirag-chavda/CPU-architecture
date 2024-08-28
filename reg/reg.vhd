library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is

    Port (
			  clock : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           load : in  STD_LOGIC;
           out_en : in  STD_LOGIC;
           input_reg : in  STD_LOGIC_VECTOR (18 downto 0);
           output_reg : out  STD_LOGIC_VECTOR (18 downto 0);
           output_reg_alu : out  STD_LOGIC_VECTOR (18 downto 0));
end reg;

architecture Behavioral of reg is

signal stored_value : STD_LOGIC_VECTOR(18 downto 0) := (others => 'Z');

begin

process(clock,rst)
begin
	
	if rst = '1' then
		stored_value <= (others => 'Z');
		
	elsif rising_edge(clock) then
	
			if load = '1' then
				stored_value <= input_reg;
			end if;
	end if;

end process;

output_reg <= stored_value when out_en = '1' else (others => 'Z');

output_reg_alu <= stored_value;

end Behavioral;

