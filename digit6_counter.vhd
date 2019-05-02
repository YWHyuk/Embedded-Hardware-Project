----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:56:35 05/02/2019 
-- Design Name: 
-- Module Name:    digit6_counter - Behavioral 
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

entity digit6_counter is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           push : in  STD_LOGIC;
           bcd0, bcd1, bcd2, bcd3, bcd4, bcd5 : out  STD_LOGIC_VECTOR (3 downto 0));
end digit6_counter;

architecture Behavioral of digit6_counter is
	component counter_0to9 is
		Port ( clk, rst : in  STD_LOGIC;
			c_en : in std_logic;			-- enable counter
			cnt : out  STD_LOGIC_VECTOR (3 downto 0);
			c_up: out std_logic);	-- upper counter enable signal
	end component;	
	signal cup0, cup1, cup2, cup3, cup4, cup5 : std_logic;
	signal cen1, cen2, cen3, cen4, cen5 : std_logic;

begin
	cen1 <= cup0 and push;
	cen2 <= cup1 and cen1;
	cen3 <= cup2 and cen2;
	cen4 <= cup3 and cen3;
	cen5 <= cup4 and cen4;

	dig0: counter_0to9 port map (clk, rst, push, bcd0, cup0);
	dig1: counter_0to9 port map (clk, rst, cen1, bcd1, cup1);
	dig2: counter_0to9 port map (clk, rst, cen2, bcd2, cup2);
	dig3: counter_0to9 port map (clk, rst, cen3, bcd3, cup3);
	dig4: counter_0to9 port map (clk, rst, cen4, bcd4, cup4);
	dig5: counter_0to9 port map (clk, rst, cen5, bcd5, cup5);

end Behavioral;

