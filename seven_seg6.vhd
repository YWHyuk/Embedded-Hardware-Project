----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:40:03 04/30/2019 
-- Design Name: 
-- Module Name:    seven_seg6 - Behavioral 
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

entity seven_seg6 is
	Port ( 	clk : in  STD_LOGIC;
				rst : in  STD_LOGIC;
				bcd0 : in  STD_LOGIC_VECTOR (3 downto 0);
				bcd1 : in  STD_LOGIC_VECTOR (3 downto 0);
				bcd2 : in  STD_LOGIC_VECTOR (3 downto 0);
				bcd3 : in  STD_LOGIC_VECTOR (3 downto 0);
				bcd4 : in  STD_LOGIC_VECTOR (3 downto 0);
				bcd5 : in  STD_LOGIC_VECTOR (3 downto 0);
				seg_data : out  STD_LOGIC_VECTOR (7 downto 0);
				sel_7segs : out  STD_LOGIC_VECTOR (5 downto 0));
end seven_seg6;

architecture Behavioral of seven_seg6 is
	component counter_0to5 is
		 Port ( clk, rst : in  STD_LOGIC;
				  cnt : out STD_LOGIC_VECTOR (2 downto 0));
	end component;
	
	component bcd_7seg is
	port ( bcd_in : in STD_LOGIC_VECTOR (3 downto 0);
			 sel_in : in STD_LOGIC_VECTOR (2 downto 0);
			 Y : out STD_LOGIC_VECTOR (7 downto 0);
			 sel_7segs : out STD_LOGIC_VECTOR (5 downto 0));
	end component;
	
	signal tmpcnt : STD_LOGIC_VECTOR (2 downto 0);
	signal tmpBCD : STD_LOGIC_VECTOR (3 downto 0);
begin

	tcounter: counter_0to5 port map (clk, rst, tmpcnt);
	
	tmpBCD <= 	bcd0 when tmpcnt = "000" else
					bcd1 when tmpcnt = "001" else
					bcd2 when tmpcnt = "010" else
					bcd3 when tmpcnt = "011" else
					bcd4 when tmpcnt = "100" else
					bcd5 when tmpcnt = "101" else
					"0000";
					
	tmp7 : bcd_7seg port map (tmpBCD, tmpcnt, seg_data, sel_7segs);
end Behavioral;

