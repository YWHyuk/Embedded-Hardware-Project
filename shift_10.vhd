----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:13:41 05/23/2019 
-- Design Name: 
-- Module Name:    shift_10 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- tool versions: 
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

entity shift_10 is
    Port ( input : in  STD_LOGIC;
           --clk : in  STD_LOGIC;
			  --en : STD_LOGIC;
           reset : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (9 downto 0));
end shift_10;

architecture Behavioral of shift_10 is

signal tout : std_logic_vector(9 downto 0) := "1111111111";

begin
	process(reset, input)
		begin
			if reset = '1' then
				tout <= "1111111111";
			elsif input = '1' then
			--elsif en = '1' AND rising_edge(clk) then
					tout(0) <= not input;
					tout(1) <= tout(0);
					tout(2) <= tout(1);
					tout(3) <= tout(2);
					tout(4) <= tout(3);
					tout(5) <= tout(4);
					tout(6) <= tout(5);
					tout(7) <= tout(6);
					tout(8) <= tout(7);
					tout(9) <= tout(8);
			else
				tout <= tout;
			end if;
	end process;
	
	output <= tout;

end Behavioral;