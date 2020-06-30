library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
port(
     RegData1,RegData2:in std_logic_vector(31 downto 0);
     equal:out std_logic
);
end entity;

architecture logic of comparator is

signal eq32:std_logic_vector(31 downto 0);

begin
	XNOR1:for i in 0 to 31 generate
		eq32(i)<=RegData1(i) xnor RegData2(i);
	end generate XNOR1;
	
	equal<=eq32(0) and eq32(1) and eq32(2) and eq32(3) and eq32(4) and eq32(5) and eq32(6) and eq32(7) and eq32(8) and eq32(9) and eq32(10) and eq32(11) and eq32(12) and eq32(13) and eq32(14) and eq32(15) and eq32(16) and eq32(17) and eq32(18) and eq32(19) and eq32(20) and eq32(21) and eq32(22) and eq32(23) and eq32(24) and eq32(25) and eq32(26) and eq32(27) and eq32(28) and eq32(29) and eq32(30) and eq32(31); 

end architecture;