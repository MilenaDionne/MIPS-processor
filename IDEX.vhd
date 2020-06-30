library ieee;
use ieee.std_logic_1164.all;

entity IDEX is
	port (
		readData1In, readData2In, signExtendIn : in std_logic_vector(31 downto 0);
		readData1Out, readData2Out, signExtendOut : out std_logic_vector(31 downto 0);
		
		-- control signals
		WbIn : in std_logic_vector(1 downto 0);
		MemIn : in std_logic_vector(2 downto 0);
		ExIn : in std_logic_vector(3 downto 0);
		
		WBOut : out std_logic_vector(1 downto 0);
		MemOut : out std_logic_vector(2 downto 0);
		ExOut : out std_logic_vector(3 downto 0);
		
		-- rs, rt, rd
		rsIn, rtIn1, rtIn2, rdIn : in std_logic_vector(4 downto 0);
		rsOut, rtOut1, rtOut2, rdOut : out std_logic_vector(4 downto 0);
		
		stall : in std_logic;
		
		-- clock&reset
		clk, rst : in std_logic
	);
end IDEX;

architecture buffArch of IDEX is
	
	-- signals and components
	component regpipeline
	port ( 
		in32 : in std_logic_vector(31 downto 0);
		out32 : out std_logic_vector(31 downto 0);
		stall : in std_logic;
		clk, rst : in std_logic
	);
	end component;
		
	component reg2bit
	port ( 
		in2 : in std_logic_vector(1 downto 0);
		out2 : out std_logic_vector(1 downto 0);
		stall : in std_logic;
		clk, rst : in std_logic
	);
	end component;
	
	component reg3bit
	port ( 
		in3 : in std_logic_vector(2 downto 0);
		out3 : out std_logic_vector(2 downto 0);
		stall : in std_logic;
		clk, rst : in std_logic
	);
	end component;
	
	component reg4bit
	port ( 
		in4 : in std_logic_vector(3 downto 0);
		out4 : out std_logic_vector(3 downto 0);
		stall : in std_logic;
		clk, rst : in std_logic
	);
	end component;
	
	component reg5bit
	port ( 
		in5 : in std_logic_vector(4 downto 0);
		out5 : out std_logic_vector(4 downto 0);
		stall : in std_logic;
		clk, rst : in std_logic
	);
	end component;
	
begin
	
	readData1Out <= readData1In; 
	readData2Out <= readData2In; 
	signExtendOut <= signExtendIn; 
	
	-- IF/ID buffer outputs
	
	rsbuff: reg5bit port map (in5 => rsIn, out5 => rsOut, clk => clk, rst => rst, stall => stall);
	rt1buff: reg5bit port map (in5 => rtIn1, out5 => rtOut1, clk => clk, rst => rst, stall => stall);
	rt2buff: reg5bit port map (in5 => rtIn2, out5 => rtOut2, clk => clk, rst => rst, stall => stall);
	rdbuff: reg5bit port map (in5 => rdIn, out5 => rdOut, clk => clk, rst => rst, stall => stall);
	
	
	-- when accessing the individual bits of the output, 
	-- just use WBOut(0), MemOut(1 downto 0), etc.
	regCtrl2: reg2bit port map (in2 => WBIn, out2 => WbOut, clk => clk, rst => rst, stall => stall);
	regCtrl3: reg3bit port map (in3 => MemIn, out3 => MemOut, clk => clk, rst => rst, stall => stall);
	regCtrl4: reg4bit port map (in4 => ExIn, out4 => ExOut, clk => clk, rst => rst, stall => stall);
	
end architecture;


	
	
	