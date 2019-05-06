----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:16:54 05/06/2019 
-- Design Name: 
-- Module Name:    line - Behavioral 
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

entity line is
	port( random1,random2,random3 : in std_logic;
			clk,nclr : in std_logic;
			line1,line2,line3 : out std_logic_vector(7 downto 0)
	);
end line;

architecture Behavioral of line is
component shiftreg8bit is
	port( d, clk : in std_logic;
			nclr	 : in std_logic;
			line   : out std_logic_vector(7 downto 0)
	);
end component;
begin
	shiftreg8bit1: shiftreg8bit port map(random1,clk,nclr,line1);
	shiftreg8bit2: shiftreg8bit port map(random2,clk,nclr,line2);
	shiftreg8bit3: shiftreg8bit port map(random3,clk,nclr,line3);
end Behavioral;

