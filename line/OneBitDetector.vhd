----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:21:25 05/27/2019 
-- Design Name: 
-- Module Name:    OneBitDetector - Behavioral 
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

entity OneBitDetector is
    Port ( btn : in  STD_LOGIC;
           reg : in  STD_LOGIC;
			  clk : in	STD_LOGIC;
           score : out  STD_LOGIC;
           nclr : out  STD_LOGIC);
end OneBitDetector;
architecture Behavioral of OneBitDetector is
	signal temp : std_logic := '0';
begin
	-- simple combination logic
	--     <Boolean table>
	-- btn reg | score clr nclr
	--  0   0  |   0    0    1
	--  0   1  |   0    0    1
	--  1   0  |   0    0    1
	--  1   1  |   1    1    0
	process(clk)
	begin
		if rising_edge(clk) then
			temp <= reg;
		end if;
	end process;
	score <= btn and temp;
	nclr <= not (btn and temp); --delay one cycle
end Behavioral;

