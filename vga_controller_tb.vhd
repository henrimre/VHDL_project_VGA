-- tb_vga_controller_2

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_vga_controller_2 is 
end tb_vga_controller_2; 

architecture tb of tb_vga_controller_2 is 
	
	signal clk_gate			: std_logic := '0';
	signal clk 					: std_logic := '0';
	
	signal row_position		: unsigned (10 downto 0) := (others => '0'); 	-- sortie de la position verticale 
	signal column_position	: unsigned (11 downto 0) := (others => '0');	-- sortie de la position horizontale
	signal h_sync				: std_logic := '0';	-- signal de sortie H_SYNC du VGA
	signal v_sync				: std_logic := '0';	-- signal de sortie V_SYNC du VGA
	signal ctrl_area			: std_logic := '1'; 	-- signal de sortie commandant le multiplexer pour l'affichage des couleurs

begin
	
	UUT : entity work.vga_controller_2 port map(clk => clk, clk_gate => clk_gate,	row_position => row_position,	column_position => column_position, h_sync => h_sync,	v_sync => v_sync,	ctrl_area => ctrl_area);
	
	p_stimuli_clk : process
	begin 
		clk <= '0';
		wait for	20 ns/2;
		clk <= '1';
		wait for 20 ns/2;
	end process p_stimuli_clk;
	
	p_stimuli_clk_gate : process
	begin 
		clk_gate <= '0';
		wait for 40 ns/2;
		clk_gate <= '1';
		wait for 40 ns/2;
	end process p_stimuli_clk_gate;

end tb;