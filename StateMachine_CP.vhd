-- State Machine - Color Project
-- Module "Lecture Switch/Btn" décrit dans le rapport du projet

-- Auteurs : Amalou Aghiles, Cretelle Arno, Meuree Henri


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity StateMachine_CP is
	generic(
		STATE_DATA_WIDTH :  integer := 5                            -- Taille du bus de data
	);

	port(
		clk         : in  std_logic;                                -- Clock système 50MHz
		rst_n       : in  std_logic;                                -- Reset système
    
		sw_menu     : in  std_logic_vector(4 downto 3);					-- Switch de navigation entre les menus
		sw_color		: in  std_logic_vector(2 downto 0);					-- Switch de choix RGB
		n_key     		: in  std_logic_vector(3 downto 0);
		
		fsm_state	: out std_logic_vector(STATE_DATA_WIDTH-1 downto 0)
		
		);
end StateMachine_CP;

architecture rtl of StateMachine_CP is 		
	
	signal not_resend			: std_logic := '0';
	signal not_resend_nxt	: std_logic := '0';
	
	type t_state is (
		state_rst,
		state000,
		state100,
		state300,
		
		state110,
		state111,
		state112,
		state113,
		state114,
		
		state120,
		state121,
		state122,
		state123,
		state124,
		
		state130,
		state131,
		state132,
		state133,
		state134,
		
		state200,
		state210,
		state220,
		state230,
		
		state310,
		state311,
		state312,
		state313,
		state314,
		
		state320,
		state321,
		state322,
		state323,
		state324,
		
		state330,
		state331,
		state332,
		state333,
		state334
		);
	
	signal state_cp	: t_state;
	signal state_cp_nxt	: t_state;
	
