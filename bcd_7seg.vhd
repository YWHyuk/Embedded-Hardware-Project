----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:28:44 04/30/2019 
-- Design Name: 
-- Module Name:    bcd_7seg - Behavioral 
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

entity bcd_7seg is
	port ( bcd_in : in STD_LOGIC_VECTOR (3 downto 0);
			 sel_in : in STD_LOGIC_VECTOR (2 downto 0);
			 Y : out STD_LOGIC_VECTOR (7 downto 0);
			 sel_7segs : out STD_LOGIC_VECTOR (5 downto 0));
end bcd_7seg;

architecture Behavioral of bcd_7seg is

begin
	sel_7segs <= 	"000001" when sel_in = "000" else
						"000010" when sel_in = "001" else
						"000100" when sel_in = "010" else
						"001000" when sel_in = "011" else
						"010000" when sel_in = "100" else
						"100000" when sel_in = "101" else
						"000000";
	
	
	Y <= 	"00111111" when (bcd_in = "0000") else --0
		"00000110" when (bcd_in = "0001") else --1
		"01011011" when (bcd_in = "0010") else --2
		"01001111" when (bcd_in = "0011") else --3
		"01100110" when (bcd_in = "0100") else --4
		"01101101" when (bcd_in = "0101") else --5 
		"01111100" when (bcd_in = "0110") else --6
		"00000111" when (bcd_in = "0111") else --7 
		"01111111" when (bcd_in = "1000") else --8
		"01100111" when (bcd_in = "1001") else --9
		"00000000";
	
	
end Behavioral;

