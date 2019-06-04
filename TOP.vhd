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
			  dip : in  STD_LOGIC_VECTOR (2 downto 0);
           lcd_clk : out  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (15 downto 0);
           de : out  STD_LOGIC;
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
	
	component LineAndDetector is
    Port ( random1,random2,random3 : in  STD_LOGIC;
           clk,nclr : in  STD_LOGIC;
           btn1,btn2,btn3 : in  STD_LOGIC;
           line1,line2,line3 : out  STD_LOGIC_VECTOR (23 downto 0);
           score : out  STD_LOGIC_VECTOR (1 downto 0));
	end component;
	
	component clock_divider is
    Port ( clk, rst : in  STD_LOGIC;
			  want_clk : in STD_LOGIC_VECTOR(30 downto 0);
           div_clk : out  STD_LOGIC);
	end component;
	
	signal reset, div_clk_keypad, key_event : std_logic;
	signal key_data : std_logic_vector (3 downto 0);
	signal div_clk_line, div_clk_line1, div_clk_line2, div_clk_line3 : std_logic;
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
           push1, push2 : in  STD_LOGIC;
           bcd0, bcd1, bcd2, bcd3, bcd4, bcd5 : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;
	signal tline1, tline2, tline3, tline4, tline5, tline6  : std_logic_vector(23 downto 0);
	signal key_push: std_logic;
	signal Correct1, Correct2 : std_logic_vector(1 downto 0);
	signal check1, check2: std_logic;
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
				line1,line2,line3 : in std_logic_vector(23 downto 0);
				line4,line5,line6 : in std_logic_vector(23 downto 0);
				correct1, correct2 : in std_logic;
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
	
	COMPONENT RNG is
	 Port ( clk,noise : in  STD_LOGIC;
				nclr : in STD_LOGIC;
			  o : out  STD_LOGIC_VECTOR(31 downto 0));
	end COMPONENT;
	
	signal rand_array : std_logic_vector (31 downto 0);
	signal nwbk1, nwbk2, nwbk3, nwbk4, nwbk5, nwbk6  : std_logic;
	signal k_push1, k_push2, k_push3, k_push4, k_push5, k_push6 : std_logic;
	
begin

	reset <= not n_reset;
	
--	KEYPAD_CLOCK : clock_divider port map (tclk, reset, "0000000000000001000000000000000", div_clk_keypad);
	KEYPAD_CLOCK : clock_divider port map (tclk, reset, "0000000000000000000000100000000", div_clk_keypad);
	KEYPAD :	Key_Matrix port map (div_clk_keypad, reset, key_in, key_event, key_scan, key_data);
	KEYPAD_PUSH_EVENT : push_button port map (div_clk_keypad, reset, not key_event, key_push);
	
	k_push1 <= key_push when key_data = X"1" else
				  '0';
	k_push2 <= key_push when key_data = X"2" else
				  '0';
	k_push3 <= key_push when key_data = X"3" else
				  '0';

	KEYPAD_PUSH_EVENT4 : push_button port map (div_clk_keypad, reset, n_push1 , k_push4);
	KEYPAD_PUSH_EVENT5 : push_button port map (div_clk_keypad, reset, n_push2 , k_push5);	
	KEYPAD_PUSH_EVENT6 : push_button port map (div_clk_keypad, reset, n_push3 , k_push6);


 --------------- --------------- --------------- 위는 버튼 --------------- --------------- --------------- ---------------
 
	SCORE_COUNTER : digit6_counter port map ( div_clk_keypad, reset, Correct1(1), Correct2(1), bcd0, bcd1, bcd2, bcd3, bcd4, bcd5);
	DISPLAY_SCORE: seven_seg6 port map (div_clk_keypad, reset, bcd0, bcd1, bcd2, bcd3, bcd4, bcd5, seg_data, sel_7segs);

 --------------- --------------- --------------- 스코어 --------------- --------------- --------------- ---------------
	RNG_MODULE : RNG port map(div_clk_line, not n_push1, reset, rand_array);
	nwbk1 <= rand_array(0) and rand_array(3) and rand_array(5) ;
	nwbk2 <= rand_array(5) and rand_array(9) and rand_array(1);
	nwbk3 <= rand_array(10) and rand_array(21) and rand_array(14);
	nwbk4 <= rand_array(7) and rand_array(18) and rand_array(7);
	nwbk5 <= rand_array(19) and rand_array(30) and rand_array(3);
	nwbk6 <= rand_array(25) and rand_array(13) and rand_array(3);
	
--------------- --------------- --------------- 랜덤 --------------- --------------- --------------- ---------------
	div_clk_line <= div_clk_line1 when dip <= "001" else
						 div_clk_line2 when dip <= "010" else
						 div_clk_line3 when dip <= "100" else
						 div_clk_line1;
		
--	LINE_CLOCK : clock_divider port map (tclk, reset, "0000010000000000000000000000000", div_clk_line);
	LINE_CLOCK1 : clock_divider port map (tclk, reset, "0000000001000000000000000000000", div_clk_line1);
	LINE_CLOCK2 : clock_divider port map (tclk, reset, "0000000000100000000000000000000", div_clk_line2);
	LINE_CLOCK3 : clock_divider port map (tclk, reset, "0000000000010000000000000000000", div_clk_line3);
	
	

	LINE_LED1 : LineAndDetector port map ( nwbk1, nwbk2, nwbk3 ,div_clk_line, n_reset, k_push1, k_push2, k_push3, tline1, tline2, tline3, Correct1) ;
	LINE_LED2 : LineAndDetector port map ( nwbk4, nwbk5, nwbk6 ,div_clk_line, n_reset, k_push4, k_push5, k_push6, tline4, tline5, tline6, Correct2) ;
	
	Correct_push1 : push_button port map (div_clk_line, reset, not Correct1(1), check1);
	Correct_push2 : push_button port map (div_clk_line, reset, not Correct2(1), check2);


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
		line4 => tline4,
		line5 => tline5,
		line6 => tline6,
		correct1 => check1,
		correct2 => check2,
		hsync => hsync,
		vsync => vsync,
		data_out => data_out,
		de => lcd_den
	 );	


end Behavioral;