begin

	
	p_state_interface : process(state_cp ,sw_menu, sw_color, n_key) is
	begin
		--state_cp_nxt <= state000;
		state_cp_nxt <= state_cp;
		
		-- Process combinatoire de gestion des switchs
		case (sw_menu(4 downto 3)) is
			when "00" => 					state_cp_nxt <= state000;
			when "10" =>
				case (sw_color(2 downto 0)) is
					when "000" =>			state_cp_nxt <= state100;
					when "001" => 			state_cp_nxt <= state110; -- Si plusieurs couleurs dont rouge, rouge prioritaire
					when "010"|"110" => 	state_cp_nxt <= state120; -- Si bleu et vert simultané, vert prioritaire
					when "100" => 			state_cp_nxt <= state130;
					when others => 		state_cp_nxt <= state110; 
				end case;
			when "11" => 					state_cp_nxt <= state200;
			when "01" => 
				case (sw_color(2 downto 0)) is
					when "000" =>			state_cp_nxt <= state300;
					when "001" => 			state_cp_nxt <= state310;
					when "010"|"110" => 	state_cp_nxt <= state320;
					when "100" => 			state_cp_nxt <= state330; 
					when others => 		state_cp_nxt <= state310; 
				end case;
			when others => null;
		end case;
		
		-- Process combinatoire de gestion des boutons
		case (state_cp) is
		
			-- when state000|state100|state300 => pas de changement du state ici
			when state110 => 
				case (n_key(3 downto 0)) is
					when "1110" => 		state_cp_nxt <= state111;
					when "1101" => 		state_cp_nxt <= state112;
					when "1011" => 		state_cp_nxt <= state113;
					when "0111" => 		state_cp_nxt <= state114;
					when others => null;
				end case;
			when state120 => 
				case (n_key(3 downto 0)) is
					when "1110" => 		state_cp_nxt <= state121;
					when "1101" => 		state_cp_nxt <= state122;
					when "1011" => 		state_cp_nxt <= state123;
					when "0111" => 		state_cp_nxt <= state124;
					when others => null;
				end case;
			when state130 => 
				case (n_key(3 downto 0)) is
					when "1110" => 		state_cp_nxt <= state131;
					when "1101" => 		state_cp_nxt <= state132;
					when "1011" => 		state_cp_nxt <= state133;
					when "0111" => 		state_cp_nxt <= state134;
					when others => null;
				end case;
			when state310 => 
				case (n_key(3 downto 0)) is
					when "1110" => 		state_cp_nxt <= state311;
					when "1101" => 		state_cp_nxt <= state312;
					when "1011" => 		state_cp_nxt <= state313;
					when "0111" => 		state_cp_nxt <= state314;
					when others => null;
				end case;
			when state320 => 
				case (n_key(3 downto 0)) is
					when "1110" => 		state_cp_nxt <= state321;
					when "1101" => 		state_cp_nxt <= state322;
					when "1011" => 		state_cp_nxt <= state323;
					when "0111" => 		state_cp_nxt <= state324;
					when others => null;
				end case;
			when state330 => 
				case (n_key(3 downto 0)) is
					when "1110" => 		state_cp_nxt <= state331;
					when "1101" => 		state_cp_nxt <= state332;
					when "1011" => 		state_cp_nxt <= state333;
					when "0111" => 		state_cp_nxt <= state334;
					when others => null;
				end case;
			when state200 =>
				case (n_key(3 downto 0)) is
					when "1110" => 		state_cp_nxt <= state210;
					when "1101" => 		state_cp_nxt <= state220;
					when "1011" => 		state_cp_nxt <= state230;
					when others => null;
				end case;
				
			when others => null;

		end case;

				
	end process p_state_interface;
	
		
	p_seq_state : process(clk) is
	begin
		if rising_edge(clk) then
			if (rst_n='0') then
				state_cp <= state_rst;
			else
				state_cp 	<= state_cp_nxt;
				
			end if;
		not_resend 	<= not_resend_nxt;
		end if;
		
	end process p_seq_state;
	

	
	
	p_fsm_state : process(state_cp, not_resend) is
	begin

		case (state_cp) is
			when state000|state100|state200|state300|state110|state120|state130|state310|state320|state330 =>
				fsm_state <= "00000";
				not_resend_nxt <= '0';						-- Pour enable le prochain envois d'information
				
			when others =>
			fsm_state <= "00000";
				if (not_resend = '0') then 			-- Permet d'envoyer l'information de manière unique
					not_resend_nxt <= '1';
					case (state_cp) is				
			
						when state_rst => 			
							fsm_state <= "11111";
							
						when state111 => 				
							fsm_state <= "00001";
						when state112 =>
							fsm_state <= "00010";
						when state113 =>
							fsm_state <= "00011";
						when state114 =>
							fsm_state <= "00100";
						when state121 =>
							fsm_state <= "00101";
						when state122 =>
							fsm_state <= "00110";
						when state123 =>
							fsm_state <= "00111";
						when state124 =>
							fsm_state <= "01000";
						when state131 =>
							fsm_state <= "01001";
						when state132 =>
							fsm_state <= "01010";
						when state133 =>
							fsm_state <= "01011";
						when state134 =>
							fsm_state <= "01100";
							
						when state210 =>
							fsm_state <= "10000";
						when state220 =>
							fsm_state <= "11101";
						when state230 =>
							fsm_state <= "11110";
							
						when state311 => 				
							fsm_state <= "10001";
						when state312 =>
							fsm_state <= "10010";
						when state313 =>
							fsm_state <= "10011";
						when state314 =>
							fsm_state <= "10100";
						when state321 =>
							fsm_state <= "10101";
						when state322 =>
							fsm_state <= "10110";
						when state323 =>
							fsm_state <= "10111";
						when state324 =>
							fsm_state <= "11000";
						when state331 =>
							fsm_state <= "11001";
						when state332 =>
							fsm_state <= "11010";
						when state333 =>
							fsm_state <= "11011";
						when state334 =>
							fsm_state <= "11100";
						when others => null;
					end case;
					
				else 
					fsm_state <= "00000";
					not_resend_nxt <= '1';
				end if;
				
		end case;
					
	
	end process p_fsm_state;

end rtl;
		
		
		
		
		