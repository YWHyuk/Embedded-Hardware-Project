----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:53:53 05/02/2019 
-- Design Name: 
-- Module Name:    add_4BCDs - Behavioral 
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

entity add_4BCDs is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           S : out  STD_LOGIC_VECTOR (3 downto 0);
           Cin : in  STD_LOGIC;
           Cout : out  STD_LOGIC);
end add_4BCDs;

architecture Behavioral of add_4BCDs is

component add_4bits is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           Cin : in  STD_LOGIC;
           Sum : out  STD_LOGIC_VECTOR (3 downto 0);
           Cout : out  STD_LOGIC);
end component;

signal tb, tout : STD_LOGIC_VECTOR (3 downto 0);
signal tcout, t1, t2, ttcout, garbageC : STD_LOGIC;

begin
	U1:add_4bits port map(A,B,Cin,tout,tcout);
	t1 <= tout(3) AND tout(2);
	t2 <= tout(3) AND tout(1);
	ttcout <= t1 OR t2 OR tcout;
	tb <= '0' & ttcout & ttcout & '0';

	U2:add_4bits port map(tout, tb, '0', S, garbageC);
	Cout <= ttcout;

end Behavioral;