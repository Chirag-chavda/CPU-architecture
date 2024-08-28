library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
 
entity reg_tb is
end reg_tb;
 
architecture behavior of reg_tb is

    component reg
    port(
         clock : in  std_logic;
         rst : in  std_logic;
         load : in  std_logic;
         out_en : in  std_logic;
         input_reg : in  std_logic_vector(18 downto 0);
         output_reg : out  std_logic_vector(18 downto 0);
         output_reg_alu : out  std_logic_vector(18 downto 0)
        );
    end component;
    
   signal clock : std_logic := '0';
   signal rst : std_logic := '0';
   signal load : std_logic := '0';
   signal out_en : std_logic := '0';
   signal input_reg : std_logic_vector(18 downto 0) := (others => '0');
   signal output_reg : std_logic_vector(18 downto 0);
   signal output_reg_alu : std_logic_vector(18 downto 0);

   constant clock_period : time := 10 ns;
 
 begin
 
   uut: reg port map (
          clock => clock,
          rst => rst,
          load => load,
          out_en => out_en,
          input_reg => input_reg,
          output_reg => output_reg,
          output_reg_alu => output_reg_alu
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

      wait for 100 ns;	
		
		rst <= '0';
	   load <= '0';
	   out_en <= '0';
	
      wait for clock_period*10; 
		
		input_reg <= "0101010101010101010";
		load <= '1';
		
		wait for clock_period*10;
		
		out_en <= '1';
		
		wait for clock_period*10;
		
		out_en <= '0';
      
		wait;
   end process;

end behavior;
