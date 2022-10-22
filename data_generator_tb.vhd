-- data_generator_tb

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_generator_tb is 
end data_generator_tb;

architecture tb of data_generator_tb is 

	signal clk 					: std_logic := '1';
	signal ctrl_area 			: std_logic := '1';
	
	signal row_position		: unsigned(10 downto 0) := (others => '0');
	signal column_position	: unsigned(10 downto 0) := (others => '0');
	signal data_value			: std_logic_vector (4 downto 0) := (others => '0');
	
	--signal test					: std_logic := '0';
	signal VGA_R				: std_logic_vector(3 downto 0);
	signal VGA_G				: std_logic_vector(3 downto 0);
	signal VGA_B				: std_logic_vector(3 downto 0);
	constant H_PIXEL_TEST	: integer := 300;
begin 
	
	UUT : entity work.data_generator port map(
	clk => clk, 
	ctrl_area => ctrl_area,	
	row_position => row_position,	
	column_position => column_position, 
	data_value => data_value, 
	--test => test,
	VGA_R => VGA_R,
	VGA_G => VGA_G,
	VGA_B => VGA_B
	);
	
	column_position <= to_unsigned(H_PIXEL_TEST, 11);
	
	p_assert_data_value : process 
	begin 
		wait for 1.5 us; 
		assert VGA_G = "0000" report "VGA_G problem";
		wait;
	
	end process p_assert_data_value;
	
	p_stimuli_data_value_1 : process -- test de l'incrémentation et de la décrémentation des valeurs vertes. 
	begin
		wait for 20 ns;
		data_value <= "00101";
		wait for 20 ns;
		data_value <= "00000";
		wait for 0.2 us; 
		data_value <= "00110";
		wait for 20 ns; 
		data_value <= "00000";
		wait for 0.2 us; 
		data_value <= "00111";
		wait for 20 ns; 
		data_value <= "00000";
		wait for 0.2 us; 
		data_value <= "11111";
		wait for 20 ns; 
		data_value <= "00000";
		wait;
		
	end process p_stimuli_data_value_1;
	
	-- p_stimuli_data_value_2 : process -- test de l'incrémentation et de la décrémentation des valeurs rouges. 
	-- begin
		-- wait for 20 ns;
		-- data_value <= "00001";
		-- wait for 20 ns;
		-- data_value <= "00000";
		-- wait for 0.2 us; 
		-- data_value <= "00010";
		-- wait for 20 ns; 
		-- data_value <= "00000";
		-- wait for 0.2 us; 
		-- data_value <= "00011";
		-- wait for 20 ns; 
		-- data_value <= "00000";
		-- wait for 0.2 us; 
		-- data_value <= "11111";
		-- wait for 20 ns; 
		-- data_value <= "00000";
		-- wait;
		
	-- end process p_stimuli_data_value_2;
	
	-- p_stimuli_data_value_3 : process -- test de l'incrémentation et de la décrémentation des valeurs bleues. 
	-- begin
		-- wait for 20 ns;
		-- data_value <= "01001";
		-- wait for 20 ns;
		-- data_value <= "00000";
		-- wait for 0.2 us; 
		-- data_value <= "01010";
		-- wait for 20 ns; 
		-- data_value <= "00000";
		-- wait for 0.2 us; 
		-- data_value <= "01011";
		-- wait for 20 ns; 
		-- data_value <= "00000";
		-- wait for 0.2 us; 
		-- data_value <= "11111";
		-- wait for 20 ns; 
		-- data_value <= "00000";
		-- wait;
	-- end process p_stimuli_data_value_3;
	
	
	-- p_stimuli_data_value_3 : process 
	-- begin 
		-- wait for 20 ns; 
		-- data_value <= 
		
	-- end process p_stimuli_data_value_3
	
	p_stimuli_clk : process
	begin 
		clk <= '0';
		wait for	20 ns/2;
		clk <= '1';
		wait for 20 ns/2;
	end process p_stimuli_clk;



end tb;