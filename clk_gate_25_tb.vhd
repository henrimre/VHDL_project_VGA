--clk_gate_25_tb

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_gate_25_tb is 
end clk_gate_25_tb;

architecture tb of clk_gate_25_tb is 

	signal clk			: std_logic :='0';
	signal clk_gate 	: std_logic :='0';
	--signal count_out	: std_logic_vector (2 downto 0);

begin 
	UUT : entity work.clk_gate_25 port map(
		clk 			=> clk, 
		--count_out 	=> count_out,
		clk_gate 	=> clk_gate);
		
p_stimuli_clk : process 
	begin 
		clk <= '0';
		wait for 20 ns/2;
		clk <= '1';
		wait for 20 ns/2;
	end process p_stimuli_clk;
	
end tb;