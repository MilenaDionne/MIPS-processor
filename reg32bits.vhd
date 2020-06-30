library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 32 bits register used in the register file.


entity reg32bits is
	port(
		clk, load : in std_logic;
		din: in std_logic_vector(31 downto 0);
		dout: out std_logic_vector(31 downto 0));
		
end reg32bits;

architecture regbehave of reg32bits is

--components used
component d_latch is
   port(d, clk, rst, stall: in std_logic; q: out std_logic);
end component;

--component and_gate2 is
--	port (clk, load: in std_logic; y: out std_logic);
--end component;

    signal int_clk : std_logic;
    signal zero : std_logic := '0';
--Architecture  
begin
	
	--gate: and_gate2 port map(clk => clk, load =>load, y => int_clk); NOT used anymore
		
	oneloop: for i in 0 to 31 generate
		
		bits: d_latch port map(d => din(i), clk => int_clk, rst => zero, q => dout(i), stall => load);
		
	end generate oneloop;

end architecture regbehave;



