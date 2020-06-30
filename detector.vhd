library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- component used for overflow detection
-- Will be called for the most significants bits of add/sub module
-- when adding, if the sign of the two inputs is the same, but the result sign is different, 
-- then an overflow occurs.

entity detector is
	port (
		a, b, result : in std_logic;
		ovrflw : out std_logic
	);
end detector;

architecture behave of detector is
	
begin
	
ovrflw <= (not(a) and not(b) and result) or (a and b and not(result));

end behave;