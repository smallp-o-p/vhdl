library ieee;
use ieee.std_logic_1164.all; 
entity TFlipFlop is
	port(
	T, in_clk, async_reset, async_set_low : in std_logic;
	out_q, out_qBar : out std_logic);
end TFlipFlop;

architecture rtl of TFlipFlop is
signal int_q, int_qBar : std_logic;
begin 
	d: work.ASetDFlipFlop(rtl)
		port map(
				i_clk => in_clk, 
				in_d => T xor int_q,
				out_q => int_q,
				out_qBar => int_qBar,
				i_DASet => async_set_low,
				i_DAReset => async_reset
		);
		out_q <= int_q;
		out_qBar <= int_qBar; 
end rtl;

