LIBRARY ieee;
USE ieee.std_logic_1164.ALL; 

ENTITY ASetDFF IS 
	PORT(
		i_clk, in_d, i_DASet, i_DAReset : IN STD_LOGIC;
		out_q, out_qBar : OUT STD_LOGIC);
END ASetDFF;

ARCHITECTURE rtl of ASetDFF IS
	SIGNAL int_q, int_qBar : STD_LOGIC;
	SIGNAL int_s, int_r, int_top, int_bottom : STD_LOGIC; 
BEGIN 

	int_top <= not(i_DASet and int_bottom and int_s); 
	int_s <= not(int_top and i_clk and i_DAReset);
	int_r <= not(int_bottom and i_clk and int_s);
	int_bottom <= not(in_d and int_r and i_DAReset);

	int_q <= not(int_s and int_qBar and i_DASet);
	int_qBar <= not(int_q and int_r and i_DAReset);
	
	out_q <= int_q;
	out_qBar <= int_qBar; 

END rtl; 
