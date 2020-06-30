library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ForwardingUnit is
	port (
		IdExrs,IdExrt  : in std_logic_vector(4 downto 0);
		ExMemRegisterRd: in std_logic_vector(4 downto 0);
		ExMemRegWrite  : in std_logic;
		MemWbRegWrite  : in std_logic;
		MemWbRegisterRd: in std_logic_vector(4 downto 0);
		ForwardA       : out std_logic_vector(1 downto 0):="00";
		ForwardB       : out std_logic_vector(1 downto 0):="00"
);

end entity;


architecture forwardLogic of ForwardingUnit is
	signal RdEqRtExMem,RdEqRsExMem: std_logic;
	signal RdEqRtMemWb,RdEqRsMemWb: std_logic;
	signal ExMemRdRs,ExMemRdRt,MemWbRdRs,MemWbRdRt:std_logic_vector(4 downto 0);
	signal ExMemRd,MemWbRd:std_logic;
begin
------inside logic
	--XNOR1:for i in 0 to 4 generate
	--	ExMemRdRs(i)<=IdExrs(i) xnor ExMemRegisterRd(i);
	--end generate XNOR1;
	
	--XOR2:for j in 0 to 4 generate
		--ExMemRdRt(j)<=IdExrt(j) xnor ExMemRegisterRd(j);
	--end generate XOR2;
	
	--XOR3:for k in 0 to 4 generate
		--MemWbRdRs(k)<=IdExrs(k) xnor MemWbRegisterRd(k);
	--end generate XOR3;
	
	--XOR4:for h in 0 to 4 generate
		--MemWbRdRt(h)<=IdExrt(h) xnor MemWbRegisterRd(h);
	--end generate XOR4;
	
	--RdEqRsExMem<=ExMemRdRs(0) and ExMemRdRs(1) and ExMemRdRs(2) and ExMemRdRs(3) and ExMemRdRs(4);
	--RdEqRsMemWb<=MemWbRdRs(0) and MemWbRdRs(1) and MemWbRdRs(2) and MemWbRdRs(3) and MemWbRdRs(4);
	--RdEqRtExMem<=ExMemRdRt(0) and ExMemRdRt(1) and ExMemRdRt(2) and ExMemRdRt(3) and ExMemRdRt(4);
	--RdEqRtMemWb<=MemWbRdRt(0) and MemWbRdRt(1) and MemWbRdRt(2) and MemWbRdRt(3) and MemWbRdRt(4);
	
	------Test Rd=0 or not, Rd=0 then output=1
	--ExMemRd<=(not ExMemRegisterRd(4))and (not ExMemRegisterRd(3)) and (not ExMemRegisterRd(2)) and (not ExMemRegisterRd(1)) and (not ExMemRegisterRd(0));
	--MemWbRd<=(not MemWbRegisterRd(4))and (not MemWbRegisterRd(3)) and (not MemWbRegisterRd(2)) and (not MemWbRegisterRd(1)) and (not MemWbRegisterRd(0));
	
	------Generate output
	ForwardA(1)<= (IDExrs(0) AND EXMemRegWrite and EXMemRegisterRd(0)) or (IDExrs(1) AND EXMemRegWrite and EXMemRegisterRd(1)) or (IDExrs(2) AND EXMemRegWrite and EXMemRegisterRd(2)) or (IDExrs(3) AND EXMemRegWrite and EXMemRegisterRd(3)) or (IDExrs(4) AND EXMemRegWrite and EXMemRegisterRd(4)); 
	ForwardA(0)<= (IDExrs(0) and not EXMemRegWrite and MEMWbRegWrite and MEMWbRegisterRd(0)) or (IDExrs(1) and not EXMemRegWrite and MEMWbRegWrite and MEMWbRegisterRd(1)) or (IDExrs(2) and not EXMemRegWrite and MEMWbRegWrite and MEMWbRegisterRd(2)) or (IDExrs(3) and not EXMemRegWrite and MEMWbRegWrite and MEMWbRegisterRd(3)) or (IDExrs(4) and not EXMemRegWrite and MEMWbRegWrite and MEMWbRegisterRd(4)); 
	ForwardB(1)<= (IDExrt(0) AND EXMemRegWrite and EXMemRegisterRd(0)) or (IDExrt(1) AND EXMemRegWrite and EXMemRegisterRd(1)) or (IDExrt(2) AND EXMemRegWrite and EXMemRegisterRd(2)) or (IDExrt(3) AND EXMemRegWrite and EXMemRegisterRd(3)) or (IDExrt(4) AND EXMemRegWrite and EXMemRegisterRd(4)); 
	ForwardB(0)<= (IDExrt(0) and not EXMemRegWrite and MEMWbRegWrite and MEMWbRegisterRd(0)) or (IDExrt(1) and not EXMemRegWrite and MEMWbRegWrite and MEMWbRegisterRd(1)) or (IDExrt(2) and not EXMemRegWrite and MEMWbRegWrite and MEMWbRegisterRd(2)) or (IDExrt(3) and not EXMemRegWrite and MEMWbRegWrite and MEMWbRegisterRd(3)) or (IDExrt(4) and not EXMemRegWrite and MEMWbRegWrite and MEMWbRegisterRd(4));  
end architecture forwardLogic;
