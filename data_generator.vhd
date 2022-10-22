--data generator

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_generator is 
   
   generic(
      H_PIXEL  : integer := 640;
      V_PIXEL  : integer := 480
   );
   
   port(
   clk               : in std_logic;
   ctrl_area         : in std_logic;
   row_position      : in unsigned(10 downto 0);
   column_position   : in unsigned(10 downto 0);
   data_value        : in std_logic_vector(4 downto 0);
   
   --test              : out std_logic;
   VGA_R             : out std_logic_vector(3 downto 0);
   VGA_G             : out std_logic_vector(3 downto 0);
   VGA_B             : out std_logic_vector(3 downto 0)
   );
end data_generator;
   
architecture arch_data_generator of data_generator is
   constant SMALL_VAL      : unsigned := "0001"; --1
   constant BIG_VAL        : unsigned := "0111"; --7
   constant MAX_VAL        : unsigned := "1111"; -- 15
   
   signal separation_screen : std_logic_vector(1 downto 0); 
      -- 00 => pas de séparation
   -- 01 => séparation verticale 
   -- 10 => séparation horizontale

	signal red_data_value_trans 	: std_logic_vector (4 downto 0);
	signal data_value_red_temp_next	: std_logic_vector(4 downto 0);
	signal data_value_red_temp_cur	: std_logic_vector(4 downto 0);
	signal red_finish				: std_logic := '0';
	signal red_val_cur_1       	  	: unsigned (3 downto 0) := "0000"; --valeur pour partie 1 de l'écran
	signal red_val_next_1      		: unsigned (3 downto 0) := "0000";
	signal red_val_cur_2       	  	: unsigned (3 downto 0) := "0000"; --valeur pour partie 2 de l'écran
	signal red_val_next_2      		: unsigned (3 downto 0) := "0000";
	signal red_val_temp_cur    	  	: unsigned (3 downto 0) := "0000";
	signal red_val_temp_next   	  	: unsigned (3 downto 0) := "0000";

   	signal green_data_value_trans 		: std_logic_vector(4 downto 0);
	signal data_value_green_temp_next	: std_logic_vector(4 downto 0);
	signal data_value_green_temp_cur	: std_logic_vector(4 downto 0);
	signal green_finish					: std_logic := '0';
	signal green_val_cur_1        		: unsigned (3 downto 0) := "0000";
	signal green_val_next_1       		: unsigned (3 downto 0) := "0000";
	signal green_val_cur_2        		: unsigned (3 downto 0) := "0000";
	signal green_val_next_2       		: unsigned (3 downto 0) := "0000";
	signal green_val_temp_cur     		: unsigned (3 downto 0) := "0000";
	signal green_val_temp_next    		: unsigned (3 downto 0) := "0000";
      
	signal blue_data_value_trans  		: std_logic_vector(4 downto 0);
	signal blue_val_temp_next     		: unsigned (3 downto 0) := "0000";
	signal data_value_blue_temp_next 	: std_logic_vector(4 downto 0);
	signal data_value_blue_temp_cur		: std_logic_vector(4 downto 0);
	signal blue_finish					: std_logic := '0';
	signal blue_val_cur_1        		: unsigned (3 downto 0) := "0000";
	signal blue_val_next_1        		: unsigned (3 downto 0) := "0000";
	signal blue_val_cur_2         		: unsigned (3 downto 0) := "0000";
	signal blue_val_next_2        		: unsigned (3 downto 0) := "0000";
	signal blue_val_temp_cur      		: unsigned (3 downto 0) := "0000";
   
