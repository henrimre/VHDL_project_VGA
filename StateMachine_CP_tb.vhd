-- State Machine - Test Bench - Color Project
-- Module "Lecture Switch/Btn" dÃ©crit dans le rapport du projet

-- Auteurs : Amalou Aghiles, Cretelle Arno, Meuree Henri


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity StateMachine_CP_tb is 
end StateMachine_CP_tb;

architecture tb of StateMachine_CP_tb is 

	signal clk 					: std_logic;
	signal rst_n       		: std_logic;
	
	signal sw_menu     		: std_logic_vector(9 downto 8);					-- Switch de navigation entre les menus
	signal sw_color			: std_logic_vector(2 downto 0);					-- Switch de choix RGB
	signal n_key     			: std_logic_vector(3 downto 0);
		
	signal fsm_state			: std_logic_vector(4 downto 0);
		
begin 

	DUT : entity work.StateMachine_CP port map(
	clk => clk,
	rst_n => rst_n,
	sw_menu => sw_menu,
	sw_color => sw_color,
	n_key => n_key,
	fsm_state => fsm_state);
	
	rst_n <= '1';
	
	p_stimu_clock : process
	begin
		clk <= '0';
		wait for 20 ns/2;
		clk <= '1';
		wait for 20 ns/2;
		
	end process;
	
--	p_simu_RPD : process
--	begin
--		
--	end process p_simu_RPD;

end tb;