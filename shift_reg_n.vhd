LIBRARY ieee;
USE ieee.std_logic_1164.ALL; 
ENTITY shift_reg_n IS
	generic(data_width : integer := 8); 
	PORT(
		in_clk, in_reset, in_SHL, in_SHR, in_lsb, in_msb: IN STD_LOGIC; 
		in_load : IN STD_LOGIC_VECTOR(data_width-1 downto 0); 
		out_bits, out_qBits : OUT STD_LOGIC_VECTOR(data_width-1 downto 0);
		out_lsb, out_msb : OUT std_logic 
		);
END shift_reg_n; 

ARCHITECTURE rtl of shift_reg_n IS
	SIGNAL int_value, int_notValue, int_muxOutputs, int_msb_shifted_right, int_lsb_shifted_left : STD_LOGIC_VECTOR(data_width-1 downto 0);
BEGIN 
	-- bits 
	lsb: work.ASetDFF(rtl)
		PORT MAP(
			i_clk 		=> in_clk,
			i_DASet 	=> '1',
			i_DAReset 	=> in_reset,
			in_d 		=> int_muxOutputs(0),
			out_q 		=> int_value(0),
			out_qBar 	=> int_notValue(0)
		);	
		
	mux_lsb: work.mux41n(rtl)
		port map(
			zero 	=> int_value(0),
			one 	=> in_lsb,
			two 	=> int_value(1),
			three 	=> in_load(0),
			sel0 	=> in_SHL,
			sel1 	=> in_SHR,
			output 	=> int_muxOutputs(0)
		);


	genbits : for i in 1 to data_width-2 generate
	flipflop : work.ASetDFF(rtl)
		PORT MAP(
			i_clk 		=> in_clk,
			i_DASet 	=> '1',
			i_DAReset 	=> in_reset, 
			in_d 		=> int_muxOutputs(i),
			out_q 		=> int_value(i),
			out_qBar 	=> int_notValue(i)
		);
	end generate; 
	
	
	genmuxes: for i in 1 to data_width-2 generate 
	fourOneMux : work.mux41n(rtl)
		port map(
			zero 		=> int_value(i),
			one 		=> int_value(i-1),
			two 		=> int_value(i+1),
			three 		=> in_load(i),
			sel0 		=> in_SHL,
			sel1 		=> in_SHR,
			output 		=> int_muxOutputs(i)
		);
	end generate; 
	
	
	msb: work.ASetDFF(rtl)
		PORT MAP(
			i_clk 		=> in_clk,
			i_DASet 	=> '1',
			i_DAReset 	=> in_reset, 
			in_d 		=> int_muxOutputs(data_width-1),
			out_q 		=> int_value(data_width-1),
			out_qBar 	=> int_notValue(data_width-1)
		);
	mux_msb: work.mux41n(rtl)
		port map(
			zero 		=> int_value(data_width-1),
			one 		=> int_value(data_width-2),
			two 		=> in_msb,
			three 		=> in_load(data_width-1),
			sel0 		=> in_SHL,
			sel1 		=> in_SHR,
			output 		=> int_muxOutputs(data_width-1)
		);
		
	out_bits <= int_value; 
	out_qBits <= int_notValue; 
	out_msb <= int_value(data_width-1) and (in_SHL and not(in_SHR)); 
	out_lsb <= int_value(0); 
END rtl; 
