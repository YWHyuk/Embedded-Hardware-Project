----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:38:57 05/07/2019 
-- Design Name: 
-- Module Name:    TOP - Behavioral 
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

entity TOP is
    Port ( clk, n_reset, n_push1, n_push2, n_push3: in  STD_LOGIC;
			  key_in : in  STD_LOGIC_VECTOR (3 downto 0);
			  inv_rst : in  STD_LOGIC;
           lcd_clk : out  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (15 downto 0);
           de : out  STD_LOGIC;
			  line1, line2, line3 : out std_logic_vector(7 downto 0);
           key_scan : out  STD_LOGIC_VECTOR (3 downto 0);
           sel_7segs : out  STD_LOGIC_VECTOR (5 downto 0);  
           seg_data : out  STD_LOGIC_VECTOR (7 downto 0));
end TOP;

architecture Behavioral of TOP is

	component push_button is
    Port ( clk, rst : in  STD_LOGIC;
				push : in  STD_LOGIC;
				pevent : out  STD_LOGIC);
	end component;
	
	component line is
		port( random1,random2,random3 : in std_logic;
				clk, nclr : in std_logic;
				line1,line2,line3 : out std_logic_vector(7 downto 0)
		);
	end component;
	
	component clock_divider is
    Port ( clk, rst : in  STD_LOGIC;
			  want_clk : in STD_LOGIC_VECTOR(30 downto 0);
           div_clk : out  STD_LOGIC);
	end component;
	
	signal reset, div_clk_line, div_clk_keypad, key_event : std_logic;
	signal key_data : std_logic_vector (3 downto 0);
	
	signal bcd0, bcd1, bcd2, bcd3, bcd4, bcd5 : STD_LOGIC_VECTOR (3 downto 0);
	
	component Key_Matrix is
		 Port ( clk : in  STD_LOGIC;
			  reset : in  STD_LOGIC;
			  key_in : in  STD_LOGIC_VECTOR (3 downto 0); 
			  key_event : out STD_LOGIC;
			  key_scan : out  STD_LOGIC_VECTOR (3 downto 0);						  
			  key_data : out  STD_LOGIC_VECTOR (3 downto 0)); 
	end component;
	
	component seven_seg6 is
		Port ( 	clk : in  STD_LOGIC;
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
	
	component digit6_counter is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           push : in  STD_LOGIC;
           bcd0, bcd1, bcd2, bcd3, bcd4, bcd5 : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;
	signal tline1, tline2, tline3 : std_logic_vector(7 downto 0);
	signal key_push: std_logic;
	signal check : std_logic;
	
	COMPONENT lcd_clk_25m is
		port ( CLKIN_IN        : in    std_logic; 
				 RST_IN          : in    std_logic; 
				 CLKFX_OUT       : out   std_logic; 
				 CLKIN_IBUFG_OUT : out   std_logic; 
				 CLK0_OUT        : out   std_logic; 
				 LOCKED_OUT      : out   std_logic);
	end COMPONENT;

	COMPONENT TFT_LCD is
	    Port ( 	CLK : in  STD_LOGIC;
					inv_RST : in  STD_LOGIC;
					line1,line2,line3 : in std_logic_vector(7 downto 0);
					hsync : out STD_LOGIC;
					vsync : out STD_LOGIC;
					data_out : out  STD_LOGIC_VECTOR (15 downto 0);
					de : out  STD_LOGIC
		 );
	end COMPONENT;
	

	signal rst, tclk : std_logic;
	signal lcd_25m_clk : std_logic;
	signal lcd_den : std_logic;
	signal hsync, vsync : std_logic;
	
	
begin

	reset <= not n_reset;
	
--	KEYPAD_CLOCK : clock_divider port map (tclk, reset, "0000000000000001000000000000000", div_clk_keypad);
	KEYPAD_CLOCK : clock_divider port map (tclk, reset, "0000000000000000000000100000000", div_clk_keypad);
	KEYPAD :	Key_Matrix port map (div_clk_keypad, reset, key_in, key_event, key_scan, key_data);
	KEYPAD_PUSH_EVENT : push_button port map (div_clk_keypad, reset, not key_event, key_push);

--

--	bcd0 <= key_data;	
--	bcd1 <= key_data;	
--	bcd2 <= key_data;	
--	bcd3 <= key_data;	
--	bcd4 <= key_data;	
--	bcd5 <= key_data;	
   check <= key_push and tline1(5);
	SCORE_COUNTER : digit6_counter port map ( div_clk_keypad, reset, check, bcd0, bcd1, bcd2, bcd3, bcd4, bcd5);
	DISPLAY_SCORE: seven_seg6 port map (div_clk_keypad, reset, bcd0, bcd1, bcd2, bcd3, bcd4, bcd5, seg_data, sel_7segs);
		
	
--	U2 : button port map (clk, n_rst, n_push1, n_push2, n_push3, tmp1, tmp2, tmp3);

--	LINE_CLOCK : clock_divider port map (tclk, reset, "0000010000000000000000000000000", div_clk_line);
	LINE_CLOCK : clock_divider port map (tclk, reset, "0000000000100000000000000000000", div_clk_line);
	LINE_LED : line port map (not n_push1, not n_push2 ,not n_push3, div_clk_line, n_reset, tline1, tline2, tline3);
	line1 <= tline1;
	line2 <= tline2;
	line3 <= tline3;


	rst <= not inv_rst;
	de <= lcd_den;
	lcd_clk <= lcd_25m_clk;
	tclk <= lcd_25m_clk;
	
	CLK_25: lcd_clk_25m PORT MAP(
		CLKIN_IN => clk,
		RST_IN => rst,
		CLKFX_OUT => lcd_25m_clk,
		CLKIN_IBUFG_OUT => open,
		CLK0_OUT => open,
		LOCKED_OUT => open
	);

	DTLCD: TFT_LCD port map (
		CLK => lcd_25m_clk,
		inv_RST => inv_RST,
		line1 => tline1,
		line2 => tline2,
		line3 => tline3,
		hsync => hsync,
		vsync => vsync,
		data_out => data_out,
		de => lcd_den
	 );	


end Behavioral;

