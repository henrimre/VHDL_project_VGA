--data generator

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_generator is 
	
	generic(
		H_PIXEL	: integer := 640;
		V_PIXEL	: integer := 480
	);
	
	port(
	clk					: in std_logic;
	ctrl_area			: in std_logic;
	--row_position 		: in unsigned(10 downto 0);
	column_position	: in unsigned(10 downto 0);
	data_value			: in std_logic_vector(4 downto 0);
	
	--test					: out std_logic;
	VGA_R					: out std_logic_vector(3 downto 0);
	VGA_G					: out std_logic_vector(3 downto 0);
	VGA_B					: out std_logic_vector(3 downto 0)
	);
end data_generator;
	
architecture arch_data_generator of data_generator is
	constant SMALL_VAL		: integer := 1;
	constant BIG_VAL			: integer := 5;
	constant MAX_VAL			: integer := 15;
	
	signal separation_screen : std_logic_vector(2 downto 0); 
		-- 00 => pas de séparation
		-- 01 => séparation verticale 
		-- 10 => séparation horizontale

	signal red_data_value_trans 	: std_logic_vector (4 downto 0);
	signal red_val_cur_1				: unsigned (3 downto 0) := "0100"; --valeur pour partie 1 de l'écran
	signal red_val_next_1			: unsigned (3 downto 0) := "0100";
	signal red_val_cur_2				: unsigned (3 downto 0) := "0100"; --valeur pour partie 2 de l'écran
	signal red_val_next_2			: unsigned (3 downto 0) := "0100";
	signal red_val_temp_cur			: unsigned (3 downto 0) := "0100";
	signal red_val_temp_next		: unsigned (3 downto 0) := "0100";
	
	signal green_data_value_trans : std_logic_vector(4 downto 0);
	signal green_val_cur_1			: unsigned (3 downto 0) := "0100";
	signal green_val_next_1			: unsigned (3 downto 0) := "0100";
	signal green_val_cur_2			: unsigned (3 downto 0) := "0100";
	signal green_val_next_2			: unsigned (3 downto 0) := "0100";
	signal green_val_temp_cur		: unsigned (3 downto 0) := "0100";
	signal green_val_temp_next		: unsigned (3 downto 0) := "0100";
		
	signal blue_data_value_trans : std_logic_vector(4 downto 0);
	signal blue_val_cur_1			: unsigned (3 downto 0) := "0100";
	signal blue_val_next_1			: unsigned (3 downto 0) := "0100";
	signal blue_val_cur_2			: unsigned (3 downto 0) := "0100";
	signal blue_val_next_2			: unsigned (3 downto 0) := "0100";
	signal blue_val_temp_cur		: unsigned (3 downto 0) := "0100";
	signal blue_val_temp_next		: unsigned (3 downto 0) := "0100";
	
	begin 
	
	p_data_sep_screen : process (clk, data_value) is 
	begin 
		if(rising_edge(clk)) then
			if (data_value = "11101") then 	-- on passe à une séparation horizontale de l'écran
				separation_screen <= "01";
				
			elsif(data_value = "11110") then 
				separation_screen <= "10";
				
			elsif(data_value = "10000") then
				separation_screen <= "00";
				
			end if;
		end if;
	
	end process p_data_sep_screen;
	
	p_data_gen_comb : process (clk, ctrl_area, column_position, data_value, separation_screen) is
	begin 
		if(rising_edge(clk)) then 
			
			if (ctrl_area = '1') then
				--if ((data_value and "10000") = "10000") then -- on est dans état 3 : séparation de l'écran en 2
					
				if (separation_screen = "01") then --séparation horizontale de l'écran
					
					if (column_position < H_PIXEL/2) then
						VGA_R <= std_logic_vector(red_val_cur_1);
						VGA_G <= std_logic_vector(green_val_cur_1);
						VGA_B <= std_logic_vector(blue_val_cur_1);
					
					else 
						VGA_R <= std_logic_vector(red_val_cur_2);
						VGA_G <= std_logic_vector(green_val_cur_2);
						VGA_B <= std_logic_vector(blue_val_cur_2);
						
					end if;
				elsif (separation_screen = "10") then 
					if (row_position < V_PIXEL/2) then 
						VGA_R <= std_logic_vector(red_val_cur_1);
						VGA_G <= std_logic_vector(green_val_cur_1);
						VGA_B <= std_logic_vector(blue_val_cur_1);
					else 
						VGA_R <= std_logic_vector(red_val_cur_2);
						VGA_G <= std_logic_vector(green_val_cur_2);
						VGA_B <= std_logic_vector(blue_val_cur_2);
						
					end if;
				else 
					VGA_R <= std_logic_vector(red_val_cur_1);
					VGA_G <= std_logic_vector(green_val_cur_1);
					VGA_B <= std_logic_vector(blue_val_cur_1);
					end if;
					
				end if;
				
			else 
				VGA_R <= "0000";
				VGA_G <= "0000";
				VGA_B <= "0000";
			end if;
		end if;
	end process p_data_gen_comb;
	
	p_red_data_val : process(clk, data_value) is
	begin 
	
		if(rising_edge(clk)) then
			
			if(data_value = "00001" 
				or data_value = "00010"  
				or data_value = "00011" 
				or data_value = "00100"
				or data_value = "10001"
				or data_value = "10010"
				or data_value = "10011"
				or data_value = "10100") then
			
				if ((data_value and "10000") = "10000") then -- on est dans état 3 : séparation des couleurs 
					red_val_temp_cur <= red_val_cur_2; 
				else 
					red_val_temp_cur <= red_val_cur_1;
					
				end if;
				
				red_data_value_trans <= (data_value and "01111");
				
				if (red_data_value_trans = "00001" and red_val_temp_cur < "1111") then
					red_val_temp_next <= red_val_temp_cur + SMALL_VAL;
					
					
				elsif (red_data_value_trans = "00010" and red_val_temp_cur< "1111") then 
					
					if (red_val_temp_cur > MAX_VAL - BIG_VAL) then
						red_val_temp_next <= "1111";
					else red_val_temp_next <= red_val_temp_cur + BIG_VAL;
					end if;
				
				elsif (red_data_value_trans = "00011" and red_val_cur_1 > "0000")then
					red_val_temp_next <= red_val_temp_cur - SMALL_VAL;
				
				elsif (red_data_value_trans = "00100" and red_val_temp_cur > "0000") then
					
					if (red_val_temp_cur < "0000" + BIG_VAL) then
						red_val_temp_next <= "0000";
					else red_val_temp_next <= red_val_temp_cur - BIG_VAL; 
					end if;
					
				end if;
				
				if ((data_value and "10000") = "10000") then 
					red_val_next_2 <= red_val_temp_next;
				else red_val_next_1 <= red_val_temp_next;
				end if;
				
			elsif (data_value = "11111") then
				red_val_next_1 <= "1111";
				red_val_next_2 <= "1111";
			end if;
		end if;
	end process p_red_data_val;
		
	p_green_data_val : process(clk, data_value) is 
	begin
	
		if(rising_edge(clk)) then
			
			if(data_value = "00101" 
				or data_value = "00110"  
				or data_value = "00111" 
				or data_value = "01000"
				or data_value = "10101"
				or data_value = "10110"
				or data_value = "10111"
				or data_value = "11000") then
			
				if ((data_value and "10000") = "10000") then -- on est dans état 3 : séparation des couleurs 
					green_val_temp_cur <= green_val_cur_2; 
				else 
					green_val_temp_cur <= green_val_cur_1;
					
				end if;
				
				green_data_value_trans <= (data_value and "01111");
				
				if (green_data_value_trans = "00101" and green_val_temp_cur < "1111") then
					green_val_temp_next <= green_val_temp_cur + SMALL_VAL;
					
					
				elsif (green_data_value_trans = "00110" and green_val_temp_cur< "1111") then 
					
					if (green_val_temp_cur > MAX_VAL - BIG_VAL) then
						green_val_temp_next <= "1111";
					else green_val_temp_next <= green_val_temp_cur + BIG_VAL;
					end if;
				
				elsif (green_data_value_trans = "00111" and green_val_cur_1 > "0000")then
					green_val_temp_next <= green_val_temp_cur - SMALL_VAL;
				
				elsif (green_data_value_trans = "01000" and green_val_temp_cur > "0000") then
					
					if (green_val_temp_cur < "0000" + BIG_VAL) then
						green_val_temp_next <= "0000";
					else green_val_temp_next <= green_val_temp_cur - BIG_VAL; 
					end if;
					
				end if;
				
				if ((data_value and "10000") = "10000") then 
					green_val_next_2 <= green_val_temp_next;
				else green_val_next_1 <= green_val_temp_next;
				end if;
				
			elsif (data_value = "11111") then
				green_val_next_1 <= "1111";
				green_val_next_2 <= "1111";
				
			end if;
		end if;
				
	end process p_green_data_val;

	
	
	p_blue_data_val : process (clk, data_value) is
		begin
			if(rising_edge(clk)) then
			
			if(data_value = "01001" 
				or data_value = "01010"  
				or data_value = "01011" 
				or data_value = "01100"
				
				or data_value = "11001"
				or data_value = "11010"
				or data_value = "11011"
				or data_value = "11100") then
			
				if ((data_value and "10000") = "10000") then -- on est dans état 3 : séparation des couleurs 
					blue_val_temp_cur <= blue_val_cur_2; 
				else 
					blue_val_temp_cur <= blue_val_cur_1;
					
				end if;
				
				blue_data_value_trans <= (data_value and "01111");
				
				if (blue_data_value_trans = "01001" and blue_val_temp_cur < "1111") then
					blue_val_temp_next <= blue_val_temp_cur + SMALL_VAL;
					
					
				elsif (blue_data_value_trans = "01010" and blue_val_temp_cur< "1111") then 
					
					if (blue_val_temp_cur > MAX_VAL - BIG_VAL) then
						blue_val_temp_next <= "1111";
					else blue_val_temp_next <= blue_val_temp_cur + BIG_VAL;
					end if;
				
				elsif (blue_data_value_trans = "01011" and blue_val_cur_1 > "0000")then
					blue_val_temp_next <= blue_val_temp_cur - SMALL_VAL;
				
				elsif (blue_data_value_trans = "01100" and blue_val_temp_cur > "0000") then
					
					if (blue_val_temp_cur < "0000" + BIG_VAL) then
						blue_val_temp_next <= "0000";
					else blue_val_temp_next <= blue_val_temp_cur - BIG_VAL; 
					end if;
					
				end if;
				
				if ((data_value and "10000") = "10000") then 
					blue_val_next_2 <= blue_val_temp_next;
				else blue_val_next_1 <= blue_val_temp_next;
				end if;
			
			elsif( data_value = "11111") then 
				blue_val_next_1 <= "1111";
				blue_val_next_2 <= "1111";
				
			end if;
			
		end if;
	
	end process p_blue_data_val;
	
	
	p_data_gen_seq : process(clk) is
	begin
		if (rising_edge(clk)) then
			red_val_cur_1 		<= red_val_next_1;
			red_val_cur_2 		<= red_val_next_2;
			green_val_cur_1 	<= green_val_next_1;				
			green_val_cur_2 	<= green_val_next_2;
			blue_val_cur_1 	<= blue_val_next_1;
			blue_val_cur_2 	<= blue_val_next_2;

		end if;
		
	end process p_data_gen_seq;
	
end arch_data_generator;