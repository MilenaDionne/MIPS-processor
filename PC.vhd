library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- PC register

entity PC is 
port(
  clk    : in STD_LOGIC;
  rst    : in STD_LOGIC;
  PC_in  : in STD_LOGIC_VECTOR (31 downto 0);
  PC_out : out STD_LOGIC_VECTOR (31 downto 0);
  stall : in std_logic);
end PC;

architecture reg of PC is

--components used
component d_latch is
   port(d, clk, rst, stall: in std_logic; q: out std_logic);
end component;


--Architecture 
begin

iFF : for i in 0 to 31 generate
FF : d_latch port map (d => PC_in(i), clk => clk, rst => rst, q => PC_out(i), stall => stall);
end generate iFF;

end architecture reg;

-- Linking of components and top level entity
