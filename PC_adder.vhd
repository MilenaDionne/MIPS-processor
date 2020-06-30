library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;


entity PC_adder is
	
generic(g_next_instr : std_logic_vector(31 downto 0) := "00000000000000000000000000000100";
		g_carry_in : std_logic := '0');	
		
port (
	CarryIn : in std_logic := g_carry_in; 
	aluIn1 : in std_logic_vector(31 downto 0);
	aluOut : out std_logic_vector(31 downto 0);
	carryOut : out std_logic
);
end entity;
	
architecture PCaddarch of PC_adder is
	
--components used	
component adder 
	PORT ( Cin, x, y : IN STD_LOGIC ;
			s, Cout : OUT STD_LOGIC );
end component;
	
	signal carry: std_logic_vector(30 downto 0);
	signal nxt: std_logic_vector(31 downto 0);

--Architecture		
begin
	--nxt <= std_logic_vector(to_unsigned(g_next_instr, nxt'length)); -- Converts integer 4 to std_logic_vector

	outerloop: for i in 0 to 31 generate
		
		innerloop1: if (i = 0) generate
			add0: adder port map(x => aluIn1(i), y => g_next_instr(i), Cin => CarryIn, Cout => carry(i), s =>aluOut(i));
		end generate innerloop1;
		
		innerloop2: if (i>0 and i<31) generate 
				add: adder port map(x => aluIn1(i), y => g_next_instr(i), Cin => carry(i-1), Cout => carry(i), s =>aluOut(i));
		end generate innerloop2;
		
		innerloop3: if (i=31) generate
			add31: adder port map (x => aluIn1(i), y => g_next_instr(i), Cin => carry(i-1), Cout => carryOut, s =>aluOut(i));
		end generate innerloop3;
		
	end generate outerloop;

end PCaddarch;




