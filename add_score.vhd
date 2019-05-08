----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:59:10 05/02/2019 
-- Design Name: 
-- Module Name:    add_score - Behavioral 
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity add_score is
    Port ( Score1 : in  STD_LOGIC;
           Score2 : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
			  clk : in  STD_LOGIC;
           BCD1 : out  STD_LOGIC_VECTOR (3 downto 0);
           BCD2 : out  STD_LOGIC_VECTOR (3 downto 0);
           BCD3 : out  STD_LOGIC_VECTOR (3 downto 0);
           BCD4 : out  STD_LOGIC_VECTOR (3 downto 0);
           BCD5 : out  STD_LOGIC_VECTOR (3 downto 0);
           BCD6 : out  STD_LOGIC_VECTOR (3 downto 0));
end add_score;

architecture Behavioral of add_score is

component add_4BCDs is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           S : out  STD_LOGIC_VECTOR (3 downto 0);
           Cin : in  STD_LOGIC;
           Cout : out  STD_LOGIC);
end component;

component reg_4bit is
    Port ( input : in  STD_LOGIC_VECTOR (3 downto 0);
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           en : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

signal tS, tScore : STD_LOGIC_VECTOR (23 downto 0);
signal regData : STD_LOGIC_VECTOR (23 downto 0) := "000000000000000000000000";
signal tCout1, tCout2, tCout3, tCout4, tCout5, tCout6 : STD_logic;

begin
	process(Score1, Score2)
		begin
			tScore <= "000000000000000000000000";
			IF Score1 = '1' AND Score2 = '1' THEN
				tScore <= tScore + 3;
			ELSIF Score1 = '1' THEN
				tScore <= tScore + 1;
			ELSIF Score2 = '1' THEN
				tScore <= tScore + 2;
			END IF;
	end process;

	U1:add_4BCDs port map(regData(3 downto 0), tScore(3 downto 0), tS(3 downto 0), '0', tCout1);
	U2:add_4BCDs port map(regData(7 downto 4), tScore(7 downto 4), tS(7 downto 4), tCout1, tCout2);
	U3:add_4BCDs port map(regData(11 downto 8), tScore(11 downto 8), tS(11 downto 8), tCout2, tCout3);
	U4:add_4BCDs port map(regData(15 downto 12), tScore(15 downto 12), tS(15 downto 12), tCout3, tCout4);
	U5:add_4BCDs port map(regData(19 downto 16), tScore(19 downto 16), tS(19 downto 16), tCout4, tCout5);
	U6:add_4BCDs port map(regData(23 downto 20), tScore(23 downto 20), tS(23 downto 20), tCout5, tCout6);

	U7:reg_4bit port map(input => tS(3 downto 0), clk => clk, reset => Reset, en => '1', output => regData(3 downto 0));
	U8:reg_4bit port map(input => tS(7 downto 4), clk => clk, reset => Reset, en => '1', output => regData(7 downto 4));
	U9:reg_4bit port map(input => tS(11 downto 8), clk => clk, reset => Reset, en => '1', output => regData(11 downto 8));
	U10:reg_4bit port map(input => tS(15 downto 12), clk => clk, reset => Reset, en => '1', output => regData(15 downto 12));
	U11:reg_4bit port map(input => tS(19 downto 16), clk => clk, reset => Reset, en => '1', output => regData(19 downto 16));
	U12:reg_4bit port map(input => tS(23 downto 20), clk => clk, reset => Reset, en => '1', output => regData(23 downto 20));

	BCD1 <= regData(3 downto 0);
	BCD2 <= regData(7 downto 4);
	BCD3 <= regData(11 downto 8);
	BCD4 <= regData(15 downto 12);
	BCD5 <= regData(19 downto 16);
	BCD6 <= regData(23 downto 20);
	
	--BCD1 <= tS(3 downto 0);
	--BCD2 <= tS(7 downto 4);
	--BCD3 <= tS(11 downto 8);
	--BCD4 <= tS(15 downto 12);
	--BCD5 <= tS(19 downto 16);
	--BCD6 <= tS(23 downto 20);

end Behavioral;