----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:41:03 05/07/2019 
-- Design Name: 
-- Module Name:    Key_Matrix - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Key_Matrix is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
		-- from key pad
           key_in : in  STD_LOGIC_VECTOR (3 downto 0); 
			  key_event : out STD_LOGIC;
		-- to key pad
           key_scan : out  STD_LOGIC_VECTOR (3 downto 0);
		 -- to display module
			key_data : out  STD_LOGIC_VECTOR (3 downto 0)); 

end Key_Matrix;

architecture Behavioral of Key_Matrix is
	signal scan_cnt : std_logic_vector (3 downto 0);
	signal key_data_in, key_data_reg : std_logic_vector (3 downto 0);
	signal k_push : std_logic;
	signal key_push_in, key_push  : std_logic_vector (3 downto 0);
	
	component reg4 is
		 Port ( clk : in  STD_LOGIC;
				  reset : in  STD_LOGIC;
				  D : in  STD_LOGIC_VECTOR (3 downto 0);
				  Q : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;

begin
-- generate key_scan
	process(reset, clk)
	begin
		if reset = '1' then
			scan_cnt <= "1110";
		elsif rising_edge(clk) then
			scan_cnt <= scan_cnt(2 downto 0) & scan_cnt(3);
		end if;
	end process;	
	key_scan <= scan_cnt;
	
	-- key_input register
	kreg: process(reset, clk)	
	begin
		if reset = '1' then
			key_data_reg <= (others => '1');
		elsif rising_edge(clk) then
			key_data_reg <= key_data_in;
		end if;		
	end process;
	key_data <= key_data_reg;
	
-- processing key matrix
	process(scan_cnt, key_in, key_data_reg)
	begin
		case scan_cnt is
			when "1110" => 
				if		key_in = "1110" then
						key_data_in <= X"1";
				elsif	key_in = "1101" then
						key_data_in <= X"4";
				elsif	key_in = "1011" then
						key_data_in <= X"7";
				elsif	key_in = "0111" then
						key_data_in <= X"0";
				else
						key_data_in <= key_data_reg;
				end if;				
			when "1101" => 
				if		key_in = "1110" then
						key_data_in <= X"2";
				elsif	key_in = "1101" then
						key_data_in <= X"5";
				elsif	key_in = "1011" then
						key_data_in <= X"8";
				elsif	key_in = "0111" then
						key_data_in <= X"A";
				else
						key_data_in <= key_data_reg;
				end if;
			when "1011" => 
				if		key_in = "1110" then
						key_data_in <= X"3";
				elsif	key_in = "1101" then
						key_data_in <= X"6";
				elsif	key_in = "1011" then
						key_data_in <= X"9";
				elsif	key_in = "0111" then
						key_data_in <= X"B";
				else
						key_data_in <= key_data_reg;
				end if;			
			when "0111" => 
				if		key_in = "1110" then
						key_data_in <= X"F";
				elsif	key_in = "1101" then
						key_data_in <= X"E";
				elsif	key_in = "1011" then
						key_data_in <= X"D";
				elsif	key_in = "0111" then
						key_data_in <= X"C";
				else
						key_data_in <= key_data_reg;
				end if;
			when others =>	key_data_in <= key_data_reg;
		end case;
	end process;
	
--	key_nin <= not key_in;
--	key_event <= key_nin(0) or key_nin(1) or key_nin(2) or key_nin(3);
	-- check keypad push
	
	k_push <= key_in(0) and key_in(1) and key_in(2) and key_in(3);

	key_push_in(0) <= k_push when scan_cnt = "1110" else
						key_push(0);
	key_push_in(1) <= k_push when scan_cnt = "1101" else
						key_push(1);
	key_push_in(2) <= k_push when scan_cnt = "1011" else
						key_push(2);
	key_push_in(3) <= k_push when scan_cnt = "0111" else
						key_push(3);
	DREG: reg4 port map (clk, reset, key_push_in, key_push);
	
	-- generate key event
	key_event <=key_push(0) and key_push(1) and key_push(2) and key_push(3);

	

end Behavioral;

