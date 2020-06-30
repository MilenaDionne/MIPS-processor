library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--Main ALU. Composed of add&sub, detector, mux32x4
--The ALU is design to operate with 32 bits operands. In the 8 bits data version, 
--sign extends for operands will be needed to extend operands to 32 bits.
--Similarly, the 32 bits ALU output will have to be sliced to 8 bits when data mem is 256x8.
entity ALUMain is
	
port (
	aluOP : in std_logic_vector(2 downto 0); --Most significant bit of aluOP (aluOP(2)) will determine Cin for add/sub operation. Cin=1 for sub
	aluIn1, aluIn2 : in std_logic_vector(31 downto 0);
	aluOut : out std_logic_vector(31 downto 0); -- for a 256x8 data mem, output will be sliced to 8 bits
	CarryOut : out std_logic;
	ovrFlw : out std_logic;
	zero : out std_logic
);
end entity;

architecture aluMainArch of ALUMain is

--components used--------	
component addsub
	PORT ( Cin, x, y : IN STD_LOGIC ;
			s, Cout : OUT STD_LOGIC );
end component;

component mux32x4
	port(
		sel :in std_logic_vector(1 downto 0); 
		logicAND, logicOR, add_sub: in std_logic_vector(31 downto 0);
		z: out std_logic_vector(31 downto 0)
	);
end component;

component detector
	port (
		a, b, result : in std_logic;
		ovrflw : out std_logic
	);
end component;

--carry signal through full adders
	signal carry: std_logic_vector(30 downto 0);
-- Signal for result of add/sub operation
	signal sig_aluOut: std_logic_vector(31 downto 0); 
-- signals for operations
	signal sig_OR: std_logic_vector(31 downto 0);
	signal sig_AND: std_logic_vector(31 downto 0);
	 
	
--Architecture------------	
begin
	
		outerloop: for i in 0 to 31 generate

--Most significant bit of aluOP (aluOP(2)) will determine Cin for add/sub operation. Cin=1 for sub
-- Set the initial Cin to 1 instead of 0, thus adding an extra 1 to the sum	for a sub operation	
		innerloop1: if (i = 0) generate
			addSub0: addsub port map(Cin => aluOP(2), x => aluIn1(i), y => aluIn2(i),
										s => sig_aluOut(i), Cout => carry(i));
		end generate innerloop1;
		
		innerloop2: if (i>0 and i<31) generate 
				addsub1: addsub port map(Cin => carry(i-1), x => aluIn1(i), y => aluIn2(i),
										s => sig_aluOut(i), Cout => carry(i));
		end generate innerloop2;
		
		innerloop3: if (i=31) generate
			add31: addsub port map (Cin => carry(i-1), x => aluIn1(i), y => aluIn2(i),
										s => sig_aluOut(i), Cout => CarryOut);
		end generate innerloop3;
		
	end generate outerloop;
	
	overflow: detector port map(a => aluIn1(31), b => aluIn2(31), result => sig_aluOut(31), ovrflw => ovrflw);
	operation: mux32x4 port map(sel => aluOP(1 downto 0), logicAND => sig_AND, logicOR => sig_OR, add_sub => sig_aluOut, z => aluOut);

	sig_OR <= aluIn1 or aluIn2;
	sig_AND <= aluIn1 and aluIn2;
	
	zero <= not(sig_aluOut(0) or sig_aluOut(1) or sig_aluOut(2) or sig_aluOut(3) or sig_aluOut(4) or sig_aluOut(5) or
		 sig_aluOut(6) or sig_aluOut(7) or sig_aluOut(8) or sig_aluOut(9) or sig_aluOut(10) or sig_aluOut(11) or sig_aluOut(12) or
		  sig_aluOut(13) or sig_aluOut(14) or sig_aluOut(15) or sig_aluOut(16) or sig_aluOut(17) or sig_aluOut(18) or sig_aluOut(19) or
		   sig_aluOut(20) or sig_aluOut(21) or sig_aluOut(22) or sig_aluOut(23) or sig_aluOut(24) or sig_aluOut(25) or sig_aluOut(26) or
		    sig_aluOut(27) or sig_aluOut(28) or sig_aluOut(29) or sig_aluOut(30) or sig_aluOut(31));
		    	
	
	
end architecture;	


	
	
	

	