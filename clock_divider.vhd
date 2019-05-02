----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:22:44 04/30/2019 
-- Design Name: 
-- Module Name:    clock_divider - Behavioral 
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

entity clock_divider is
    Port ( clk, rst : in  STD_LOGIC;
           div_clk : out  STD_LOGIC);
end clock_divider;

architecture Behavioral of clock_divider is
	signal cnt_data : STD_LOGIC_VECTOR(30 downto 0);
begin
	process(clk, rst)
	variable d_clk : STD_lOGIC;
	begin
		if rst='1' then
			cnt_data<=(others=>'0');
			d_clk := '0';
		elsif clk'event and clk='1' then
			if cnt_data = "1000000000000000" then
				cnt_data <= (others=>'0');
				d_clk := not d_clk;
			else
				cnt_data <= cnt_data+1;
				d_clk := d_clk;
			end if;
		end if;
		div_clk <= d_clk;
	end process;

end Behavioral;

