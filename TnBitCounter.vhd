--Up counter --

library ieee;
use ieee.std_logic_1164.all;
entity TnBitCounter is
	generic(data_width : integer := 4);
	port(reset_actLow, increment: IN STD_LOGIC; 
			output : OUT std_logic_vector(data_width-1 downto 0)
	);
end TnBitCounter;
architecture rtl of TnBitCounter is
signal internal_outs : std_logic_vector(data_width-1 downto 0);
begin 
	lsb_t : work.TFlipFlop(rtl)
		port map(
			in_clk => increment,
			T => '1',
			async_reset => reset_actLow,
			async_set_low => '1',
			out_q => internal_outs(0),
			out_qBar => open
		);
	gen: for i in 1 to data_width-1 generate
		t : work.TFlipFlop(rtl)
			port map(
				in_clk => not(internal_outs(i-1)),
				T => '1',
				async_set_low => '1',
				async_reset => reset_actLow, 
				out_q => internal_outs(i),
				out_qBar => open 
			);
	end generate; 
	
	output <= internal_outs; 
end rtl;