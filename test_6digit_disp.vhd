----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:20:50 04/30/2019 
-- Design Name: 
-- Module Name:    test_6digit_disp - Behavioral 
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

entity test_6digit_disp is
    Port ( clk, n_rst, n_push: in  STD_LOGIC;
           seg_data : out  STD_LOGIC_VECTOR (7 downto 0);
           sel_7segs : out  STD_LOGIC_VECTOR (5 downto 0));
end test_6digit_disp;

architecture Behavioral of test_6digit_disp is
    component seven_seg6 is
          Port ( clk : in  STD_LOGIC;
                    rst : in  STD_LOGIC;
                     bcd0 : in  STD_LOGIC_VECTOR (3 downto 0);
                     bcd1 : in  STD_LOGIC_VECTOR (3 downto 0);
                     bcd2 : in  STD_LOGIC_VECTOR (3 downto 0);
                     bcd3 : in  STD_LOGIC_VECTOR (3 downto 0);
                     bcd4 : in  STD_LOGIC_VECTOR (3 downto 0);
                     bcd5 : in  STD_LOGIC_VECTOR (3 downto 0);
                     seg_data : out  STD_LOGIC_VECTOR (7 downto 0);
                     sel_7segs : out  STD_LOGIC_VECTOR (5 downto 0));
     end component;
	 component clock_divider is
					Port ( clk, rst : in  STD_LOGIC;
								  div_clk : out  STD_LOGIC);
	 end component;
	 signal bcd0, bcd1, bcd2, bcd3, bcd4, bcd5 : STD_LOGIC_VECTOR (3 downto 0);
	 signal div_clk, rst, pevent : std_logic;
	 
	 component push_button is
    Port ( clk, rst : in  STD_LOGIC;
				push : in  STD_LOGIC;
				pevent : out  STD_LOGIC);
	 end component;
	 
	 component digit6_counter is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           push : in  STD_LOGIC;
           bcd0, bcd1, bcd2, bcd3, bcd4, bcd5 : out  STD_LOGIC_VECTOR (3 downto 0));
	 end component;


begin

     rst <= not n_rst;
	  upush : push_button port map (clk, rst, not n_push, pevent);
	  udigit6 : digit6_counter port map (clk, rst, pevent, bcd0, bcd1, bcd2, bcd3, bcd4, bcd5);
     uclk : clock_divider port map (clk, rst, div_clk);
     udisp: seven_seg6 port map (div_clk, rst, bcd0, bcd1, bcd2, bcd3, bcd4, bcd5, seg_data, sel_7segs);


end Behavioral;

