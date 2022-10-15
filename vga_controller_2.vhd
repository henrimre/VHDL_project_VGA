-- vga_controller_2
--VGA controller

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_controller_2 is 
	generic(
		--Les valeurs ci-dessous sont propres à l'écran utilisé dans le cadre du projet. 
		H_BACK_PORCH	: integer 	:= 48; 
		H_SYNC_PULSE	: integer 	:= 96;
		H_FRONT_PORCH	: integer 	:= 16;
		H_PIXELS			: integer 	:= 640;
		H_POL				: std_logic := '1'; --polarité positive
		
		
		V_BACK_PORCH	: integer 	:= 33;
		V_SYNC_PULSE	: integer 	:= 2;
		V_FRONT_PORCH	: integer	:= 10;
		V_PIXELS			: integer	:= 480;
		V_POL				: std_logic	:= '1' --polarité positive
	);
	
	port(
		clk_gate					:	in std_logic;	-- clock de 25 MHz
		clk						:	in std_logic;
		row_position			: 	out unsigned (10 downto 0); 	-- sortie de la position verticale 
		column_position		:	out unsigned (11 downto 0);	-- sortie de la position horizontale
		h_sync					:	out std_logic;	-- signal de sortie H_SYNC du VGA
		v_sync					: 	out std_logic;	-- signal de sortie V_SYNC du VGA
		ctrl_area				:	out std_logic 	-- signal de sortie commandant le multiplexer pour l'affichage des couleurs
		);
end vga_controller_2;


architecture arch_vga_controller_2 of vga_controller_2 is 
	constant H_PERIOD : integer := H_BACK_PORCH + H_SYNC_PULSE + H_FRONT_PORCH + H_PIXELS; -- Calcul de la période horizontale totale de l'écran
	constant V_PERIOD : integer := V_BACK_PORCH + V_SYNC_PULSE + V_FRONT_PORCH + V_PIXELS; -- Calcul de la préiode verticale totale de l'écran

	signal h_count_curr : unsigned (11 downto 0) := (others =>'0'); -- Valeur max : 2200
	signal h_count_next : unsigned (11 downto 0) := (others =>'0'); 
	signal v_count_curr : unsigned (10 downto 0) := (others =>'0'); -- valeur max : 1125
	signal v_count_next : unsigned (10 downto 0) := (others =>'0');
	

	
	begin 
	
	p_vga_cont_comb : process(clk, clk_gate) is 
	
	begin
	
		if(falling_edge(clk)) then 
		
			if(clk_gate = '1') then
			
				--Horizontal counter
				if(h_count_curr < H_PERIOD - 1) then 	-- H_PERIOD - 1 car débute à 0 
					h_count_next <= h_count_curr + 1; 		-- on parcourt toute la ligne horizontale
				else 										-- lorsqu'on arrive à la fin : 
					h_count_next <= (others => '0');				     								--  * on recommence à 0 
					--Vertical counter 
					if (v_count_curr < V_PERIOD - 1) then					
						v_count_next <= v_count_curr + 1;	 						--  * on passe à la ligne verticale suivante 							
					else 
						v_count_next <= (others => '0');
					end if;
				end if;

				--Horizontal Time Comparator : création du signal H_SYNC du VGA
				if (h_count_curr < H_PIXELS + H_FRONT_PORCH or h_count_curr >= H_PERIOD - H_BACK_PORCH) then 
					h_sync <= not H_POL; -- signal bas lorsqu'on est dans la partie : pixel, front and back porch car polarité positive
				else 
					h_sync <= H_POL; -- signal haut lorsqu'on est dans la partie : sync pulse
				end if;
				
				--Vertical Time Comparator : création du signal H_SYNC du VGA
				if (v_count_curr < V_PIXELS + V_FRONT_PORCH or v_count_curr >= V_PERIOD - V_BACK_PORCH) then	
					v_sync <= not V_POL; -- signal bas lorsqu'on est dans la partie : pixel (display time), front and back porch 
				else
					v_sync <= V_POL; -- signal haut lorsqu'on est dans la partie : sync pul
				end if;
				
				-- Display area comparator :
				if (h_count_curr < H_PIXELS and v_count_curr < V_PIXELS) then -- lorsqu'on est dans la partie pixel (display time)
					ctrl_area <= '1'; 				-- sortie en haut pour le multiplexer activant les couleurs
					column_position <= h_count_curr;	-- transmission des positions verticales et horizontales du pixel. 
					row_position <= v_count_curr;
				else 
					ctrl_area <= '0';					-- en dehors de la partie pixel (display time) on arrête de transmettre les couleurs pour être dans la partie blanking time
				end if;
			end if;
		end if;
	
	end process p_vga_cont_comb;
	
	
	p_vga_cont_seq : process(clk_gate) is
	begin 
		--if (falling_edge(clk)) then 
		
			if(clk_gate='1') then
			
				h_count_curr <= h_count_next;
				v_count_curr <= v_count_next;		
			end if;
			
		--end if;
	
	end process p_vga_cont_seq;
	
end arch_vga_controller_2;
	
	