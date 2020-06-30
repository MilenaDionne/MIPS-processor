library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HazardDetectionUnit is
	port (
	IdExMemRead                :in std_logic;
	IdExRt,IfIdRs,IfIdRt       :in std_logic_vector(4 downto 0);
	IfIdWrite,PCwrite,CtrMuxSel:out std_logic:='0'
);
end entity;

architecture stallingLogic of HazardDetectionUnit is
	signal RtEqRsIfId,RtEqRtIfId: std_logic;
	signal RtRs,RtRt:std_logic_vector(4 downto 0);

begin
------inside logic
	XNOR1:for i in 0 to 4 generate
		RtRs(i)<=IdExRt(i) xnor IfIdRs(i);
	end generate XNOR1;
	
	XOR2:for j in 0 to 4 generate
		RtRt(j)<=IdExRt(j) xnor IfIdRt(j);
	end generate XOR2;
	
	RtEqRsIfId<=RtRs(0) and RtRs(1) and RtRs(2) and RtRs(3) and RtRs(4);
	RtEqRtIfId<=RtRt(0) and RtRt(1) and RtRt(2) and RtRt(3) and RtRt(4);
	
	------Generate output
	IfIdWrite<=(RtEqRsIfId or RtEqRtIfId) and IdExMemRead;
	PCwrite  <=(RtEqRsIfId or RtEqRtIfId) and IdExMemRead;
	CtrMuxSel<=((not RtEqRsIfId) or not(RtEqRtIfId)) and (not IdExMemRead);
	
end architecture stallingLogic;
