library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ClkDivideby80 is
    port (
        in_50Mhz, reset : in std_logic; 
        out_dot625Mhz : out std_logic 
    );
end entity ClkDivideby80;

architecture rtl of ClkDivideby80 is
    signal intReset : std_logic; 
    signal intCounterOutput : std_logic_vector(6 downto 0);
begin
    counter: work.TnBitCounter(rtl)
        generic map(data_width => 7)
        port map(
				
            reset_actLow    => not(intReset) or not(reset),
            increment       => in_50Mhz,
            output          => intCounterOutput
        );

    intReset <= intCounterOutput(6) and intCounterOutput(4); 
    out_dot625Mhz <= intCounterOutput(6) and intCounterOutput(4);
end architecture; 
