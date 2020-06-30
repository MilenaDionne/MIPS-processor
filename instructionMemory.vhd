library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  

--takes ROM file to store instruction 
entity instructionMemory is
	port (
		address		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end instructionMemory;

architecture arch of instructionMemory is
	component ROM
		PORT(
			address		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END component;
begin
	ROM_inst : ROM PORT MAP (
	address	 => address,
	clock	 => clock,
	q	 => q
	);

end arch;