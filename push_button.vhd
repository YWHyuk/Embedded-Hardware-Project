----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:45:30 05/02/2019 
-- Design Name: 
-- Module Name:    push_button - Behavioral 
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

entity push_button is
    Port ( clk, rst : in  STD_LOGIC;
				push : in  STD_LOGIC;
				pevent : out  STD_LOGIC);
end push_button;

architecture Behavioral of push_button is
	signal dff_in, dff_out, pevt : std_logic; -- ff input & out
begin

	dff: process (clk, rst)
	begin
		if rst = '1' then
			dff_out <= '0';
		elsif clk'event and clk = '1' then
			dff_out <= push;
		end if;
	end process;

	pevt <= dff_out and (not push);
	
	evt_ff: process (clk, rst)
	begin
		if rst = '1' then
			pevent <= '0';
		elsif clk'event and clk = '1' then
			pevent <= pevt;
		end if;
	end process;

end Behavioral;

