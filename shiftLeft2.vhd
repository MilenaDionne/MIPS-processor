-- dont actually need shifting hardware, all you do is add
-- 00 to the least significant side (Figure 4.9 textbook p.256)

-- This shift component is used for the Branch Target Calculation
-- adder

library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftLeft2 is
	-- im thinking this one discards the msb ends 
	-- and the jump one doesnt, just adds 00
port (
	slIn : in std_logic_vector(31 downto 0);
	slOut : out std_logic_vector(31 downto 0) 
);
end shiftLeft2;

architecture bsl of shiftLeft2 is
	signal temp: std_logic_vector(29 downto 0);
begin
       temp<=slIn(29 downto 0);	 
	   slOut(31 downto 2)<=temp;
	   slOut(1 downto 0)<= (others=>'0');
	 
end bsl;