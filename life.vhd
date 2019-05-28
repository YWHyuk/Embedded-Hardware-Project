----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:06:34 05/23/2019 
-- Design Name: 
-- Module Name:    life - Behavioral 
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

entity life is
    Port ( input_die : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           output_life : out  STD_LOGIC_VECTOR (9 downto 0);
           isGG : out  STD_LOGIC);
end life;

architecture Behavioral of life is

component shift_10 is
    Port ( input : in  STD_LOGIC;
           --clk : in  STD_LOGIC;
			  --en : STD_LOGIC;
           reset : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (9 downto 0));
end component;

signal tout : std_logic_vector (9 downto 0);

begin
	U1: shift_10 port map(input_die, rst, tout);
	output_life <= tout;

	isGG <= '1' when tout = "0000000000" else '0';
end Behavioral;

