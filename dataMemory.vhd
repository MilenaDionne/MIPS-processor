library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  

--takes ROM file to store instruction 
entity dataMemory is
	port (
		address		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end dataMemory;

architecture arch of dataMemory is
	component ram IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component;
begin
	RAM_inst : RAM PORT MAP (
	address	 => address,
	clock	 => clock,
	data => data, 
	wren => wren, 
	q	 => q
	);

end arch;