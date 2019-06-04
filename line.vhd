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
			clk : in std_logic;
			nclr1,nclr2,nclr3 : in std_logic_vector(23 downto 0);
			line1,line2,line3 : out std_logic_vector(23 downto 0)
	);
end line;

architecture Behavioral of line is
	component shiftreg8bit is
		port( d, clk : in std_logic;
				nclr	 : in std_logic_vector(7 downto 0);
				line   : out std_logic_vector(7 downto 0)
		);
	end component;
	
	signal sig_line1_1,sig_line1_2,sig_line1_3 : std_logic_vector(7 downto 0) := x"00";
	signal sig_line2_1,sig_line2_2,sig_line2_3 : std_logic_vector(7 downto 0) := x"00";
	signal sig_line3_1,sig_line3_2,sig_line3_3 : std_logic_vector(7 downto 0) := x"00";
begin
	--line1
	shiftreg8bit1: shiftreg8bit port map(random1,clk,nclr1(7 downto 0),sig_line1_1);
	shiftreg8bit2: shiftreg8bit port map(sig_line1_1(7),clk,nclr1(15 downto 8),sig_line1_2);
	shiftreg8bit3: shiftreg8bit port map(sig_line1_2(7),clk,nclr1(23 downto 16),sig_line1_3);
	--line2
	shiftreg8bit4: shiftreg8bit port map(random2,clk,nclr2(7 downto 0),sig_line2_1);
	shiftreg8bit5: shiftreg8bit port map(sig_line2_1(7),clk,nclr2(15 downto 8),sig_line2_2);
	shiftreg8bit6: shiftreg8bit port map(sig_line2_2(7),clk,nclr2(23 downto 16),sig_line2_3);
	--line3
	shiftreg8bit7: shiftreg8bit port map(random3,clk,nclr3(7 downto 0),sig_line3_1);
	shiftreg8bit8: shiftreg8bit port map(sig_line3_1(7),clk,nclr3(15 downto 8),sig_line3_2);
	shiftreg8bit9: shiftreg8bit port map(sig_line3_2(7),clk,nclr3(23 downto 16),sig_line3_3);
	line1 <= sig_line1_3 &sig_line1_2 &sig_line1_1;
	line2 <= sig_line2_3 &sig_line2_2 &sig_line2_1;
	line3 <= sig_line3_3 &sig_line3_2 &sig_line1_1;
end Behavioral;