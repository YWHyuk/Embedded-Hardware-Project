----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:47:43 05/02/2019 
-- Design Name: 
-- Module Name:    counter_0to9 - Behavioral 
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

entity counter_0to9 is
	Port ( clk, rst : in  STD_LOGIC;
				c_en : in std_logic;			-- enable counter
				cnt : out  STD_LOGIC_VECTOR (3 downto 0);
				c_up: out std_logic);		-- upper counter enabler
end counter_0to9;

architecture Behavioral of counter_0to9 is
	signal cnt_data_in, cnt_data_o :  STD_LOGIC_VECTOR (3 downto 0);

begin
	process(c_en, cnt_data_o)
	begin 
		if c_en = '1' then
			if cnt_data_o="1001" then
				cnt_data_in <=(others=>'0');
			else	
				cnt_data_in <=cnt_data_o+1;
			end if;
		else
			cnt_data_in <= cnt_data_o;
		end if;						
	end process;

	process(clk, rst, c_en)
	variable cnt_data : STD_LOGIC_VECTOR (3 downto 0);
		
	begin 
		if rst='1' then
			cnt_data :=(others=>'0');
		elsif clk'event and clk='1' then
			cnt_data := cnt_data_in;
		else
			cnt_data := cnt_data;
		end if;	
		cnt_data_o <= cnt_data;
		cnt<= cnt_data;	
	end process;

	c_up <= 	'1' when cnt_data_o = "1001" else
				'0';




end Behavioral;

