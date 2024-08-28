library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_unit is
    Port ( clock : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           inst : in  STD_LOGIC_VECTOR (5 downto 0);
           do : out  STD_LOGIC_VECTOR (28 downto 0);
			  zero : in STD_LOGIC
			  );
end control_unit;

architecture Behavioral of control_unit is

signal counter : std_logic_vector(3 downto 0);

begin

process(clock,rst)
begin

	if rst = '1' then
		counter <= "0000";
	end if;
	
	if rising_edge(clock) then
		if (counter =  "1010") then
			counter <= "0000";
		else
			 counter<= std_logic_vector(unsigned(counter+1));
		end if;
	end if;
	
end process;

--OUT_SEL_A--OUT_SEL_B--REG_IP_SEL--REG_WR--HLT--OUT_IN--OUT_OUT--ALU_OP_EN----------ALU_EN--PC_EN--PC_IN--PC_OUT-MAR_IN--RAM_IN--RAM_OUT--A_IN--A_OUT--B_IN--B_OUT--INST_I--INST_OUT
--28,27------26,25------24,23-------22------21------20---19-------18,17,16,15,14,13--12------11-----10-----9------8-------7-------6--------5-----4------3-----2------1-------0

do <= "00000000000000000001100000000" when counter = "0000" else
		"00000000000000000100001000010" when counter = "0001" else
		
		--ADD
		"00000000000000000000000000001" when (counter = "0010" and inst="000000") else    
      "00000000000000000000100000001" when (counter = "0011" and inst="000000") else
      "10110000000000000000000101000" when (counter = "0100" and inst="000000") else    
      "00000000000000001000000000000" when (counter = "0101" and inst="000000") else    
      "00000110000000001100000000000" when (counter = "0110" and inst="000000") else
       
		 --SUB
      "00000000000000010000000000001" when (counter = "0010" and inst="000001") else    
      "00000000000000010000100000001" when (counter = "0011" and inst="000001") else
      "10110000000000010000000101000" when (counter = "0100" and inst="000001") else    
      "00000000000000011000000000000" when (counter = "0101" and inst="000001") else    
      "00000110000000011010000000000" when (counter = "0110" and inst="000001") else
       
		--INC
		"00000000000000100000000000001" when (counter = "0010" and inst="000010") else	
      "00000000000000100000100000001" when (counter = "0011" and inst="000010") else
      "01000000000000100000000100000" when (counter = "0100" and inst="000010") else    
      "00000000000000101000000000000" when (counter = "0101" and inst="000010") else    
      "00000110000000101010000000000" when (counter = "0110" and inst="000010") else
		
		--DEC
		"00000000000000110000000000001" when (counter = "0010" and inst="000011") else	
      "00000000000000110000100000001" when (counter = "0011" and inst="000011") else
      "01000000000000110000000100000" when (counter = "0100" and inst="000011") else    
      "00000000000000111000000000000" when (counter = "0101" and inst="000011") else    
      "00000110000000111010100000000" when (counter = "0110" and inst="000011") else
		
		--AND
		"00000000000001000000000000001" when (counter = "0010" and inst="000100") else    
      "00000000000001000000100000001" when (counter = "0011" and inst="000100") else
      "10110000000001000000000101000" when (counter = "0100" and inst="000100") else    
      "00000000000001001000000000000" when (counter = "0101" and inst="000100") else    
      "00000110000001001010000000000" when (counter = "0110" and inst="000100") else
       
       
		 --OR
      "00000000000001010000000000001" when (counter = "0010" and inst="000101") else    
      "00000000000001010000100000001" when (counter = "0011" and inst="000101") else
      "10110000000001010000000101000" when (counter = "0100" and inst="000101") else    
      "00000000000001011000000000000" when (counter = "0101" and inst="000101") else    
      "00000110000001011010000000000" when (counter = "0110" and inst="000101") else
		
		--XOR
		"00000000000001100000000000001" when (counter = "0010" and inst="000110") else    
      "00000000000001100000100000001" when (counter = "0011" and inst="000110") else
      "10110000000001100000000101000" when (counter = "0100" and inst="000110") else    
      "00000000000001101000000000000" when (counter = "0101" and inst="000110") else    
      "00000110000001101010000000000" when (counter = "0110" and inst="000110") else
		
		 --NOT
		"00000000000001110000000000001" when (counter = "0010" and inst="000111") else	
      "00000000000001110000100000001" when (counter = "0011" and inst="000111") else
      "10000000000001110000000100000" when (counter = "0100" and inst="000111") else    
      "00000000000001111000000000000" when (counter = "0101" and inst="000111") else    
      "00000110000001111010000000000" when (counter = "0110" and inst="000111") else
		
		--LD
		"00000000000010000000000000001" when (counter = "0010" and inst="001000") else
      "00000000000010000000100000001" when (counter = "0011" and inst="001000") else
      "00000110000010000000001000000" when (counter = "0100" and inst="001000") else
      "00000000000010000000000000000" when (counter = "0101" and inst="001000") else
      "00000000000010000000000000000" when (counter = "0110" and inst="001000") else
		
		--ST
		"00000000000010010000000000001" when (counter = "0010" and inst="001001") else	
      "00000000000010010000000000001" when (counter = "0011" and inst="001001") else
      "01000000000010010000000100000" when (counter = "0100" and inst="001001") else    
      "00000000000010010000010010000" when (counter = "0101" and inst="001001") else    
      "00000000000010010000000000000" when (counter = "0110" and inst="001001") else
		
		--JMP
      "00000000000000000000000000001" when (counter= "0010" and inst="001010") else    
      "00000000000000000000100000001" when (counter= "0011" and inst="001010") else
      "00000000000000000000000000000" when (counter= "0100" and inst="001010") else    
      "00000000000000000000000000000" when (counter= "0101" and inst="001010") else    
      "00000000000000000000000000000" when (counter= "0110" and inst="001010") else
		
		--BEQ
      "00000000000010110000000000001" when (counter= "0010" and inst="001011") else    
      "00000000000010110000100000001" when (counter= "0011" and inst="001011") else
      "10010000000010111000000101000" when (counter= "0100" and inst="001011") else    
      "00000000000010111010000000000" when (counter= "0101" and inst="001011") else    
      "00000000000010110000100000000" when (counter= "0110" and inst="001011" and zero = '1') else
		
		--BNE
      "00000000000010110000000000001" when (counter= "0010" and inst="001011") else    
      "00000000000010110000100000001" when (counter= "0011" and inst="001011") else
      "10010000000010111000000101000" when (counter= "0100" and inst="001011") else    
      "00000000000010111010000000000" when (counter= "0101" and inst="001011") else    
      "00000000000010110000100000000" when (counter= "0110" and inst="001011" and zero = '0');	
		
end Behavioral;

