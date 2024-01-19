library ieee;
use ieee.std_logic_1164.all;

entity nWide41Mux is 
	generic(data_width: integer := 8);
	port(
		zero, one, two, three 	: in std_logic_vector(data_width-1 downto 0);
		sel 							: in std_logic_vector(1 downto 0); 
		outp							: out std_logic_vector(data_width -1 downto 0)
	);
end nWide41Mux;

architecture rtl of nWide41Mux is 
begin 
	gen: for i in 0 to data_width-1 generate
		mux : work.FourOneMux(rtl)
			port map(
				zero => zero(i),
				one => one(i),
				two => two(i),
				three => three(i),
				sel0 => sel(0),
				sel1 => sel(1),
				output => outp(i)
			);
	end generate; 
end architecture rtl;  