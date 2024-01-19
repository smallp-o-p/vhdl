library ieee;
use ieee.std_logic_1164.all; 

entity TwoOneMux is 
	port(sel, in0, in1 : in std_logic;
		outp : out std_logic);
		
end TwoOneMux;
architecture rtl of TwoOneMux is 
begin 
	outp <= (not(sel) and in0) or (sel and in1);
end rtl;


library ieee;
use ieee.std_logic_1164.all;

entity nWideTwoOneMux is 
	generic(data_width : integer := 8);
	port(
			in0, in1: in std_logic_vector(data_width-1 downto 0);
			sel : in std_logic; 
			outp : out std_logic_vector(data_width-1 downto 0));

end nWideTwoOneMux; 

architecture rtl of nWideTwoOneMux is 

begin 
	gen: for i in 0 to data_width-1 generate 
		mux : work.TwoOneMux(rtl)
			port map(
				in0 => in0(i),
				in1 => in1(i),
				sel => sel,
				outp => outp(i)
			);
	end generate; 
end rtl; 			