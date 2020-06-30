library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BranchMuxCtrl is
port (
	Equal,Branch : in std_logic;
	muxSel: out std_logic
	
);
end entity;

architecture logic of BranchMuxCtrl is
	signal branchE,branchNE: std_logic; 
	
begin
	muxSel    <= Branch and Equal;
end architecture logic;