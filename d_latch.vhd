library ieee;

use ieee.std_logic_1164.all;

entity d_latch is
	port(
		d, clk, rst, stall: in std_logic; 
   		q: out std_logic
	);
end d_latch;

architecture basic of d_latch is

begin
     latch_behavior: process (rst, clk)
     begin
        if rst = '1' then
        	q <= '0';
        elsif (rising_edge(clk) and stall = '0') then	
    		q <= d;
    	end if;
     end process latch_behavior;
end architecture basic;
