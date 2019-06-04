----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:42:08 05/21/2019 
-- Design Name: 
-- Module Name:    TFT_LCD - Behavioral 
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
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TFT_LCD is
    Port ( 	CLK : in  STD_LOGIC;
				inv_RST : in  STD_LOGIC;
				line1,line2,line3 : in std_logic_vector(7 downto 0);
				btn1, btn2, btn3 : in std_logic;
				hsync : out STD_LOGIC;
				vsync : out STD_LOGIC;
				data_out : out  STD_LOGIC_VECTOR (15 downto 0);
				de : out  STD_LOGIC
				
		 );

end TFT_LCD;

architecture Behavioral of TFT_LCD is
	constant tHP  : integer := 928;   -- Hsync Period (tHP)
	constant tHW  : integer := 48;   -- Hsync Pulse Width (tHW)
	constant tHBP : integer := 40;   -- Hsync Back Porch (tHBP)
	constant tHV  : integer := 800;   -- Horizontal valid data width (tHV)
	constant tHFP : integer := 40; -- Horizontal Front Port (tHFP) = 40
                                           -- = (tHP-tHW-tHBP-tHV)   
	constant tVP  : integer := 525;   -- Vsync Period (tVP)
	constant tVW  : integer := 3;   -- Vsync Pulse Width (tVW)
	constant tVBP : integer := 29;   -- Vsync Back Portch (tVBP)
	constant tW   : integer := 480;   -- Vertical valid data width (tW)
	constant tVFP : integer := 13;  	-- Vertical Front Porch (tVFP) = 13
                                            	-- = (tVP-tVW-tVBP-tW); 
	signal hsync_cnt  : std_logic_vector(9 downto 0);
	signal vsync_cnt  : std_logic_vector(9 downto 0);

	signal de_1: std_logic;
	signal vsync_1, hsync_1 : std_logic;
	
	signal r_data: std_logic_vector(4 downto 0);
	signal g_data: std_logic_vector(5 downto 0);
	signal b_data: std_logic_vector(4 downto 0); 