begin 
   
   --test <= '0';
   
	p_data_sep_screen : process (clk, data_value) is 
	begin 
	  if(rising_edge(clk)) then
		 if (data_value = "11101") then   -- on passe à une séparation horizontale de l'écran
		 separation_screen <= "01";
			
		 elsif(data_value = "11110") then 
			separation_screen <= "10";
			
		 elsif(data_value = "10000") then
			separation_screen <= "00";
			
		 end if;
	  end if;
	end process p_data_sep_screen;
   
	p_data_gen_comb : process (clk, ctrl_area, column_position, separation_screen) is
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
			   --rst_data_value <= '1';
			   
			end if;
			
		 else 
			VGA_R <= "0000";
			VGA_G <= "0000";
			VGA_B <= "0000";
		 end if;
	  end if;
	end process p_data_gen_comb;
   
	p_store_red_data_value : process (clk, data_value) is 
   begin 
	if (rising_edge(clk)) then 
         if(   data_value = "00001"       -- liste de tous les états provoquant une modification de la couleur rouge
			or data_value = "00010"  
            or data_value = "00011" 
            or data_value = "00100"
            
            or data_value = "10001"
            or data_value = "10010"
            or data_value = "10011"
            or data_value = "10100"
			or data_value = "11111") then
			
			data_value_red_temp_next <= data_value;
			
		elsif (red_finish = '1') then 
			data_value_red_temp_next <= "00000";
	end if;
	end if;

   end process p_store_red_data_value;
   
	p_red_data_val : process(clk, data_value) is
	begin 

		if(rising_edge(clk)) then
         
			if((data_value_red_temp_cur /= "00000") and data_value_red_temp_cur/= "11111") then
				red_data_value_trans <= (data_value_red_temp_cur and "01111");-- les modes d'incrémentation pour les deux parties de l'écran sont les mêmes au bit de poids le plus fort près
         
				if ((data_value_red_temp_cur and "10000") = "10000") then -- on est dans état séparation des couleurs 
					red_val_temp_cur <= red_val_cur_2;        -- stock la valeurde le couleur de la seconde partie de l'écran dans un signal temporaire
				else 
					red_val_temp_cur <= red_val_cur_1;        
				end if;

				if (red_data_value_trans = "00001" and red_val_temp_cur < "1111") then
					red_val_temp_next <= red_val_temp_cur + SMALL_VAL;
					red_finish <= '1';
               
				elsif (red_data_value_trans = "00010" and red_val_temp_cur< "1111") then
					if (red_val_temp_cur > (MAX_VAL - BIG_VAL)) then -- vérification avant l'incrémentation si celle ci ne va pas dépasser la valeur max
						red_val_temp_next <= "1111";
					else 
						red_val_temp_next <= red_val_temp_cur + BIG_VAL;
					end if;
					red_finish <= '1';
            
				elsif (red_data_value_trans = "00011" and red_val_temp_cur > "0000")then
					red_val_temp_next <= red_val_temp_cur - SMALL_VAL;
					red_finish <= '1';
            
				elsif (red_data_value_trans = "00100" and red_val_temp_cur > "0000") then
					if (red_val_temp_cur < ("0000" + BIG_VAL)) then -- vérification avant décrémentation si on ne dépasse pas la valeur minimale
						red_val_temp_next <= "0000";
					else 
						red_val_temp_next <= red_val_temp_cur - BIG_VAL; 
					end if;
					red_finish <= '1';
					
				end if;
				          
				if ((data_value_red_temp_cur and "10000") = "10000") then --envoie des valeurs next temporaires vers les valeurs de chaque partie d'écran correspondant
					red_val_next_2 <= red_val_temp_next;
				else 
					red_val_next_1 <= red_val_temp_next;
				end if;
				
			elsif (data_value_red_temp_cur = "11111") then -- reset
					red_val_next_1 <= "0000";
					red_val_next_2 <= "0000";
					red_finish <= '1';
					
			elsif (data_value = "00000") then 
				red_finish <= '0';
			end if;
			
		end if;
		
	end process p_red_data_val;

	p_store_green_data_value : process (clk, data_value) is 
	begin 
		if (rising_edge(clk)) then 
			if(data_value = "00101" 
			or data_value = "00110"  
			or data_value = "00111" 
			or data_value = "01000"

			or data_value = "10101"
			or data_value = "10110"
			or data_value = "10111"
			or data_value = "11000"
			or data_value = "11111") then

			data_value_green_temp_next <= data_value;

			elsif (green_finish = '1') then 
				data_value_green_temp_next <= "00000";
			end if;
		end if;

	end process p_store_green_data_value;    
	
	p_green_data_val : process(clk, data_value) is -- le fonctionnement du process green est identique à celui du process red, seules les valeurs des états changent
	begin
		if(rising_edge(clk)) then

			if((data_value_green_temp_cur /= "00000") and (data_value_green_temp_cur /= "11111")) then
				green_data_value_trans <= (data_value_green_temp_cur and "01111");

				if ((data_value_green_temp_cur and "10000") = "10000") then -- on est dans état 3 : séparation des couleurs 
					green_val_temp_cur <= green_val_cur_2; 
				else 
					green_val_temp_cur <= green_val_cur_1;

				end if;

			if (green_data_value_trans = "00101" and green_val_temp_cur < "1111") then
				green_val_temp_next <= green_val_temp_cur + SMALL_VAL;
				green_finish <= '1';

			elsif (green_data_value_trans = "00110" and green_val_temp_cur< "1111") then 
				if (green_val_temp_cur > (MAX_VAL - BIG_VAL)) then
					green_val_temp_next <= "1111";
				else 
					green_val_temp_next <= green_val_temp_cur + BIG_VAL;
				end if;
				green_finish <= '1';
				
			elsif (green_data_value_trans = "00111" and green_val_temp_cur > "0000")then
				green_val_temp_next <= green_val_temp_cur - SMALL_VAL;
				green_finish <= '1';

			elsif (green_data_value_trans = "01000" and green_val_temp_cur > "0000") then
				if (green_val_temp_cur < "0000" + BIG_VAL) then
					green_val_temp_next <= "0000";
				else 
					green_val_temp_next <= green_val_temp_cur - BIG_VAL; 
				end if;
				green_finish <= '1';
		
			end if;

			if ((data_value_green_temp_cur and "10000") = "10000") then 
				green_val_next_2 <= green_val_temp_next;
			else 
				green_val_next_1 <= green_val_temp_next;
			end if;
			
			elsif (data_value_green_temp_cur = "11111") then
				green_val_next_1 <= "0000";
				green_val_next_2 <= "0000";
				green_finish <= '1';
				
			elsif (data_value ="00000") then 
				green_finish <= '0';
				
			end if;
			
		end if;

	end process p_green_data_val;
   
	p_store_blue_data_value : process (clk, data_value) is 
   begin 
	if (rising_edge(clk)) then 
		if(data_value = "01001" 
            or data_value = "01010"  
            or data_value = "01011" 
            or data_value = "01100"
						 
            or data_value = "11001"
            or data_value = "11010"
            or data_value = "11011"
            or data_value = "11100"
			or data_value = "11111") then
			
			data_value_blue_temp_next <= data_value;
			
		elsif (blue_finish = '1') then 
			data_value_blue_temp_next <= "00000";
	end if;
	end if;

   end process p_store_blue_data_value;
   
	p_blue_data_val : process (clk, data_value) is -- le fonctionnement du process blue est identique à celui du process red, seules les valeurs des états changent
	begin
		if(rising_edge(clk)) then

			if((data_value_blue_temp_cur /= "00000") and (data_value_blue_temp_cur /= "11111")) then
				blue_data_value_trans <= (data_value_blue_temp_cur and "01111");

				if ((data_value_blue_temp_cur and "10000") = "10000") then -- on est dans état 3 : séparation des couleurs 
					blue_val_temp_cur <= blue_val_cur_2; 
				else 
					blue_val_temp_cur <= blue_val_cur_1;
				end if;

				if (blue_data_value_trans = "01001" and blue_val_temp_cur < "1111") then
					blue_val_temp_next <= blue_val_temp_cur + SMALL_VAL;
					blue_finish <= '1';

				elsif (blue_data_value_trans = "01010" and blue_val_temp_cur< "1111") then 
					if (blue_val_temp_cur > (MAX_VAL - BIG_VAL)) then
						blue_val_temp_next <= "1111";
					else 
						blue_val_temp_next <= blue_val_temp_cur + BIG_VAL;
					end if;
					blue_finish <= '1';
					
				elsif (blue_data_value_trans = "01011" and blue_val_temp_cur > "0000")then
					blue_val_temp_next <= blue_val_temp_cur - SMALL_VAL;
					blue_finish <= '1';

				elsif (blue_data_value_trans = "01100" and blue_val_temp_cur > "0000") then
					if (blue_val_temp_cur < "0000" + BIG_VAL) then
						blue_val_temp_next <= "0000";
					else 
						blue_val_temp_next <= blue_val_temp_cur - BIG_VAL; 
					end if;
					blue_finish <= '1';
				end if;

				if ((data_value_blue_temp_cur and "10000") = "10000") then 
					blue_val_next_2 <= blue_val_temp_next;
				else 
					blue_val_next_1 <= blue_val_temp_next;
				end if;

			elsif(data_value_blue_temp_cur = "11111") then 
				blue_val_next_1 <= "0000";
				blue_val_next_2 <= "0000";
				blue_finish <= '1';

			elsif (data_value = "00000") then 
				blue_finish <= '0';

			end if;

		end if;

	end process p_blue_data_val;
 
	p_data_gen_seq : process(clk) is -- partie séquentiel des process
  begin
      if (rising_edge(clk)) then
        red_val_cur_2     <= red_val_next_2;
        red_val_cur_1     <= red_val_next_1;
        green_val_cur_1   <= green_val_next_1;          
        green_val_cur_2   <= green_val_next_2;
        blue_val_cur_1    <= blue_val_next_1;
        blue_val_cur_2    <= blue_val_next_2;
		data_value_red_temp_cur 	<= data_value_red_temp_next;
		data_value_green_temp_cur 	<= data_value_green_temp_next;
		data_value_blue_temp_cur 	<= data_value_blue_temp_next;
      end if;
      
   end process p_data_gen_seq;
   
end arch_data_generator;