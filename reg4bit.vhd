-- 4 bit register used in the pipeline buffers

library ieee;
use ieee.std_logic_1164.all;

entity reg4bit is
	port ( 
		in4 : in std_logic_vector(3 downto 0);
		out4 : out std_logic_vector(3 downto 0);
		stall : in std_logic;
		clk, rst : in std_logic
	);
end entity;

architecture regArch of reg4bit is
	
	-- signals and components
	component d_latch
	port(
		d, clk, rst, stall: in std_logic; 
		q: out std_logic
	);
	end component;
	
begin
	
	reg4bitloop : for i in 3 downto 0 generate
		d: d_latch port map (d => in4(i), q =>out4(i), clk => clk, rst => rst, stall => stall);
	end generate;
	
end architecture;
		