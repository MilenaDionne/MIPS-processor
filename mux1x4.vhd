library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

-- 4 inputs mux (1 bit)

entity mux1x4 is
	port(
		sel :in std_logic_vector(1 downto 0); 
		logicAND, logicOR, add_sub: in std_logic;
		z: out std_logic
	);
end entity mux1x4;

architecture muxBehave of mux1x4 is
	
begin
	z <= ( (not sel(1) and (not sel(0)) and logicAND) or (not sel(1) and sel(0) and logicOR) or
		(sel(1) and sel(0) and add_sub) or (sel(1) and sel(0) ) );

end architecture muxBehave;