LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY pc_tb IS
END pc_tb;
 
ARCHITECTURE behavior OF pc_tb IS 
  
    COMPONENT pc
    PORT(
         clock : IN  std_logic;
         rst : IN  std_logic;
         en : IN  std_logic;
         oe : IN  std_logic;
         ld_pc : IN  std_logic;
         input_pc : IN  std_logic_vector(16 downto 0);
         output_pc : OUT  std_logic_vector(16 downto 0)
        );
    END COMPONENT;
   
   signal clock : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic := '0';
   signal oe : std_logic := '0';
   signal ld_pc : std_logic := '0';
   signal input_pc : std_logic_vector(16 downto 0) := (others => '0');

   signal output_pc : std_logic_vector(16 downto 0);

   constant clock_period : time := 10 ns;
 
BEGIN
 
   uut: pc PORT MAP (
          clock => clock,
          rst => rst,
          en => en,
          oe => oe,
          ld_pc => ld_pc,
          input_pc => input_pc,
          output_pc => output_pc
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
		en <= '0';
		ld_pc <= '0';

      wait for clock_period*10;
		
		en <= '1';
	
      wait for clock_period*10;
		
		en <= '0';
		oe <= '1';

      wait for clock_period*10;
		
		oe <= '0';
		rst <= '1';

      wait for clock_period*10;
     
	  	en <= '1';
		rst <= '0';
		
		wait for clock_period*10;
		
		oe <= '0';
		
      wait;
   end process;

END;
