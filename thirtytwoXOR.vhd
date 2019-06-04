----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:59:21 05/27/2019 
-- Design Name: 
-- Module Name:    thirtytwoXOR - Behavioral 
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

entity thirtytwoXOR is
    Port ( i : in  STD_LOGIC_VECTOR (31 downto 0);
           o : out  STD_LOGIC);
end thirtytwoXOR;

architecture Behavioral of thirtytwoXOR is
	component eightbitXOR is
    Port ( i : in  STD_LOGIC_VECTOR (7 downto 0);
           o : out  STD_LOGIC);
	end component;
	signal o1,o2,o3,o4 : STD_LOGIC;
begin
	C1: eightbitXOR port map(i(7 downto 0),o1);
	C2: eightbitXOR port map(i(15 downto 8),o2);
	C3: eightbitXOR port map(i(23 downto 16),o3);
	C4: eightbitXOR port map(i(31 downto 24),o4);
	o <= o1 xor o2 xor o3 xor o4;
end Behavioral;

