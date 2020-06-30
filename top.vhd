library ieee; 
use ieee.std_logic_1164.all; 

library work;
use work.all;

entity top is 
	port (
		GClock: in std_logic; 
		GReset: in std_logic; 
		ValueSelect: in std_logic_vector(2 downto 0); 
		InstrSelect: in std_logic_vector(2 downto 0); 
		MuxOut: out std_logic_vector(7 downto 0); 
		InstructionOut: out std_logic_vector(31 downto 0); 
		BranchOut: out std_logic; 
		ZeroOut: out std_logic; 
		MemWriteOut: out std_logic; 
		RegWriteOut: out std_logic); 
end top; 

ARCHITECTURE arch of top is 

component PC is 
port(
  clk    : in STD_LOGIC;
  rst    : in STD_LOGIC;
  PC_in  : in STD_LOGIC_VECTOR (31 downto 0);
  PC_out : out STD_LOGIC_VECTOR (31 downto 0);
  stall : in std_logic); --control signal from Hazard Detection 
end component;

component PC_adder --updated
	
	generic(g_next_instr : std_logic_vector(31 downto 0) := "00000000000000000000000000000100";
		g_carry_in : std_logic := '0');	
		
	port (
		CarryIn : in std_logic := g_carry_in; 
		aluIn1 : in std_logic_vector(31 downto 0);
		aluOut : out std_logic_vector(31 downto 0);
		carryOut : out std_logic
	);
end component;

component IFID is
	port (
		pc4In, instructionIn : in std_logic_vector(31 downto 0);
		pc4Out, instructionOut : out std_logic_vector(31 downto 0);
		hzdCtrl : in std_logic;
		clk, rst : in std_logic
	);
end component;

component top_mux32x8 is
	
	port(PC, ALUresult, readData1, readData2, writeData, other, i6, i7: in std_logic_vector(31 downto 0); -- i6 and i7 not used
		sel :in std_logic_vector(2 downto 0);
		muxOut: out std_logic_vector(7 downto 0));
		
end component;

