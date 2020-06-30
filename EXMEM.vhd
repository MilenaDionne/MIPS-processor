library ieee;
use ieee.std_logic_1164.all;

entity EXMEM is
	port (
		aluResIn, muxIn1 : in std_logic_vector(31 downto 0);
		muxIn2 : in std_logic_vector(4 downto 0);
		aluResOut, muxOut1 : out std_logic_vector(31 downto 0);
		muxOut2 : out std_logic_vector(4 downto 0);
		
		-- control signals
		WBIn : in std_logic_vector(1 downto 0);
		MemIn : in std_logic_vector(2 downto 0);
		WBOut : out std_logic_vector(1 downto 0);
		MemOut : out std_logic_vector(2 downto 0);
		
		stall : in std_logic;
		
		-- clock&reset
		clk, rst : in std_logic
	);
	
end entity;

architecture buffArch of EXMEM is
	
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

	component reg5bit
	port ( 
		in5 : in std_logic_vector(4 downto 0);
		out5 : out std_logic_vector(4 downto 0);
		stall : in std_logic;
		clk, rst : in std_logic
	);
	end component;
	
	
begin
	
	-- control registers
	regCtrl2 : reg2bit port map (in2 => WbIn, out2 => WbOut, clk => clk, rst => rst, stall => stall);
	regCtrl3 : reg3bit port map (in3 => MemIn, out3 => MemOut, clk => clk, rst => rst, stall => stall);
	
	-- other registers
	aluResbuff : regpipeline port map (in32 => aluResIn, out32 => aluResOut, clk => clk, rst => rst, stall => stall);
	mux1buff : regpipeline port map (in32 => muxIn1, out32 => muxOut1, clk => clk, rst => rst, stall => stall);
	rsbuff: reg5bit port map (in5 => muxIn2, out5 => muxOut2, clk => clk, rst => rst, stall => stall);
	
end architecture;

