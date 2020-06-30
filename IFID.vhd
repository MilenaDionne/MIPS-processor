library ieee;
use ieee.std_logic_1164.all;

entity IFID is
	port (
		pc4In, instructionIn : in std_logic_vector(31 downto 0);
		pc4Out, instructionOut : out std_logic_vector(31 downto 0);
		hzdCtrl : in std_logic;
		clk, rst : in std_logic
	);
end IFID;

architecture buffArch of IFID is
	
	-- signals and components
	
	component PC is 
		port(
		  clk    : in STD_LOGIC;
		  rst    : in STD_LOGIC;
		  PC_in  : in STD_LOGIC_VECTOR (31 downto 0);
		  PC_out : out STD_LOGIC_VECTOR (31 downto 0);
		  stall : in std_logic);
	end component;


begin
	
	-- this should be enough since it follows the D_latch architecture right?
	pc4buff: PC port map (clk => clk, rst => rst, PC_in => pc4In, PC_out => pc4out, stall => hzdCtrl);
	intructionbuff: PC port map (clk => clk, rst => rst, PC_in => instructionIn, PC_out => instructionOut, stall => hzdCtrl);
		
end buffArch;

