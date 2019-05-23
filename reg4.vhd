----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:28:35 05/09/2019 
-- Design Name: 
-- Module Name:    reg4 - Behavioral 
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

entity reg4 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           D : in  STD_LOGIC_VECTOR (3 downto 0);
           Q : out  STD_LOGIC_VECTOR (3 downto 0));
end reg4;

architecture Behavioral of reg4 is
	signal TQ : STD_LOGIC_VECTOR (3 downto 0);
begin

	process(D, reset, clk)
	begin
	     if( reset='1') then
			TQ <= "0000"; 
		  elsif(clk'event and clk='1') then
			TQ <= D; 
		  end if;
	end process;
	Q<=TQ; 

end Behavioral;

