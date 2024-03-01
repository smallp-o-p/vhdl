LIBRARY ieee;
USE ieee.std_logic_1164.ALL; 
ENTITY mux41 IS 
	PORT(
		zero, one, two, three : IN STD_LOGIC;
		sel0, sel1 : IN STD_LOGIC;
		output : OUT STD_LOGIC 
	);
END mux41;
ARCHITECTURE rtl of mux41 IS
BEGIN 
	output <= 	(three and sel0 and sel1) 
					or (two and not(sel0) and sel1) 
					or (one and sel0 and not(sel1))
					or (zero and not(sel0) and not(sel1)); 
END rtl; 

library ieee;
use ieee.std_logic_1164.all;
entity mux41n is 
	generic(data_width: integer := 8);
	port(
		zero, one, two, three 	: in std_logic_vector(data_width-1 downto 0);
		sel 							: in std_logic_vector(1 downto 0); 
		outp							: out std_logic_vector(data_width -1 downto 0)
	);
end mux41n;

architecture rtl of mux41n is 
begin 
	gen: for i in 0 to data_width-1 generate
		mux : work.mux41(rtl)
			port map(
				zero 	=> zero(i),
				one 	=> one(i),
				two 	=> two(i),
				three 	=> three(i),
				sel0 	=> sel(0),
				sel1 	=> sel(1),
				output 	=> outp(i)
			);
	end generate; 
end architecture rtl;  
