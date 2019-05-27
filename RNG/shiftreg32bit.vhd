----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:12:20 05/27/2019 
-- Design Name: 
-- Module Name:    shiftreg32bit - Behavioral 
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

entity shiftreg32bit is
	port( d, clk : in std_logic;
				nclr	 : in std_logic;
				o   : out std_logic_vector(31 downto 0)
		);
end shiftreg32bit;

architecture Behavioral of shiftreg32bit is
	component shiftreg8bit is
	port( d, clk : in std_logic;
			nclr	 : in std_logic;
			line   : out std_logic_vector(7 downto 0)
	);
	end component;
	signal o1,o2,o3,o4 : std_logic_vector(7 downto 0) :="00000000";
begin
	S1: shiftreg8bit port map(d,clk,nclr,o1);
	S2: shiftreg8bit port map(o1(7),clk,nclr,o2);
	S3: shiftreg8bit port map(o2(7),clk,nclr,o3);
	S4: shiftreg8bit port map(o3(7),clk,nclr,o4);
	o<= o4 & o3 & o2 & o1;
end Behavioral;

