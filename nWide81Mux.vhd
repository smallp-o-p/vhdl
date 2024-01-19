library ieee;
use ieee.std_logic_1164.all;

entity mux81 is
	port(
			i0, i1, i2, i3, i4, i5, i6, i7	: in std_logic;
			sel 										: in std_logic_vector(2 downto 0);
			outp 										: out std_logic
	);
end mux81; 

architecture rtl of mux81 is 
begin
	outp <= 
		(not(sel(2)) and not(sel(1)) and not(sel(0)) and i0) 	or
		(not(sel(2)) and not(sel(1)) and sel(0) and i1) 		or
		(not(sel(2)) and sel(1) and not(sel(0)) and i2) 		or		
		(not(sel(2)) and sel(1) and sel(0) and i3) 				or
		(sel(2) and not(sel(1)) and not(sel(0)) and i4) 		or
		(sel(2) and not(sel(1)) and sel(0) and i5) 				or
		(sel(2) and sel(1) and not(sel(0)) and i6) 				or
		(sel(2) and sel(1) and sel(0) and i7);
end rtl; 


library ieee;
use ieee.std_logic_1164.all;

entity nWide81Mux is 
	generic(data_width : integer := 8);
	port(
		i0, i1, i2, i3, i4, i5, i6, i7	: in std_logic_vector(data_width-1 downto 0);
		sel 										: in std_logic_vector(2 downto 0);
		outp 										: out std_logic_vector(data_width-1 downto 0)
		); 
end nWide81Mux; 

architecture rtl of nWide81Mux is
begin
	genMuxes: for i in 0 to data_width-1 generate
		smallMux : work.mux81(rtl)
			port map(
				i0 	=> i0(i), 
				i1 	=> i1(i), 
				i2 	=> i2(i), 
				i3 	=> i3(i), 
				i4 	=> i4(i), 
				i5 	=> i5(i), 
				i6 	=> i6(i), 
				i7 	=> i7(i),
				sel 	=> sel,
				outp 	=> outp(i)
			);
	end generate; 
	
end rtl;