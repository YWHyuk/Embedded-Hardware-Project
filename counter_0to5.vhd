----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:26:13 04/30/2019 
-- Design Name: 
-- Module Name:    counter_0to5 - Behavioral 
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

entity counter_0to5 is
    Port ( clk, rst : in  STD_LOGIC;
           cnt : out STD_LOGIC_VECTOR (2 downto 0));
end counter_0to5;

architecture Behavioral of counter_0to5 is
	signal cnt_data : STD_LOGIC_VECTOR (2 downto 0);
begin
	process(clk, rst)
	begin
		if rst='1' then
			cnt_data <= (others=>'0');
		elsif clk'event and clk='1' then
			if cnt_data = "101" then
				cnt_data <= (others=>'0');
			else
				cnt_data <= cnt_data+1;
			end if;
		end if;
	cnt <= cnt_data;
	end process;


end Behavioral;

