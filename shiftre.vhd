----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:38:02 05/07/2019 
-- Design Name: 
-- Module Name:    shiftre - Behavioral 
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

entity  shiftreg is 
port( d, clk,nclr : in std_logic;
         qa   : out std_logic
);
end shiftreg;

architecture a of shiftreg is
	
	signal tqa: std_logic;
	
begin
	process(d,nclr,clk)
	begin
	     if( nclr='0') then
		tqa <='0'; 
		  elsif(clk'event and clk='1') then
		tqa <= d; 
		  end if;
	end process;
	qa<=tqa; 
end a;