begin
	
	-- Hsync CNT
	process(CLK, inv_RST)         --  sync ¡Æe¡íe
		begin
			if(inv_RST = '0')then
			hsync_cnt <= (others => '0');
			elsif(rising_edge(CLK)) then
				if(hsync_cnt= tHP-1)then
				hsync_cnt <= (others => '0');
					else
					hsync_cnt<= hsync_cnt + 1;
				end if;
			end if;   
	end process;

	-- Vsync CNT
	process(CLK, inv_RST)         --  sync ¡Æe¡íe
	begin
		if(inv_RST = '0')then
	--		vsync_cnt<= 0;
			vsync_cnt <= (others => '0');
		elsif(rising_edge(CLK)) then
			if(hsync_cnt=tHP-1)then
				if(vsync_cnt=tVP-1)then
	--				vsync_cnt<= 0;
					vsync_cnt <= (others => '0');
				else
					vsync_cnt<=vsync_cnt + 1;
				end if;
			else
				vsync_cnt <= vsync_cnt;
			end if;
		end if;   
	end process;

	-- generate Vsync 
	process(CLK, inv_RST, vsync_cnt)
	begin
		if(inv_RST = '0') then
			vsync_1 <= '0';
		elsif rising_edge(CLK) then
			if vsync_cnt = tVW-1 and hsync_cnt = tHP-1 then
				vsync_1 <= '1';
			elsif vsync_cnt = tVP-1 and hsync_cnt = tHP-1 then
				vsync_1 <= '0';
			else
				vsync_1 <= vsync_1;
			end if;
		end if;
	end process;
	vsync <= vsync_1;

	-- generate Hsync 
	process(CLK, inv_RST, hsync_cnt)
	begin
		if(inv_RST = '0') then
			hsync_1 <= '0';
		elsif rising_edge(CLK) then
			if hsync_cnt = tHW-1 then
				hsync_1 <= '1';
			elsif hsync_cnt = tHP-1 then
				hsync_1 <= '0';
			else
				hsync_1 <= hsync_1;
			end if;
		end if;
	end process;
	hsync <= hsync_1;
	
	
		--Data Enable
	process(CLK, inv_RST,  vsync_cnt, hsync_cnt)
	begin
		if(inv_RST = '0')then
			de_1<='0';
		elsif rising_edge(CLK) then
			if ((vsync_cnt >= (tVW + tVBP)) and 
				(vsync_cnt < (tVW + tVBP + tW ))) then  -- during tW
				if(hsync_cnt=(tHW+tHBP-1)) then
					de_1<='1';
				elsif(hsync_cnt=(tHW+tHBP+tHV-1)) then
					de_1<='0';
				else
					de_1<=de_1;
				end if;
			else
				de_1<='0';
			end if;
		end if;		
	end process;
	de <= de_1;

	--LCD Drawing Start
	process(CLK, inv_RST)
	begin
		if (inv_RST='0')then
			r_data<= (others=>'0');
			g_data<= (others=>'0');
			b_data<= (others=>'0');
		elsif (rising_edge(CLK)) then
			if( ( hsync_cnt >= (tHW+tHBP -1 )) and 
				( hsync_cnt <= (tHW+tHBP + 70)) ) then
				r_data<= "10111";
				g_data<= "101000";
				b_data<= "10000";
			elsif( ( hsync_cnt >= (tHW+tHBP + 71 )) and 
				( hsync_cnt <= (tHW+tHBP + 82)) ) then
				r_data<= "10001";
				g_data<= "100000";
				b_data<= "01111";
			--first line
			elsif( ( hsync_cnt >= (tHW+tHBP + 83 )) and 
				( hsync_cnt <= (tHW+tHBP + 137))) then	
				if( ( vsync_cnt >= (tVW + tVBP -1 )) and 
					( vsync_cnt <= (tVW + tVBP +9))) then
						if ( line1(0) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
				elsif ( ( vsync_cnt >= (tVW + tVBP +10 )) and 
					( vsync_cnt <= (tVW + tVBP + 19))) then
						if ( line1(1) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP +20 )) and 
					( vsync_cnt <= (tVW + tVBP + 29))) then
						if ( line1(2) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
				elsif ( ( vsync_cnt >= (tVW + tVBP + 30 )) and 
					( vsync_cnt <= (tVW + tVBP + 39))) then
						if ( line1(3) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
				elsif ( ( vsync_cnt >= (tVW + tVBP + 40 )) and 
					( vsync_cnt <= (tVW + tVBP + 49))) then	
						if ( line1(4) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 50 )) and 
					( vsync_cnt <= (tVW + tVBP + 59))) then	
						if ( line1(5) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 60 )) and 
					( vsync_cnt <= (tVW + tVBP + 69))) then	
						if ( line1(6) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
				elsif ( ( vsync_cnt >= (tVW + tVBP + 70 )) and 
					( vsync_cnt <= (tVW + tVBP + 79))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 80 )) and 
					( vsync_cnt <= (tVW + tVBP + 89))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 90 )) and 
					( vsync_cnt <= (tVW + tVBP + 99))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 100 )) and 
					( vsync_cnt <= (tVW + tVBP + 109))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 110 )) and 
					( vsync_cnt <= (tVW + tVBP + 119))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 120 )) and 
					( vsync_cnt <= (tVW + tVBP + 129))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 130 )) and 
					( vsync_cnt <= (tVW + tVBP + 139))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 140 )) and 
					( vsync_cnt <= (tVW + tVBP + 149))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 150 )) and 
					( vsync_cnt <= (tVW + tVBP + 159))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 160 )) and 
					( vsync_cnt <= (tVW + tVBP + 169))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 170 )) and 
					( vsync_cnt <= (tVW + tVBP + 179))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 180 )) and 
					( vsync_cnt <= (tVW + tVBP + 189))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 190 )) and 
					( vsync_cnt <= (tVW + tVBP + 199))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 200 )) and 
					( vsync_cnt <= (tVW + tVBP + 209))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 210 )) and 
					( vsync_cnt <= (tVW + tVBP + 219))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 220 )) and 
					( vsync_cnt <= (tVW + tVBP + 229))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 230 )) and 
					( vsync_cnt <= (tVW + tVBP + 239))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 240 )) and 
					( vsync_cnt <= (tVW + tVBP + 249))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 250 )) and 
					( vsync_cnt <= (tVW + tVBP + 259))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 260 )) and 
					( vsync_cnt <= (tVW + tVBP + 269))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 270 )) and 
					( vsync_cnt <= (tVW + tVBP + 279))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 280 )) and 
					( vsync_cnt <= (tVW + tVBP + 289))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				
				elsif ( ( vsync_cnt >= (tVW + tVBP + 290 )) and 
					( vsync_cnt <= (tVW + tVBP + 299))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 300 )) and 
					( vsync_cnt <= (tVW + tVBP + 309))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 310 )) and 
					( vsync_cnt <= (tVW + tVBP + 319))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 320 )) and 
					( vsync_cnt <= (tVW + tVBP + 329))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 330 )) and 
					( vsync_cnt <= (tVW + tVBP + 339))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 340 )) and 
					( vsync_cnt <= (tVW + tVBP + 349))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 350 )) and 
					( vsync_cnt <= (tVW + tVBP + 359))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 360 )) and 
					( vsync_cnt <= (tVW + tVBP + 369))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 370 )) and 
					( vsync_cnt <= (tVW + tVBP + 379))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 380 )) and 
					( vsync_cnt <= (tVW + tVBP + 389))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 390 )) and 
					( vsync_cnt <= (tVW + tVBP + 399))) then	
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 413 )) and 
					( vsync_cnt <= (tVW + tVBP + 467))) then
						if( btn1 = '1') then
							r_data<= "01011";
							g_data<= "010110";
							b_data<= "01100";
						else
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						end if;
				else
					r_data<= "10001";
					g_data<= "100000";
					b_data<= "01111";
				end if;
			elsif( ( hsync_cnt >= (tHW+tHBP + 138 )) and 
				( hsync_cnt <= (tHW+tHBP + 144)) ) then
				r_data<= "10001";
				g_data<= "100000";
				b_data<= "01111";
			--second line
			elsif ( ( hsync_cnt >= (tHW+tHBP +145 )) and 
				( hsync_cnt <= (tHW+tHBP + 198))) then
				if( ( vsync_cnt >= (tVW + tVBP -1 )) and 
					( vsync_cnt <= (tVW + tVBP +9))) then
						if ( line2(0) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
				elsif ( ( vsync_cnt >= (tVW + tVBP +10 )) and 
					( vsync_cnt <= (tVW + tVBP + 19))) then
						if ( line2(1) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP +20 )) and 
					( vsync_cnt <= (tVW + tVBP + 29))) then
						if ( line2(2) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
				elsif ( ( vsync_cnt >= (tVW + tVBP + 30 )) and 
					( vsync_cnt <= (tVW + tVBP + 39))) then
						if ( line2(3) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
				elsif ( ( vsync_cnt >= (tVW + tVBP + 40 )) and 
					( vsync_cnt <= (tVW + tVBP + 49))) then	
						if ( line2(4) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 50 )) and 
					( vsync_cnt <= (tVW + tVBP + 59))) then	
						if ( line2(5) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 60 )) and 
					( vsync_cnt <= (tVW + tVBP + 69))) then	
						if ( line2(6) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
				elsif ( ( vsync_cnt >= (tVW + tVBP + 70 )) and 
					( vsync_cnt <= (tVW + tVBP + 79))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 80 )) and 
					( vsync_cnt <= (tVW + tVBP + 89))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 90 )) and 
					( vsync_cnt <= (tVW + tVBP + 99))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 100 )) and 
					( vsync_cnt <= (tVW + tVBP + 109))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 110 )) and 
					( vsync_cnt <= (tVW + tVBP + 119))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 120 )) and 
					( vsync_cnt <= (tVW + tVBP + 129))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 130 )) and 
					( vsync_cnt <= (tVW + tVBP + 139))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 140 )) and 
					( vsync_cnt <= (tVW + tVBP + 149))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 150 )) and 
					( vsync_cnt <= (tVW + tVBP + 159))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 160 )) and 
					( vsync_cnt <= (tVW + tVBP + 169))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 170 )) and 
					( vsync_cnt <= (tVW + tVBP + 179))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 180 )) and 
					( vsync_cnt <= (tVW + tVBP + 189))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 190 )) and 
					( vsync_cnt <= (tVW + tVBP + 199))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 200 )) and 
					( vsync_cnt <= (tVW + tVBP + 209))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 210 )) and 
					( vsync_cnt <= (tVW + tVBP + 219))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 220 )) and 
					( vsync_cnt <= (tVW + tVBP + 229))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 230 )) and 
					( vsync_cnt <= (tVW + tVBP + 239))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 240 )) and 
					( vsync_cnt <= (tVW + tVBP + 249))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 250 )) and 
					( vsync_cnt <= (tVW + tVBP + 259))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 260 )) and 
					( vsync_cnt <= (tVW + tVBP + 269))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 270 )) and 
					( vsync_cnt <= (tVW + tVBP + 279))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 280 )) and 
					( vsync_cnt <= (tVW + tVBP + 289))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				
				elsif ( ( vsync_cnt >= (tVW + tVBP + 290 )) and 
					( vsync_cnt <= (tVW + tVBP + 299))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 300 )) and 
					( vsync_cnt <= (tVW + tVBP + 309))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 310 )) and 
					( vsync_cnt <= (tVW + tVBP + 319))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 320 )) and 
					( vsync_cnt <= (tVW + tVBP + 329))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 330 )) and 
					( vsync_cnt <= (tVW + tVBP + 339))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 340 )) and 
					( vsync_cnt <= (tVW + tVBP + 349))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 350 )) and 
					( vsync_cnt <= (tVW + tVBP + 359))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 360 )) and 
					( vsync_cnt <= (tVW + tVBP + 369))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 370 )) and 
					( vsync_cnt <= (tVW + tVBP + 379))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 380 )) and 
					( vsync_cnt <= (tVW + tVBP + 389))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 390 )) and 
					( vsync_cnt <= (tVW + tVBP + 399))) then	
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 413 )) and 
					( vsync_cnt <= (tVW + tVBP + 467))) then
						if( btn2 = '1') then
							r_data<= "01011";
							g_data<= "010110";
							b_data<= "01100";
						else
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						end if;
				else
					r_data<= "10001";
					g_data<= "100000";
					b_data<= "01111";
				end if;
			--third line
			elsif( ( hsync_cnt >= (tHW+tHBP + 199 )) and 
				( hsync_cnt <= (tHW+tHBP + 206)) ) then
				r_data<= "10001";
				g_data<= "100000";
				b_data<= "01111";
			elsif ( ( hsync_cnt >= (tHW+tHBP + 207 )) and 
				( hsync_cnt <= (tHW+tHBP + 260))) then
				if( ( vsync_cnt >= (tVW + tVBP -1 )) and 
					( vsync_cnt <= (tVW + tVBP +9))) then
						if ( line3(0) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
				elsif ( ( vsync_cnt >= (tVW + tVBP +10 )) and 
					( vsync_cnt <= (tVW + tVBP + 19))) then
						if ( line3(1) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP +20 )) and 
					( vsync_cnt <= (tVW + tVBP + 29))) then
						if ( line3(2) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
				elsif ( ( vsync_cnt >= (tVW + tVBP + 30 )) and 
					( vsync_cnt <= (tVW + tVBP + 39))) then
						if ( line3(3) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
				elsif ( ( vsync_cnt >= (tVW + tVBP + 40 )) and 
					( vsync_cnt <= (tVW + tVBP + 49))) then	
						if ( line3(4) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 50 )) and 
					( vsync_cnt <= (tVW + tVBP + 59))) then	
						if ( line3(5) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 60 )) and 
					( vsync_cnt <= (tVW + tVBP + 69))) then	
						if ( line3(6) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
				elsif ( ( vsync_cnt >= (tVW + tVBP + 70 )) and 
					( vsync_cnt <= (tVW + tVBP + 79))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 80 )) and 
					( vsync_cnt <= (tVW + tVBP + 89))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 90 )) and 
					( vsync_cnt <= (tVW + tVBP + 99))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 100 )) and 
					( vsync_cnt <= (tVW + tVBP + 109))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 110 )) and 
					( vsync_cnt <= (tVW + tVBP + 119))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 120 )) and 
					( vsync_cnt <= (tVW + tVBP + 129))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 130 )) and 
					( vsync_cnt <= (tVW + tVBP + 139))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 140 )) and 
					( vsync_cnt <= (tVW + tVBP + 149))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 150 )) and 
					( vsync_cnt <= (tVW + tVBP + 159))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 160 )) and 
					( vsync_cnt <= (tVW + tVBP + 169))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 170 )) and 
					( vsync_cnt <= (tVW + tVBP + 179))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 180 )) and 
					( vsync_cnt <= (tVW + tVBP + 189))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 190 )) and 
					( vsync_cnt <= (tVW + tVBP + 199))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 200 )) and 
					( vsync_cnt <= (tVW + tVBP + 209))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 210 )) and 
					( vsync_cnt <= (tVW + tVBP + 219))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 220 )) and 
					( vsync_cnt <= (tVW + tVBP + 229))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 230 )) and 
					( vsync_cnt <= (tVW + tVBP + 239))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 240 )) and 
					( vsync_cnt <= (tVW + tVBP + 249))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 250 )) and 
					( vsync_cnt <= (tVW + tVBP + 259))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 260 )) and 
					( vsync_cnt <= (tVW + tVBP + 269))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 270 )) and 
					( vsync_cnt <= (tVW + tVBP + 279))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 280 )) and 
					( vsync_cnt <= (tVW + tVBP + 289))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				
				elsif ( ( vsync_cnt >= (tVW + tVBP + 290 )) and 
					( vsync_cnt <= (tVW + tVBP + 299))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 300 )) and 
					( vsync_cnt <= (tVW + tVBP + 309))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 310 )) and 
					( vsync_cnt <= (tVW + tVBP + 319))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 320 )) and 
					( vsync_cnt <= (tVW + tVBP + 329))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 330 )) and 
					( vsync_cnt <= (tVW + tVBP + 339))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 340 )) and 
					( vsync_cnt <= (tVW + tVBP + 349))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 350 )) and 
					( vsync_cnt <= (tVW + tVBP + 359))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 360 )) and 
					( vsync_cnt <= (tVW + tVBP + 369))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 370 )) and 
					( vsync_cnt <= (tVW + tVBP + 379))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 380 )) and 
					( vsync_cnt <= (tVW + tVBP + 389))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 390 )) and 
					( vsync_cnt <= (tVW + tVBP + 399))) then	
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;
				elsif ( ( vsync_cnt >= (tVW + tVBP + 413 )) and 
					( vsync_cnt <= (tVW + tVBP + 467))) then
						if( btn3 = '1') then
							r_data<= "01011";
							g_data<= "010110";
							b_data<= "01100";
						else
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						end if;
				else
					r_data<= "10001";
					g_data<= "100000";
					b_data<= "01111";
				end if;
			elsif( ( hsync_cnt >= (tHW+tHBP + 262 )) and 
				( hsync_cnt <= (tHW+tHBP + 272)) ) then
				r_data<= "10001";
				g_data<= "100000";
				b_data<= "01111";
			else
				r_data<= "10111";
				g_data<= "101000";
				b_data<= "10000";
			end if;
		end if;
	end process;
	
	data_out <= r_data & g_data & b_data when de_1 = '1' else
					(others => '0');




end Behavioral;