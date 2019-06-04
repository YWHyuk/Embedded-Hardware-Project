----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:07:52 05/20/2019 
-- Design Name: 
-- Module Name:    ThirtyTwoLSFR - Behavioral 
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

entity ThirtyTwoLSFR is
    Port ( clk : in  STD_LOGIC;
			  sel : in STD_LOGIC_VECTOR(31 downto 0);
			  val : in STD_LOGIC;
           o : out  STD_LOGIC_VECTOR(31 downto 0));
end ThirtyTwoLSFR;

architecture Behavioral of ThirtyTwoLSFR is
	signal x : STD_LOGIC_VECTOR(31 downto 0) := x"A00C0205";
begin
	process(clk,sel,val)
	begin
		if rising_edge(clk) then
			if val = '1'then
				x<= (x(30 downto 0) & (x(31) xor x(21) xor x(1) xor x(0))) or sel;
			else
				x<= (x(30 downto 0) & (x(31) xor x(21) xor x(1) xor x(0))) and (not sel);
			end if;
		end if;
	end process;
	o <= x;
end Behavioral;

