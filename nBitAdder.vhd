library ieee;
use ieee.std_logic_1164.all; 

entity FullAdder is 
    port(a, b, c_in : in std_logic; 
        c_out, s_out : out std_logic
    );
end FullAdder;

architecture rtl of FullAdder is
begin 
    s_out <= c_in xor (a xor b);
    c_out <= ((a xor b) and c_in) or (a and b); 
end rtl; 

library ieee; 
use ieee.std_logic_1164.all; 

entity nBitAdder is 
generic(data_width : integer := 8);
    port(a_in, b_in : in std_logic_vector(data_width-1 downto 0); 
        subtract : in std_logic; 
        c_out, overflow_out : out std_logic;
        s_out : out std_logic_vector(data_width-1 downto 0));
end nBitAdder; 

architecture rtl of nBitAdder is 
signal carries : std_logic_vector(data_width-1 downto 0);
begin 
	fa_lsb: entity work.FullAdder(rtl)
        port map(
            a=> a_in(0),
            b=> (b_in(0) xor subtract),
            c_in => subtract, 
            s_out => s_out(0),
            c_out => carries(0)
        );
	gen: for i in 1 to data_width-1 generate
		foo: entity work.FullAdder(rtl)
            port map(
                a=> a_in(i),
                b => (b_in(i) xor subtract),
                c_in => carries(i-1),
                s_out => s_out(i),
                c_out => carries(i)
            );
	end generate; 
	
	c_out <= carries(data_width-1);
	overflow_out <= carries(data_width-1) xor carries(data_width-2);
end rtl; 
