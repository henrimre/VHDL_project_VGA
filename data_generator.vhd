--data generator

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity image_generator is 
	
	generic(
		H_PIXEL	: integer := 640;
		V_PIXEL	: integer := 480
	);
	
	port(
	clk					: in std_logic;
	ctrl_area			: in std_logic;
	row_position 		: in unsigned(10 downto 0);
	column_position	: in unsigned(10 downto 0);
	data_value			: in std_logic_vector(4 downto 0);
	
	VGA_R					: out std_logic_vector(3 downto 0);
	VGA_G					: out std_logic_vector(3 downto 0);
	VGA_B					: out std_logic_vector(3 downto 0)
	);
end image_generator;
	
architecture arch_image_generator of image_generator is
	constant SMALL_VAL		: integer := 1;
	constant BIG_VAL			: integer := 10;
	constant MAX_VAL			: integer := 16;
		
	signal data_value_trans : std_logic_vector (4 downto 0);
	signal red_val_cur_1		: unsigned (3 downto 0) := "0100"; --valeur pour partie 1 de l'écran
	signal red_val_next_1	: unsigned (3 downto 0) := "0100";
	signal red_val_cur_2		: unsigned (3 downto 0) := "0100"; --valeur pour partie 2 de l'écran
	signal red_val_next_2	: unsigned (3 downto 0) := "0100";
	signal red_val_temp_cur	: unsigned (3 downto 0) := "0100";
	signal red_val_temp_next: unsigned (3 downto 0) := "0100";
	
	signal blue_val_cur_1	: unsigned (3 downto 0) := "0100";
	signal blue_val_next_1	: unsigned (3 downto 0) := "0100";
	signal blue_val_cur_2	: unsigned (3 downto 0) := "0100";
	signal blue_val_next_2	: unsigned (3 downto 0) := "0100";
	
	signal green_val_cur_1	: unsigned (3 downto 0) := "0100";
	signal green_val_next_1	: unsigned (3 downto 0) := "0100";
	signal green_val_cur_2	: unsigned (3 downto 0) := "0100";
	signal green_val_next_2	: unsigned (3 downto 0) := "0100";
	
	begin 
	
	p_data_gen_comb : process (ctrl_area, row_position, column_position, data_value) is
	begin 
		
		if (ctrl_area = '1') then
			if ((data_value and "10000") = "10000") then --on est dans état 3 : séparation de l'écran en 2
				if (column_position < H_PIXEL/2) then
					VGA_R <= std_logic_vector(red_val_cur_1);
					
				else 
					VGA_R <= std_logic_vector(red_val_cur_2);
				
				end if;

			else 
				VGA_R <= std_logic_vector(red_val_cur_1);
				--VGA_G 
				--VGA_B 
				
			end if;
		end if;
	end process p_data_gen_comb;
	
	p_red_data_val : process(data_value) is
	begin 
		if ((data_value and "10000") = "10000") then -- on est dans état 3 séparation des couleurs 
			red_val_temp_cur <= red_val_cur_2;
		else red_val_temp_cur <= red_val_cur_1;
		end if;
		
		data_value_trans <= data_value and "01111";
		
		if (data_value_trans = "00001" and red_val_cur_1 < "1111") then
			red_val_temp_next <= red_val_temp_cur + SMALL_VAL;
			
		elsif (data_value_trans = "00010" and red_val_cur_1< "1111") then 
		
			if (red_val_temp_cur > MAX_VAL - BIG_VAL) then
				red_val_temp_next <= "1111";
			else red_val_temp_next <= red_val_temp_cur + BIG_VAL;
			end if;
		
		elsif (data_value_trans = "00011" and red_val_cur_1 > "0000")then
			red_val_temp_next <= red_val_temp_cur - SMALL_VAL;
		
		elsif (data_value_trans = "00100" and red_val_temp_cur > "0000") then
			
			if (red_val_temp_cur < "0000" + BIG_VAL) then
				red_val_temp_next <= "0000";
			else red_val_temp_next <= red_val_temp_cur - BIG_VAL; 
			end if;
			
		end if;
		
		if ((data_value and "10000") = "10000") then 
			red_val_next_2 <= red_val_temp_next;
		else red_val_next_1 <= red_val_temp_next;
		end if;
		
	end process p_red_data_val;
			
	p_data_gen_seq : process(clk) is
	begin
		if (rising_edge(clk)) then
			red_val_cur_1 <= red_val_next_1;
			blue_val_cur_1 <= blue_val_next_1;
			green_val_cur_1 <= green_val_next_1;				
		end if;
		
	end process p_data_gen_seq;
	
end arch_image_generator;