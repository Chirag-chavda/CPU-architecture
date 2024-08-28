library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity pc is
    Port (
           clock : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           oe : in  STD_LOGIC;
           ld_pc : in  STD_LOGIC;
           input_pc : in  STD_LOGIC_VECTOR (7 downto 0);
           output_pc : out  STD_LOGIC_VECTOR (7 downto 0)
			  );
end pc;

architecture Behavioral of pc is

signal count : STD_LOGIC_VECTOR(7 downto 0) := "00000000";

begin

process(clock,rst)
begin

	if rst = '1' then
		count <= (others=>'0');
	elsif rising_edge(clock) then
				if ld_pc = '1' then
					count <= input_pc;
				elsif en = '1' then
					count <= count + 1;
				end if;
	end if;
	
end process;

output_pc <= count when oe = '1' else "ZZZZZZZZ";
		
end Behavioral;

