library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlUnit is
	port (
	Opcode : in std_logic_vector(5 downto 0);
	BEQTaken: in std_logic;
 
   RegDst, Jump, MemRead, MemToReg : buffer std_logic;
	MemWrite, ALUSrc: buffer std_logic;
	ALUOp: buffer std_logic_vector(1 downto 0); 
	
	--output added for pipeline 
   Flush  : out std_logic:='0';
	EX     : out std_logic_vector(3 downto 0);
	M      : out std_logic_vector(2 downto 0);
	WB     : out std_logic_vector(1 downto 0)
);
end entity;

architecture ctrLogic of controlUnit is
	signal R_format,lw,sw,b_eq,b_ne, jp, BEQ, bne, RegWrite:std_logic;
	
begin
   R_format<= (not Opcode(5)) and (not Opcode(4)) and (not Opcode(3)) and (not Opcode(2)) and (not Opcode(1)) and (not Opcode(0));
	lw      <= Opcode(5) and (not Opcode(4)) and (not Opcode(3)) and (not Opcode(2)) and Opcode(1) and Opcode(0);
	sw      <= Opcode(5) and (not Opcode(4)) and Opcode(3) and (not Opcode(2)) and Opcode(1) and Opcode(0);
	b_eq    <= (not Opcode(5)) and (not Opcode(4)) and (not Opcode(3)) and Opcode(2) and (not Opcode(1)) and (not Opcode(0));
	b_ne    <= (not Opcode(5)) and (not Opcode(4)) and (not Opcode(3)) and Opcode(2) and (not Opcode(1)) and Opcode(0);	
	jp      <= (not Opcode(5)) and (not Opcode(4)) and (not Opcode(3))and (not Opcode(2)) and Opcode(1) and not(Opcode(0));
	
	RegDst  <= R_format;
	ALUSrc  <= lw or sw;
	MemToReg<=lw;
	RegWrite<=R_format or lw;
	MemRead <=lw;
	MemWrite<= NOT sw;
	BEQ  <=b_eq;
	ALUOp(1)<=R_format;
	ALUOp(0)<=b_eq or b_ne;
	Jump <= jp; 
	
	------Adding block for each stage of pipeline
	------EX/Address calculation stage
   EX(3)<=RegDst;
   EX(2 downto 1)<=ALUOp(1 downto 0);
   EX(0)<=ALUSrc;	
	------M stage
	M(2)<=BEQ;
	M(1)<=MemRead;
	M(0)<=MemWrite;
	------WB stage
	WB(1)<=RegWrite;
	WB(0)<=MemToReg;
   ------Flush Signal;
   Flush<=BEQTaken;
end architecture ctrLogic;

