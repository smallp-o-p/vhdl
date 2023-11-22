LIBRARY ieee;
USE ieee.std_logic_1164.ALL; 
ENTITY FourOneMux IS 
	PORT(
		zero, one, two, three : IN STD_LOGIC;
		sel0, sel1 : IN STD_LOGIC;
		output : OUT STD_LOGIC 
	);
END FourOneMux;
ARCHITECTURE rtl of FourOneMux IS
BEGIN 
	output <= 	(three and sel0 and sel1) 
					or (two and not(sel0) and sel1) 
					or (one and sel0 and not(sel1))
					or (zero and not(sel0) and not(sel1)); 
END rtl; 
