-- 2 bit register used in the pipeline buffers

library ieee;
use ieee.std_logic_1164.all;

entity reg2bit is
	port ( 
		in2 : in std_logic_vector(1 downto 0);
		out2 : out std_logic_vector(1 downto 0);
		stall : in std_logic;
		clk, rst : in std_logic
	);
end entity;

architecture regArch of reg2bit is
	
	-- signals and components
	component d_latch
	port(
		d, clk, rst, stall: in std_logic; 
		q: out std_logic
	);
	end component;
	
begin
	
	reg2bitloop : for i in 1 downto 0 generate
		d: d_latch port map (d => in2(i), q => out2(i), clk => clk, rst => rst, stall => stall);
	end generate;
	
end architecture;
		