-- 5 bit register used in the pipeline buffers

library ieee;
use ieee.std_logic_1164.all;

entity reg5bit is
	port ( 
		in5 : in std_logic_vector(4 downto 0);
		out5 : out std_logic_vector(4 downto 0);
		stall : in std_logic;
		clk, rst : in std_logic
	);
end entity;

architecture regArch of reg5bit is
	
	-- signals and components
	component d_latch
	port(
		d, clk, rst, stall: in std_logic; 
		q: out std_logic
	);
	end component;
	
begin
	
	reg5bitloop : for i in 4 downto 0 generate
		d: d_latch port map (d => in5(i), q => out5(i), clk => clk, rst => rst, stall => stall);
	end generate;
	
end architecture;
		

