--VGA controller

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_controller is 
	generic(
		--Les valeurs ci-dessous sont propres à l'écran utilisé dans le cadre du projet. 
		H_BACK_PORCH	: integer 	:= 148; 
		H_SYNC_PULSE	: integer 	:= 44;
		H_FRONT_PORCH	: integer 	:= 88;
		H_PIXELS			: integer 	:= 1920;
		
		
		V_BACK_PORCH	: integer 	:= 36;
		V_SYNC_PULSE	: integer 	:= 5;
		V_FRONT_PORCH	: integer	:= 4;
		V_PIXELS			: integer	:= 1080
	);
	
	port(
		pixel_clk_generator	:	in std_logic;	-- clock de 25 MHz 
		row_position			: 	out integer; 	-- sortie de la position verticale 
		column_position		:	out integer;	-- sortie de la position horizontale
		h_sync					:	out std_logic;	-- signal de sortie H_SYNC du VGA
		v_sync					: 	out std_logic;	-- signal de sortie V_SYNC du VGA
		ctrl_area				:	out std_logic 	-- signal de sortie commandant le multiplexer pour l'affichage des couleurs
		);
end vga_controller;


architecture arch_vga_controller of vga_controller is 
	constant H_PERIOD : integer := H_BACK_PORCH + H_SYNC_PULSE + H_FRONT_PORCH + H_PIXELS; -- Calcul de la période horizontale totale de l'écran
	constant V_PERIOD : integer := V_BACK_PORCH + V_SYNC_PULSE + V_FRONT_PORCH + V_PIXELS; -- Calcul de la préiode verticale totale de l'écran
begin 

	process(pixel_clk_generator)
		variable h_count : integer range 0 to H_PERIOD -1 := 0; -- variable pour situer la composante horizontale du pixel actuel
		variable v_count : integer range 0 to V_PERIOD -1 := 0; -- variable pour situer la composante verticale du pixel actuel
	begin  
	if(rising_edge(pixel_clk_generator)) then --!!! Pas de rising edge 
		
		--Horizontal counter
		if(h_count < H_PERIOD - 1) then 	-- H_PERIOD - 1 car débute à 0 
			h_count := h_count + 1; 		-- on parcourt toute la ligne horizontale
		else 										-- lorsqu'on arrive à la fin : 
			h_count := 0;						-- 								--  * on recommence à 0 
			--Vertical counter 
			if (v_count < V_PERIOD - 1) then					
				v_count := v_count + 1;											--  * on passe à la ligne verticale suivante 							
			else 
				v_count := 0;
			end if;
		end if;

		--Horizontal Time Comparator : création du signal H_SYNC du VGA
		if (h_count < H_PIXELS + H_FRONT_PORCH or h_count >= H_PERIOD - H_BACK_PORCH) then 
			h_sync <= '0'; -- signal bas lorsqu'on est dans la partie : pixel, front and back porch car polarité positive
		else 
			h_sync <= '1'; -- signal haut lorsqu'on est dans la partie : sync pulse
		end if;
		
		--Vertical Time Comparator : création du signal H_SYNC du VGA
		if (v_count < V_PIXELS + V_FRONT_PORCH or v_count >= V_PERIOD - V_BACK_PORCH) then	
			v_sync <= '0'; -- signal bas lorsqu'on est dans la partie : pixel (display time), front and back porch 
		else 
			v_sync <= '1'; -- signal haut lorsqu'on est dans la partie : sync pul
		end if;
		
		-- Display area comparator :
		if (h_count < H_PIXELS and v_count < V_PIXELS) then -- lorsqu'on est dans la partie pixel (display time)
			ctrl_area <= '1'; 				-- sortie en haut pour le multiplexer activant les couleurs
			column_position <= h_count;	-- transmission des positions verticales et horizontales du pixel. 
			row_position <= v_count;
		else 
			ctrl_area <= '0';					-- en dehors de la partie pixel (display time) on arrête de transmettre les couleurs pour être dans la partie blanking time
		end if;
	end if;
	
	end process;
end arch_vga_controller;
	
	