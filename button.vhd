----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:01:05 05/07/2019 
-- Design Name: 
-- Module Name:    button - Behavioral 
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

entity button is
    Port ( clk, n_rst, n_push1, n_push2, n_push3: in  STD_LOGIC;
           o1,o2,o3 : out STD_LOGIC);
end button;

architecture Behavioral of button is
	component push_button is
    Port ( clk, rst : in  STD_LOGIC;
				push : in  STD_LOGIC;
				pevent : out  STD_LOGIC);
	end component;
	signal rst, to1, to2, to3 : std_logic;
	
--	component buttonreg is
--	port( d, clk,nclr : in std_logic;
--				qa   : out std_logic
--	);
--	end component;
--	
--	component clock_divider is
--    Port ( clk, rst : in  STD_LOGIC;
--           div_clk : out  STD_LOGIC);
--	end component;
--	signal div_clk: std_logic;
begin
	rst <= not n_rst;
	
	upush1 : push_button port map (clk, rst, not n_push1, to1);
	upush2 : push_button port map (clk, rst, not n_push2, to2);
	upush3 : push_button port map (clk, rst, not n_push3, to3);
	
--	U1 : clock_divider port map (clk, rst, div_clk);
--	ureg1 : buttonreg port map (to1, div_clk, n_rst, o1);
--	ureg2 : buttonreg port map (to2, div_clk, n_rst, o2);
--	ureg3 : buttonreg port map (to3, div_clk, n_rst, o3);
----	
--	reg1: process (to1)
--	begin
--		if rst = '1' then
--			o1 <= '0';
--		elsif to1 = '1' then
--			o1 <= to1;
--		end if;
--	end process;
--	
--	reg2: process (to2)
--	begin
--		if rst = '1' then
--			o2 <= '0';
--		elsif to2 = '1' then
--			o2 <= to2;
--		end if;
--	end process;
--	
--	reg3: process (to3)
--	begin
--		if rst = '1' then
--			o3 <= '0';
--		elsif to3 = '1' then
--			o3 <= to3;
--		end if;
--	end process;
--	
	
end Behavioral;

