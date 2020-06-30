-- 3 bit register used in the pipeline buffers

library ieee;
use ieee.std_logic_1164.all;

entity reg3bit is
	port ( 
		in3 : in std_logic_vector(2 downto 0);
		out3 : out std_logic_vector(2 downto 0);
		stall : in std_logic;
		clk, rst : in std_logic
	);
end entity;

architecture regArch of reg3bit is
	
	-- signals and components
	component d_latch
	port(
		d, clk, rst, stall: in std_logic; 
		q: out std_logic
	);
	end component;
	
begin
	
	reg3bitloop : for i in 2 downto 0 generate
		d: d_latch port map (d => in3(i), q => out3(i), clk => clk, rst => rst, stall => stall);
	end generate;
	
end architecture;