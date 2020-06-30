library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 2 inputs mux (9 bits)
-- Used to drive control signals or 0 into ID/EX

entity stallMux is
port (
		sel : in std_logic;
		a, b : in std_logic_vector(8 downto 0);
		z : out std_logic_vector(8 downto 0)
	);
end stallMux;

architecture muxBehave of stallMux is

component mux1x2 is	
port(
		sel : in std_logic;
		a, b : in std_logic;
		z : out std_logic
	);	
end component;	
begin
	
	generate8: for i in 0 to 8 generate
	
	mux_gen: mux1x2 port map(a => a(i), b => b(i), sel => sel, z => z(i));	
	end generate;
end architecture muxBehave;


