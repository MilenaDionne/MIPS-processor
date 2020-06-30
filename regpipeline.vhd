-- 32 bit register used in the pipeline buffers

library ieee;
use ieee.std_logic_1164.all;

entity regpipeline is
	port ( 
		in32 : in std_logic_vector(31 downto 0);
		out32 : out std_logic_vector(31 downto 0);
		stall : in std_logic;
		clk, rst : in std_logic
	);
end regpipeline;

architecture regArch of regpipeline is
	
	-- signals and components
	component d_latch
	port(
		d, clk, rst, stall: in std_logic; 
		q: out std_logic
	);
	end component;
	
begin
	
	reg32bitloop : for i in 31 downto 0 generate
		d: d_latch port map (d => in32(i), q => out32(i), clk => clk, rst => rst, stall => stall);
	end generate;
	
end regArch;
		

