-- DE0_CV_golden

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DE0_CV_golden is 

	port( 
		
		CLOCK_50		: in std_logic;
		KEY			: in std_logic_vector(0 downto 0);
		
		VGA_B			: out std_logic_vector(3 downto 0);
		VGA_G			: out std_logic_vector(3 downto 0);
		VGA_HS		: out std_logic;
		VGA_R 		: out std_logic_vector(3 downto 0);
		VGA_VS		: out std_logic
		
	);
end DE0_CV_golden;

architecture rtl of DE0_CV_golden is 
	constant H_PIXEL 			: integer := 640;
	constant V_PIXEL			: integer := 480;
	
	signal clk_gate 			: std_logic;
	signal ctrl_area			: std_logic;
	signal row_position 		: unsigned(10 downto 0); 
	signal column_position 	: unsigned(10 downto 0); 
	

begin 

	cg : entity work.clk_gate_25 
	port map
	(
		clk 		=> CLOCK_50,
		clk_gate => clk_gate
	);

	VGA_c : entity work.VGA_controller_2
	port map
	(
		clk 					=> CLOCK_50,
		clk_gate				=> clk_gate,
		reset					=> KEY(0),
		
		row_position 		=> row_position,
		column_position 	=> column_position,
		h_sync 				=> VGA_HS,
		v_sync 				=> VGA_VS,
		ctrl_area			=> ctrl_area
	);
	
	p_data_gen_test : process(ctrl_area) is 
	begin 
		if(ctrl_area = '1') then 
			if (row_position < V_PIXEL/2) then
				VGA_R <= "1111";
				VGA_G <= "1111";
				VGA_B <= "1111";
					
			else 
				VGA_R <= "1111";
				VGA_G <= "0000";
				VGA_B <= "0000";
			end if;
		
		else 
				VGA_R <= "0000";
				VGA_G <= "0000";
				VGA_B <= "0000";
		end if;
	end process p_data_gen_test;

end rtl;
	
	