-- data_generator_tb

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_generator_tb is 
end data_generator_tb;

architecture tb of data_generator_tb is 

	signal clk 					: std_logic := '0';
	signal ctrl_area 			: std_logic := '1';
	
	signal row_position		: unsigned(10 downto 0) := (others => '0');
	signal column_position	: unsigned(10 downto 0) := (others => '0');
	signal data_value			: std_logic_vector (4 downto 0);
	signal VGA_R				: std_logic_vector(3 downto 0);
	signal VGA_G				: std_logic_vector(3 downto 0);
	signal VGA_B				: std_logic_vector(3 downto 0);
begin 
	UUT : entity work.image_generator port map(
	clk => clk, 
	ctrl_area => ctrl_area,	
	row_position => row_position,	
	column_position => column_position, 
	data_value => data_value, 
	VGA_R => VGA_R, 
	VGA_G => VGA_G, 
	VGA_B => VGA_B);
	
	p_stimuli_clk : process
	begin 
		clk <= '0';
		wait for	20 ns/2;
		clk <= '1';
		wait for 20 ns/2;
	end process p_stimuli_clk;
		


end tb;