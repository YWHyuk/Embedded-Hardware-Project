----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:37:59 05/06/2019 
-- Design Name: 
-- Module Name:    shiftreg8bit - Behavioral 
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

entity shiftreg8bit is
	port( d, clk : in std_logic;
			nclr	 : in std_logic;
			line   : out std_logic_vector(7 downto 0)
	);
end shiftreg8bit;

architecture Behavioral of shiftreg8bit is
component  shiftreg is 
	port( d, clk,nclr : in std_logic;
				qa   : out std_logic
	);
end component;
	signal right: std_logic_vector (7 downto 0);
begin
	shift1:shiftreg port map(d,clk,nclr,right(0));
	shift2:shiftreg port map(right(0),clk,nclr,right(1));
	shift3:shiftreg port map(right(1),clk,nclr,right(2));
	shift4:shiftreg port map(right(2),clk,nclr,right(3));
	shift5:shiftreg port map(right(3),clk,nclr,right(4));
	shift6:shiftreg port map(right(4),clk,nclr,right(5));
	shift7:shiftreg port map(right(5),clk,nclr,right(6));
	shift8:shiftreg port map(right(6),clk,nclr,right(7));
	line <= right;
end Behavioral;

