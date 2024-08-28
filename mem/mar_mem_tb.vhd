LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
 
ENTITY mar_mem_tb IS
END mar_mem_tb;
 
ARCHITECTURE behavior OF mar_mem_tb IS 
 
COMPONENT mem
    PORT(
         clock : IN  std_logic;
         load : IN  std_logic;
         oe : IN  std_logic;
         data_in : IN  std_logic_vector(18 downto 0);
         addr_in : IN  std_logic_vector(7 downto 0);
         data_out : OUT  std_logic_vector(18 downto 0)
        );
END COMPONENT;
	 
COMPONENT mar 
		port(
			  clock : IN std_logic;
			  rst : IN  std_logic;
           load : IN  std_logic;
			  mar_ip : in  STD_LOGIC_VECTOR (7 downto 0);
           mar_out : out  STD_LOGIC_VECTOR (7 downto 0)
		);
END COMPONENT;

   signal clock : std_logic;
	signal load_mem : std_logic := '0';
   signal oe_mem : std_logic := '0';
   signal data_in_mem : std_logic_vector(18 downto 0) := (others => '0');
   signal data_out_mem : std_logic_vector(18 downto 0);
	
	signal load_mar : std_logic := '0';
	signal rst_sig : std_logic;
	signal mar_ip : std_logic_vector(7 downto 0);
	signal mar_out : std_logic_vector(7 downto 0);

   constant clock_period : time := 10 ns;
 
BEGIN
 
   uut_mem: mem PORT MAP (
          clock => clock,
          load => load_mem,
          oe => oe_mem,
          data_in => data_in_mem,
          addr_in => mar_out,
          data_out => data_out_mem
          );
   uut_mar: mar PORT MAP(
			 clock => clock,
			 rst => rst_sig,
			 load => load_mar,
			 mar_ip => mar_ip,
			 mar_out => mar_out
	       );
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 
   stim_proc: process
   begin		
      
	      mar_ip <= "00000000";
		   load_mar <= '1';
       	data_in_mem <= "1111111111111111111";
		   load_mem <= '1';
	    	oe_mem <='1';
      wait for clock_period;

		   load_mar <= '0';
		   load_mem <= '0';
		
		wait for clock_period;
		
	     	mar_ip <= "00010001";
	    	load_mar <= '1';
	   	data_in_mem <= "1111111111000000000";
	    	load_mem <= '1';
		   oe_mem <='1';
		
		wait for clock_period;
		
	    	load_mar <= '0';
	   	load_mem <= '0';

      wait for clock_period;
		
		   mar_ip <= "01000010";
	   	load_mar <= '1';
	   	data_in_mem <= "0000000000111111111";
	   	load_mem <= '1';
		   oe_mem <='1';
		
		wait for clock_period;

		   load_mar <= '0';
		   load_mem <= '0';
		
     wait;
   end process;

END;







