----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:52:12 05/02/2019 
-- Design Name: 
-- Module Name:    add_4bits - Behavioral 
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

entity add_4bits is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           Cin : in  STD_LOGIC;
           Sum : out  STD_LOGIC_VECTOR (3 downto 0);
           Cout : out  STD_LOGIC);
end add_4bits;

architecture Behavioral of add_4bits is

component fullAdder
Port ( A : in  STD_LOGIC;
       B : in  STD_LOGIC;
       S : out  STD_LOGIC;
       Cin : in  STD_LOGIC;
       Cout : out  STD_LOGIC);
end component;

signal tcout1,tcout2,tcout3 : STD_LOGIC;

begin
	U1:fullAdder port map(A(0),B(0),Sum(0),Cin,tcout1);
	U2:fullAdder port map(A(1),B(1),Sum(1),tcout1,tcout2);
	U3:fullAdder port map(A(2),B(2),Sum(2),tcout2,tcout3);
	U4:fullAdder port map(A(3),B(3),Sum(3),tcout3,Cout);

end Behavioral;