----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:29:42 05/27/2019 
-- Design Name: 
-- Module Name:    ThreeBitDetector - Behavioral 
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

entity ThreeBitDetector is
    Port ( btn : in  STD_LOGIC;
			  clk : in	STD_LOGIC;
           reg : in  STD_LOGIC_VECTOR (2 downto 0);
           score : out  STD_LOGIC_VECTOR (1 downto 0); --1: middle 0: edge
           nclr : out  STD_LOGIC_VECTOR (2 downto 0));
end ThreeBitDetector;

architecture Behavioral of ThreeBitDetector is
	component OneBitDetector is
		 Port ( btn : in  STD_LOGIC;
				  reg : in  STD_LOGIC;
				  clk : in	STD_LOGIC;
				  score : out  STD_LOGIC;
				  nclr : out  STD_LOGIC);
	end component;
	signal sig_score : std_logic_vector(2 downto 0);
begin
	D1 : OneBitDetector port map(btn,reg(0),clk,sig_score(0),nclr(0));
	D2 : OneBitDetector port map(btn,reg(1),clk,sig_score(1),nclr(1));
	D3 : OneBitDetector port map(btn,reg(2),clk,sig_score(2),nclr(2));
	
	score <= sig_score(1) & (sig_score(0) or sig_score(2));
end Behavioral;

