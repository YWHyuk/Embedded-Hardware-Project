----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:10:54 05/27/2019 
-- Design Name: 
-- Module Name:    LineAndDetector - Behavioral 
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

entity LineAndDetector is
    Port ( random1,random2,random3 : in  STD_LOGIC;
           clk,nclr : in  STD_LOGIC;
           btn1,btn2,btn3 : in  STD_LOGIC;
           line1,line2,line3 : out  STD_LOGIC_VECTOR (7 downto 0);
           score : out  STD_LOGIC_VECTOR (1 downto 0));
end LineAndDetector;

architecture Behavioral of LineAndDetector is
	component line is
		port( random1,random2,random3 : in std_logic;
				clk : in std_logic;
				nclr1,nclr2,nclr3 : in std_logic_vector(7 downto 0);
				line1,line2,line3 : out std_logic_vector(7 downto 0)
		);
	end component;
	
	component ThreeBitDetector is
    Port ( btn : in  STD_LOGIC;
				clk : in	STD_LOGIC;
           reg : in  STD_LOGIC_VECTOR (2 downto 0);
           score : out  STD_LOGIC_VECTOR (1 downto 0); --1: middle 0: edge
           nclr : out  STD_LOGIC_VECTOR (2 downto 0));
	end component;
	
	signal sig_nclr1,sig_nclr2,sig_nclr3 : std_logic_vector(7 downto 0):=x"FF";
	
	signal sig_next_nclr1,sig_next_nclr2,sig_next_nclr3 : std_logic_vector(7 downto 0):=x"FF";
	
	signal sig_score1,sig_score2,sig_score3 : std_logic_vector(1 downto 0);
	signal sig_line1,sig_line2,sig_line3 : std_logic_vector(7 downto 0);
begin
	Lines : line port map(random1,random2,random3,clk,sig_next_nclr1,sig_next_nclr2,sig_next_nclr3,sig_line1,sig_line2,sig_line3);
	
	Detector1: ThreeBitDetector port map(btn1,clk,sig_line1(6 downto 4),sig_score1,sig_nclr1(7 downto 5)); --for sync we have to look ahead one moer bit!!
	Detector2: ThreeBitDetector port map(btn2,clk,sig_line2(6 downto 4),sig_score2,sig_nclr2(7 downto 5));
	Detector3: ThreeBitDetector port map(btn3,clk,sig_line3(6 downto 4),sig_score3,sig_nclr3(7 downto 5));
	
	score <= sig_score1 or sig_score2 or sig_score3;
	
	line1 <= sig_line1;
	line2 <= sig_line2;
	line3 <= sig_line3;
	
	--sig_next_clr1 <= (sig_nclr1(7) and nclr) &(sig_nclr1(6) and nclr)&(sig_nclr1(5) and nclr)&nclr&nclr&nclr&nclr&nclr;
	process(nclr,sig_nclr1,sig_nclr2,sig_nclr3)
	begin
		if nclr = '0' then
			sig_next_nclr1<=x"00";
			sig_next_nclr2<=x"00";
			sig_next_nclr3<=x"00";
		else
			sig_next_nclr1<=sig_nclr1(7 downto 5) & "11111";
			sig_next_nclr2<=sig_nclr2(7 downto 5) & "11111";
			sig_next_nclr3<=sig_nclr3(7 downto 5) & "11111";
		end if;
	end process;
end Behavioral;

