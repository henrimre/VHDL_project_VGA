library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clk_gate_25 is 
port ( 
			clk : in std_logic;
			--reset : in std_logic;
			clk_gate : out std_logic
			--count_out : out std_logic_vector (2 downto 0)
		);
end clk_gate_25;

architecture arch_clk_gate_25 of clk_gate_25 is 
	constant divider : std_logic_vector(2 downto 0) := "001";
	signal count_cur : std_logic_vector(2 downto 0) := "000";
	--signal count_next : std_logic_vector(2 downto 0);
begin 

	p_clk_gate_comb : process (clk)
	begin 
		if(rising_edge(clk)) then 
			if(count_cur = divider) then 
				count_cur <= "000";
				clk_gate <= '1';
			else 
				clk_gate <='0';
				count_cur <= count_cur +"001";
			end if;
			--count_out <= count_cur;
			
		end if;
	end process p_clk_gate_comb;
	
end arch_clk_gate_25;