component instructionMemory is
	port (
		address		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;

component controlUnit is
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
end component;

component comparator is
port(
     RegData1,RegData2:in std_logic_vector(31 downto 0);
     equal:out std_logic
);
end component;

component BranchMuxCtrl is
port (
	Equal,Branch : in std_logic;
	muxSel: out std_logic
	
);
end component;

component adder32bit is
	
generic(g_carry_in : std_logic := '0');	
port (
	CarryIn : in std_logic := g_carry_in;
	aluIn1, aluIn2 : in std_logic_vector(31 downto 0);
	aluOut : out std_logic_vector(31 downto 0);
	carryOut : out std_logic
);
end component;

component signExtend is
	port (
		seIn : in std_logic_vector(15 downto 0);
		seOut : out std_logic_vector(31 downto 0)
	);
end component;

component shiftLeft2 is
	-- im thinking this one discards the msb ends 
	-- and the jump one doesnt, just adds 00
port (
	slIn : in std_logic_vector(31 downto 0);
	slOut : out std_logic_vector(31 downto 0) 
);
end component;

component PC_mux is
	port(
		sel : in std_logic;
		a, b : in std_logic_vector(31 downto 0);
		z : out std_logic_vector(31 downto 0)
	);
end component;

component stallMux is
port (
		sel : in std_logic;
		a, b : in std_logic_vector(8 downto 0);
		z : out std_logic_vector(8 downto 0)
	);
end component;

component HazardDetectionUnit is
	port (
	IdExMemRead                :in std_logic;
	IdExRt,IfIdRs,IfIdRt       :in std_logic_vector(4 downto 0);
	IfIdWrite,PCwrite,CtrMuxSel:out std_logic:='0'
);
end component;

component registerfile is 
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
end component; 

component IDEX is
	port (
		readData1In, readData2In, signExtendIn : in std_logic_vector(31 downto 0);
		readData1Out, readData2Out, signExtendOut : out std_logic_vector(31 downto 0);
		
		-- control signals
		WbIn : in std_logic_vector(1 downto 0);
		MemIn : in std_logic_vector(2 downto 0);
		ExIn : in std_logic_vector(3 downto 0);
		
		WBOut : out std_logic_vector(1 downto 0);
		MemOut : out std_logic_vector(2 downto 0);
		ExOut : out std_logic_vector(3 downto 0);
		
		-- rs, rt, rd
		rsIn, rtIn1, rtIn2, rdIn : in std_logic_vector(4 downto 0);
		rsOut, rtOut1, rtOut2, rdOut : out std_logic_vector(4 downto 0);
		
		stall : in std_logic;
		
		-- clock&reset
		clk, rst : in std_logic
	);
end component;

component aluControl is
port (
	aluOpIn : in std_logic_vector(1 downto 0);
	functionBits : in std_logic_vector(5 downto 0);
	aluOpOut : out std_logic_vector(2 downto 0)
	
);
end component;

component ForwardingUnit is
	port (
		IdExrs,IdExrt  : in std_logic_vector(4 downto 0);
		ExMemRegisterRd: in std_logic_vector(4 downto 0);
		ExMemRegWrite  : in std_logic;
		MemWbRegWrite  : in std_logic;
		MemWbRegisterRd: in std_logic_vector(4 downto 0);
		ForwardA       : out std_logic_vector(1 downto 0):="00";
		ForwardB       : out std_logic_vector(1 downto 0):="00"
);

end component;

component mux5x2 is
port (
		sel : in std_logic;
		a, b : in std_logic_vector(4 downto 0);
		z : out std_logic_vector(4 downto 0)
	);
end component;

component mux32x4 is
	port(
		sel :in std_logic_vector(1 downto 0); 
		logicAND, logicOR, add_sub: in std_logic_vector(31 downto 0);
		z: out std_logic_vector(31 downto 0)
	);
end component;

component ALUMain is
	
port (
	aluOP : in std_logic_vector(2 downto 0); --Most significant bit of aluOP (aluOP(2)) will determine Cin for add/sub operation. Cin=1 for sub
	aluIn1, aluIn2 : in std_logic_vector(31 downto 0);
	aluOut : out std_logic_vector(31 downto 0); -- for a 256x8 data mem, output will be sliced to 8 bits
	CarryOut : out std_logic;
	ovrFlw : out std_logic;
	zero : out std_logic
);
end component;

component EXMEM is
	port (
		aluResIn, muxIn1 : in std_logic_vector(31 downto 0);
		muxIn2 : in std_logic_vector(4 downto 0);
		aluResOut, muxOut1 : out std_logic_vector(31 downto 0);
		muxOut2 : out std_logic_vector(4 downto 0);
		
		-- control signals
		WBIn : in std_logic_vector(1 downto 0);
		MemIn : in std_logic_vector(2 downto 0);
		WBOut : out std_logic_vector(1 downto 0);
		MemOut : out std_logic_vector(2 downto 0);
		
		stall : in std_logic;
		
		-- clock&reset
		clk, rst : in std_logic
	);
	
end component;

component dataMemory is
	port (
		address		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;

component MEMWB is
	port (
		readDataIn, aluResIn: in std_logic_vector(31 downto 0);
		muxIn2 : in std_logic_vector(4 downto 0);
		readDataOut, aluResOut: out std_logic_vector(31 downto 0);
		muxOut2 : out std_logic_vector(4 downto 0);
		
		-- control signals
		WBIn : in std_logic_vector(1 downto 0);
		WBOut : out std_logic_vector(1 downto 0);
		
		stall : in std_logic;
		
		-- clock&reset
		clk, rst : in std_logic
	);
end component;

component mux32 is
	port(
		sel : in std_logic;
		a, b : in std_logic_vector(31 downto 0);
		z : out std_logic_vector(31 downto 0)
	);
end component;

signal MuxOutBranch, PCOut, nextPC, InstMemOut, PCadd, IdInstMemOut: std_logic_vector(31 downto 0); 
signal stall, IFIDWrite, Flush, PCWrite: std_logic:='0'; 
signal carryPC, BranchCarry, carryOut, overflow, unUsedZero: std_logic; 
signal outmux: std_logic_vector(7 downto 0); 
signal addRom, addRam: std_logic_vector(7 downto 0);
signal BranchMuxSelOut: std_logic;
signal WB: std_logic_vector(1 downto 0); 
signal EX: std_logic_vector(3 downto 0); 
signal M: std_logic_vector(2 downto 0);   
signal data1, data2, dataMemOut, dataMuxOut, aluAin, aluBin, Aluout, other: std_logic_vector(31 downto 0); 
signal RegDst, Jump, BEQ,BNE, MemRead, MemToReg,MemWrite, ALUSrc, RegWrite, zero: std_logic;
signal slsignExt, BranchALURes: std_logic_vector(31 downto 0); 
signal signExtOut: std_logic_vector(31 downto 0); 
signal ControlMux: std_logic; 
signal ControlLogic, StallMuxOut: std_LOGIC_VECTOR(8 downto 0); 
signal IDEXMemRead, writeCtl, StallForIDEX: std_logic; 
signal IDEXRt: std_logic_vector(4 downto 0); 
signal WR: std_logic_vector(4 downto 0); 
signal IDEXData1, IDEXData2, IDEXsignExtOut: std_logic_vector(31 downto 0); 
signal IDEXStallMuxOut: std_logic_vector(8 downto 0); 
signal rsOut, rtOut1, rtOut2, rdOut: std_logic_vector(4 downto 0); 
signal ALUop: std_logic_vector(1 downto 0); 
signal alupout: std_logic_vector(2 downto 0); 
signal EXMEMRegMuxOut, ExMemStallOut, MemWBRegMuxOut, RegDstOut: std_logic_vector(4 downto 0); 
signal MemWBStallOut, ForwardA, ForwardB: std_logic_vector(1 downto 0); 
signal MemWBOut, EXMemAluRes, EXMEMAluOut, EXMEMdata2, MEMWBdataOut, MEMWBALuOut: std_logic_vector(31 downto 0); 


begin 

	StallForIDEX <= not ControlMux; 
	RegWrite <= MemWBStallOut(1); 
	
	-- Stage IF -> Fetch instruction from memory 
	PCreg: PC port map (GClock, GReset, MuxOutBranch, PCOut, PCWrite); 
	PCMux: PC_mux port map(beq and zero, BranchALURes, nextPC, MuxOutBranch); 
	PCadder: PC_adder port map ('0', PCOut, nextPC, carryPC) ; 
	InsMem: instructionMemory port map(PCout, GClock, InstMemOut); 
	IFIDPipe: IFID port map(nextPC, InstMemOut, PCadd, IdInstMemOut, IFIDWrite, GClock, Flush);
	
	--Stage ID -> Read regsiiters while decoding the instruction 
	control: controlUnit port map(IdInstMemOut(31 downto 26), BranchMuxSelOut, RegDst, Jump, MemRead, MemToReg, MemWrite, ALUSrc, ALUop, Flush, EX, M, WB); 
	BranchComp:comparator port map(data1,data2,zero);
	BranchMux: BranchMuxCtrl port map(zero,BEQ, BranchMuxSelOut); 
	BranchALU: adder32bit port map('0', Pcadd, slsignExt, BranchALURes, BranchCarry); 
	sftL2: shiftLeft2 port map(signExtOut, slsignExt); 
	signEx: signExtend port map(IdInstMemOut(15 downto 0), signExtOut); 
	stallmultiplexor: stallMux port map(ControlMux, ControlLogic, "000000000", StallMuxOut);

	ControlLogic(8 downto 7)<= WB; 
	ControlLogic(6 downto 4) <= M; 
	ControlLogic(3 downto 0) <= EX; 
	--IDEXMemRead <= MemRead; 
	HazardUnit: HazardDetectionUnit port map(IDEXMemRead, rtOut2, IdInstMemOut(25 downto 21), IdInstMemOut(20 downto 16), IFIDWrite, PCWrite, ControlMux); 
	regFile: registerfile port map(IdInstMemOut(25 downto 21), IdInstMemOut(20 downto 16), EXMEMRegMuxOut, dataMuxOut, GClock, writeCtl, data1, data2);
	
	writeCtl <= not RegWrite; 
	IDEXPipeline:IDEX port map (data1, data2, signExtOut, IDEXdata1, IDEXdata2, IDEXsignExtOut, 
	StallMuxOut(8 downto 7), StallMuxOut(6 downto 4), StallMuxOut(3 downto 0), IDEXStallMuxOut(8 downto 7), IDEXStallMuxOut(6 downto 4), IDEXStallMuxOut(3 downto 0), 
	InstMemOut(25 downto 21), InstMemOut(20 downto 16), InstMemOut(20 downto 16),InstMemOut(15 downto 11), rsOut, rtOut1, rtOut2, rdOut,StallForIdEx,GClock,GReset);
	
	--Stage EX 
	aluctrl: aluControl port map(ALUop, IDEXSignExtOut(5 DOWNTO 0), alupout); 
	mainALU: aluMain port map(alupout,AluAin,AluBin,Aluout,carryOut,overflow,UnUsedZero);
	ForwUnit:ForwardingUnit port map(rsOut, rtOut1, EXMEMRegMuxOut,EXMemStallOut(4),MEMWBStallOut(1),MEMWBRegMuxOut,ForwardA,ForwardB);
	RegMux: mux5x2 port map (RegDst, rtOut2, rdOut, RegDstOut); 
	ForwardingMux1: mux32x4 port map(ForwardA,IDEXdata1,dataMuxOut,ExMemAluOut,AluAin); 
	ForwardingMux2: mux32x4 port map(ForwardB,IDEXdata2,dataMuxOut,ExMemAluOut,AluBin);
	EXMEMpipe:EXMEM port map(Aluout,IdeXData2, RegDstOut,EXMEMAluOut,ExMEMdata2,EXMEMRegMuxOut,IDEXStallMuxOut(8 downto 7),IDEXStallMuxOut(6 downto 4),EXMemStallOut(4 downto 3),EXMemStallOut(2 downto 0), StallForIdex,GClock,GReset);
	
	--stage MEM 
	DataMem: dataMemory port map(ExMemAluOut, GClock,IdeXData2,EXMemStallOut(0), dataMemOut); 
	MEMWBpiepline: MEMWB PORT MAP(dataMemOut,EXMEMAluOut,EXMEMRegMuxOut,MEMWBdataOut,MEMWBaluOut,MEMWBRegMuxOut,EXMemStallOut(4 downto 3),MEMWBStallOut(1 downto 0),StallForIdEx,GClock,GReset); 
	muxMEMWBOut: mux32 port map(MEMWBStallOut(0),MEMWBdataOut,MEMWBaluOut,dataMuxOut); 
	
	
	outputMux: top_mux32x8 port map(PCadd, ALUAin, IdExData1, idexdata2, dataMuxOut, other, other, other, ValueSelect, outmux);
--001: EXMEMAluOut	
	other(0)<= zero; 
	other(1) <= regDst; 
	other(2)<= jump; 
	other(3) <= MemRead; 
	other(4)<= MEMToReg; 
	other(6 downto 5) <= aluOP; 
	other(7)<= aluSrc; 
	
	MuxOut <= outmux; 
	InstructionOut <= InstMemOut; 
	RegWriteOut <= RegWrite; 
	MemWriteOut <= MemWrite; 
	ZeroOut <= zero; 
	BranchOut <= BranchMuxSelOut; 
	
end arch; 

