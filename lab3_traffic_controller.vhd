library ieee;
use ieee.std_logic_1164.all; 

entity lab3_traffic_controller is
	port(
		MSCInp, SSCInp : 						in std_logic_vector(3 downto 0);
		SSCS, GClock, GReset : 				in std_logic; 
		MSTL, SSTL, MT_temp, ST_temp : 	out std_logic_vector(2 downto 0);
		BCD1, BCD2, SSC_temp, MSC_temp : out std_logic_vector(3 downto 0);
		S0, S1, S2, S3, S4, o_d0, o_d1, o_d2, dbounced : 				out std_logic
	);
end lab3_traffic_controller;


architecture rtl of lab3_traffic_controller is
signal MSC, MT, SSC, SST : std_logic; 
signal int_d1, int_d0, not_int_d1, not_int_d0, debounced_SSCS : std_logic; 
signal ST_downCounter, MT_downCounter : std_logic_vector(2 downto 0);
signal MSC_upCounter, SSC_upCounter, sum_MSC_counter, sum_SSC_counter : std_logic_vector(3 downto 0);

begin 

	msc_count : work.TnBitCounter(rtl)
			generic map(data_width => 4)
			port map(	S4 <= int_d2 and not_int_d1 and not_int_d0; 
				reset_actLow => GReset and not(not_int_d1 and not_int_d0), 
				output => MSC_upCounter
			);
			
	compare_MSC : work.nBitAdder(rtl) 
	 generic map(data_width => 4)
	 port map(
		a_in => MSCInp,
		b_in => MSC_upCounter,
		s_out => sum_MSC_counter,
		subtract => '1', 
		overflow_out => open,
		c_out => open 
	 );
	 
	 
	MSC <= sum_MSC_counter(3) or sum_MSC_counter(2) or sum_MSC_counter(1) or sum_MSC_counter(0);
	MSC_temp <= MSC_upCounter; 
	
	ssc_count : work.TnBitCounter(rtl)
		generic map(data_width => 4)
		port map(
			increment => GClock and SSC,
			reset_actLow => GReset and not(int_d0 and int_d1), 
			output => SSC_upCounter
		);
	
	compare_SSC : work.nBitAdder(rtl)
	 generic map(data_width => 4)
	 port map(
		a_in => SSCInp,
		b_in => SSC_upCounter,
		s_out => sum_SSC_counter,
		subtract => '1',
		overflow_out => open,
		c_out => open
	 );
	SSC <= sum_SSC_counter(3) or sum_SSC_counter(2) or sum_SSC_counter(1) or sum_SSC_counter(0);
	SSC_temp <= SSC_upCounter; 
	
	currentCount : work.nWideTwoOneMux(rtl)
		generic map(data_width => 4)
		port map(
			in0 => MSC_upCounter,
			in1 => SSC_upCounter,
			sel => not_int_d2 and int_d1 and int_d0,
			outp => BCD1 
		);
	
	mt_downcount : work.TnDownBitCounter(rtl)
		generic map(data_width => 3)
		port map(
			decrement => GClock and (not_int_d1 and int_d0),
			reset_actLow => GReset, 
			output => MT_downCounter
		);
		
	MT <= MT_downCounter(2) or MT_downCounter(1) or MT_downCounter(0);
	MT_temp <= MT_downCounter; 
	
	SST_downcount : work.TnDownBitCounter(rtl)
		generic map(data_width => 3)
		port map(
			decrement => GClock and (int_d1 and not_int_d0),
			reset_actLow => GReset, 
			output => ST_downCounter
		);
	SST <= ST_downCounter(2) or ST_downCounter(1) or ST_downCounter(0);
	ST_temp <= ST_downCounter;
	
	
	debouncer: work.debouncer(fsm)
		port map(
			i_raw => SSCS,
			i_clock => GClock,
			o_clean => debounced_SSCS
		);
		
	dbounced <= debounced_SSCS; 
		
	 
	d0 : work.ASetDFlipFlop(rtl)
	 port map(
		i_clk => GClock,
		in_d => 	( not_int_d1 and not_int_d0 and (not(MSC) and debounced_SSCS) ) or 
					( not_int_d1 and int_d0 ) or 
					( int_d1 and int_d0 and SSC ), 
		i_DASet => '1',
		i_DAReset => GReset,
		out_q => int_d0, 
		out_qBar => not_int_d0
	 );
	 
	d1 : work.ASetDFlipFlop(rtl)
		port map( 
			i_clk => GClock,
			in_d => 	( not_int_d1 and int_d0 and not(MT) ) or 
						( int_d1 and int_d0) or
						( int_d1 and not_int_d0 and SST),
			i_DASet => '1',
			i_DAReset => GReset,
			out_q => int_d1,
			out_qBar => not_int_d1
		);
		
		
		
	MSTL(2) <= not_int_d1 and not_int_d0;
	MSTL(1) <= not_int_d1 and int_d0; 
	MSTL(0) <= int_d1; 
	
	SSTL(2) <= int_d1 and int_d0; 
	SSTL(1) <= int_d1 and not_int_d0; 
	SSTL(0) <= not_int_d1;  
	
	S0 <= not_int_d1 and not_int_d0;
	S1 <= not_int_d1 and not_int_d0;
	S2 <= int_d1 and int_d0;
	S3 <= int_d1 and not_int_d0;
	
	o_d0 <= int_d0;
	o_d1 <= int_d1;

end architecture; 
