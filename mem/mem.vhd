library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity mem is
	port(
		clock : in std_logic;
		load :in std_logic;
		oe	: in std_logic;
		data_in : in std_logic_vector(18 downto 0);
		addr_in : in std_logic_vector(7 downto 0);
		data_out : out std_logic_vector(18 downto 0)
	);
end entity;

architecture behavioral of mem is

type mem_type is array(0 to 255) of std_logic_vector(18 downto 0);
signal do_i : std_logic_vector(18 downto 0);

signal mem_obj:mem_type ;
begin

process (clock)
begin
	if rising_edge(clock) then
		if load = '1' then
			mem_obj(to_integer(unsigned(addr_in)))<=data_in ;
		end if;
	end if;
end process;

do_i <= mem_obj(to_integer(unsigned(addr_in))) ;

data_out <= do_i when oe = '1' else (others=>'Z');

end behavioral;
