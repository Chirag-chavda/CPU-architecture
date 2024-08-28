library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity mar is 
port(
	clock : in std_logic;
	rst : in std_logic;
	load	: in std_logic;
	mar_ip	: in std_logic_vector(7 downto 0);
	mar_out  : out std_logic_vector(7 downto 0)
);
end entity;

architecture behave of mar is

signal stored_value : std_logic_vector(7 downto 0):=(others=>'Z');

begin
process(clock,rst)
begin
	if rst = '1' then
		stored_value<=(others=>'Z');
	elsif rising_edge(clock) then
		if load = '1' then
			stored_value <= mar_ip;
		end if;	
	end if;
end process;

mar_out<=stored_value;

end behave;