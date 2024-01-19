--Down counter --

library ieee;
use ieee.std_logic_1164.all;
entity TnDownBitCounter is
	generic(data_width : integer := 4);
	port(
		reset_actLow, decrement: 	IN STD_LOGIC; 
		output : 						OUT std_logic_vector(data_width-1 downto 0)
	);
end TnDownBitCounter;
architecture rtl of TnDownBitCounter is
signal internal_outs : std_logic_vector(data_width-1 downto 0);
begin 
	lsb_t : work.TFlipFlop(rtl)
		port map(
			in_clk => decrement,
			T => '1',
			async_set_low => '1', 
			async_reset => reset_actLow,
			out_q => open,
			out_qBar => internal_outs(0)
		);
	gen: for i in 1 to data_width-1 generate
		t : work.TFlipFlop(rtl)
			port map(
				in_clk => internal_outs(i-1),
				T => '1',
				async_set_low => '1',
				async_reset => reset_actLow, 
				out_q => open,
				out_qBar => internal_outs(i) 
			);
	end generate; 
	
	output <= internal_outs; 
end rtl;