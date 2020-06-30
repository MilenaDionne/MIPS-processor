library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity registerfile is 
port (
	RR1 : in STD_LOGIC_VECTOR (4 downto 0); --Read register 1
   RR2 : in STD_LOGIC_VECTOR (4 downto 0); -- Read Register 2
   WR : in STD_LOGIC_VECTOR (4 downto 0); --Write Register
	WD : in STD_LOGIC_VECTOR (31 downto 0); -- Write data
	clk : in STD_LOGIC;
   RegWrite : in STD_LOGIC;
   RD1 : out STD_LOGIC_VECTOR (31 downto 0); --Read data 1
   RD2 : out STD_LOGIC_VECTOR (31 downto 0) --Read data 2 
);
end registerfile; 

architecture Behavioral of registerfile is -- 4 Registers, 8 bits each
    type reg_array is array(0 to 7) of STD_LOGIC_VECTOR (31 downto 0);
    signal reg_file: reg_array := (others => x"00000000"); -- assign all 0
    
begin
    process(clk)
    begin
        if rising_edge(clk) then -- Data written out or to registers
            RD1 <= "000000000000000000000000000" & RR1 ; --assign the read data like this because mux8x8 only takes the last 8 bits 
            RD2 <= "000000000000000000000000000" & RR2 ; 
            
            if RegWrite ='1' then
                reg_file(to_integer(unsigned(WR))) <= WD;
					 
            end if;
        end if;
    end process;

end Behavioral;
