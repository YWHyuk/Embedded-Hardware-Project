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
				line1,line2,line3 : in std_logic_vector(23 downto 0);
				line4,line5,line6 : in std_logic_vector(23 downto 0);
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
					( vsync_cnt <= (tVW + tVBP +16))) then
						
						if ( line1(0) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP +17 )) and 
					( vsync_cnt <= (tVW + tVBP + 33))) then
					
						if ( line1(1) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif ( ( vsync_cnt >= (tVW + tVBP +34 )) and 
					( vsync_cnt <= (tVW + tVBP + 50))) then
					
						if ( line1(2) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 51 )) and 
					( vsync_cnt <= (tVW + tVBP + 67))) then
						
						if ( line1(3) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 68 )) and 
					( vsync_cnt <= (tVW + tVBP + 84))) then
						
						if ( line1(4) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 85 )) and 
					( vsync_cnt <= (tVW + tVBP + 101))) then
						
						if ( line1(5) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 102 )) and 
					( vsync_cnt <= (tVW + tVBP + 118))) then
						
						if ( line1(6) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 119 )) and 
					( vsync_cnt <= (tVW + tVBP + 135))) then
						
						if ( line1(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif( ( vsync_cnt >= (tVW + tVBP + 136 )) and 
					( vsync_cnt <= (tVW + tVBP + 152))) then
						
						if ( line1(8) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 153 )) and 
					( vsync_cnt <= (tVW + tVBP + 169))) then
					
						if ( line1(9) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif ( ( vsync_cnt >= (tVW + tVBP + 170 )) and 
					( vsync_cnt <= (tVW + tVBP + 186))) then
					
						if ( line1(10) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 187 )) and 
					( vsync_cnt <= (tVW + tVBP + 203))) then
						
						if ( line1(11) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 204 )) and 
					( vsync_cnt <= (tVW + tVBP + 220))) then
						
						if ( line1(12) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 221 )) and 
					( vsync_cnt <= (tVW + tVBP + 237))) then
						
						if ( line1(13) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 238 )) and 
					( vsync_cnt <= (tVW + tVBP + 254))) then
						
						if ( line1(14) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 255 )) and 
					( vsync_cnt <= (tVW + tVBP + 271))) then
						
						if ( line1(15) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 272 )) and 
					( vsync_cnt <= (tVW + tVBP + 288))) then
						
						if ( line1(16) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 289 )) and 
					( vsync_cnt <= (tVW + tVBP + 305))) then
						
						if ( line1(17) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 306 )) and 
					( vsync_cnt <= (tVW + tVBP + 322))) then
						
						if ( line1(18) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 323 )) and 
					( vsync_cnt <= (tVW + tVBP + 339))) then
						
						if ( line1(19) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 340 )) and 
					( vsync_cnt <= (tVW + tVBP + 356))) then
						
						if ( line1(20) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 357 )) and 
					( vsync_cnt <= (tVW + tVBP + 373))) then
						
						if ( line1(21) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 374 )) and 
					( vsync_cnt <= (tVW + tVBP + 390))) then
						
						if ( line1(22) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 391 )) and 
					( vsync_cnt <= (tVW + tVBP + 407))) then
						
						if ( line1(23) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
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
					( vsync_cnt <= (tVW + tVBP +16))) then
						
						if ( line2(0) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP +17 )) and 
					( vsync_cnt <= (tVW + tVBP + 33))) then
					
						if ( line2(1) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif ( ( vsync_cnt >= (tVW + tVBP +34 )) and 
					( vsync_cnt <= (tVW + tVBP + 50))) then
					
						if ( line2(2) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 51 )) and 
					( vsync_cnt <= (tVW + tVBP + 67))) then
						
						if ( line2(3) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 68 )) and 
					( vsync_cnt <= (tVW + tVBP + 84))) then
						
						if ( line2(4) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 85 )) and 
					( vsync_cnt <= (tVW + tVBP + 101))) then
						
						if ( line2(5) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 102 )) and 
					( vsync_cnt <= (tVW + tVBP + 118))) then
						
						if ( line2(6) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 119 )) and 
					( vsync_cnt <= (tVW + tVBP + 135))) then
						
						if ( line2(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif( ( vsync_cnt >= (tVW + tVBP + 136 )) and 
					( vsync_cnt <= (tVW + tVBP + 152))) then
						
						if ( line2(8) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 153 )) and 
					( vsync_cnt <= (tVW + tVBP + 169))) then
					
						if ( line2(9) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif ( ( vsync_cnt >= (tVW + tVBP + 170 )) and 
					( vsync_cnt <= (tVW + tVBP + 186))) then
					
						if ( line2(10) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 187 )) and 
					( vsync_cnt <= (tVW + tVBP + 203))) then
						
						if ( line2(11) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 204 )) and 
					( vsync_cnt <= (tVW + tVBP + 220))) then
						
						if ( line2(12) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 221 )) and 
					( vsync_cnt <= (tVW + tVBP + 237))) then
						
						if ( line2(13) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 238 )) and 
					( vsync_cnt <= (tVW + tVBP + 254))) then
						
						if ( line2(14) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 255 )) and 
					( vsync_cnt <= (tVW + tVBP + 271))) then
						
						if ( line2(15) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 272 )) and 
					( vsync_cnt <= (tVW + tVBP + 288))) then
						
						if ( line2(16) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 289 )) and 
					( vsync_cnt <= (tVW + tVBP + 305))) then
						
						if ( line2(17) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 306 )) and 
					( vsync_cnt <= (tVW + tVBP + 322))) then
						
						if ( line2(18) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 323 )) and 
					( vsync_cnt <= (tVW + tVBP + 339))) then
						
						if ( line2(19) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 340 )) and 
					( vsync_cnt <= (tVW + tVBP + 356))) then
						
						if ( line2(20) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 357 )) and 
					( vsync_cnt <= (tVW + tVBP + 373))) then
						
						if ( line2(21) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 374 )) and 
					( vsync_cnt <= (tVW + tVBP + 390))) then
						
						if ( line2(22) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 391 )) and 
					( vsync_cnt <= (tVW + tVBP + 407))) then
						
						if ( line2(23) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
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
					( vsync_cnt <= (tVW + tVBP +16))) then
						
						if ( line3(0) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP +17 )) and 
					( vsync_cnt <= (tVW + tVBP + 33))) then
					
						if ( line3(1) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif ( ( vsync_cnt >= (tVW + tVBP +34 )) and 
					( vsync_cnt <= (tVW + tVBP + 50))) then
					
						if ( line3(2) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 51 )) and 
					( vsync_cnt <= (tVW + tVBP + 67))) then
						
						if ( line3(3) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 68 )) and 
					( vsync_cnt <= (tVW + tVBP + 84))) then
						
						if ( line3(4) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 85 )) and 
					( vsync_cnt <= (tVW + tVBP + 101))) then
						
						if ( line3(5) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 102 )) and 
					( vsync_cnt <= (tVW + tVBP + 118))) then
						
						if ( line3(6) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 119 )) and 
					( vsync_cnt <= (tVW + tVBP + 135))) then
						
						if ( line3(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif( ( vsync_cnt >= (tVW + tVBP + 136 )) and 
					( vsync_cnt <= (tVW + tVBP + 152))) then
						
						if ( line3(8) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 153 )) and 
					( vsync_cnt <= (tVW + tVBP + 169))) then
					
						if ( line3(9) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif ( ( vsync_cnt >= (tVW + tVBP + 170 )) and 
					( vsync_cnt <= (tVW + tVBP + 186))) then
					
						if ( line3(10) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 187 )) and 
					( vsync_cnt <= (tVW + tVBP + 203))) then
						
						if ( line3(11) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 204 )) and 
					( vsync_cnt <= (tVW + tVBP + 220))) then
						
						if ( line3(12) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 221 )) and 
					( vsync_cnt <= (tVW + tVBP + 237))) then
						
						if ( line3(13) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 238 )) and 
					( vsync_cnt <= (tVW + tVBP + 254))) then
						
						if ( line3(14) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 255 )) and 
					( vsync_cnt <= (tVW + tVBP + 271))) then
						
						if ( line3(15) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 272 )) and 
					( vsync_cnt <= (tVW + tVBP + 288))) then
						
						if ( line3(16) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 289 )) and 
					( vsync_cnt <= (tVW + tVBP + 305))) then
						
						if ( line3(17) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 306 )) and 
					( vsync_cnt <= (tVW + tVBP + 322))) then
						
						if ( line3(18) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 323 )) and 
					( vsync_cnt <= (tVW + tVBP + 339))) then
						
						if ( line3(19) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 340 )) and 
					( vsync_cnt <= (tVW + tVBP + 356))) then
						
						if ( line3(20) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 357 )) and 
					( vsync_cnt <= (tVW + tVBP + 373))) then
						
						if ( line3(21) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 374 )) and 
					( vsync_cnt <= (tVW + tVBP + 390))) then
						
						if ( line3(22) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 391 )) and 
					( vsync_cnt <= (tVW + tVBP + 407))) then
						
						if ( line3(23) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
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
			elsif( ( hsync_cnt >= (tHW+tHBP + 542 )) and 
				( hsync_cnt <= (tHW+tHBP + 552 )) ) then
				r_data<= "10001";
				g_data<= "100000";
				b_data<= "01111";
			--first line
			elsif( ( hsync_cnt >= (tHW+tHBP + 553)) and 
				( hsync_cnt <= (tHW+tHBP + 603))) then	
				if( ( vsync_cnt >= (tVW + tVBP -1 )) and 
					( vsync_cnt <= (tVW + tVBP +16))) then
						
						if ( line4(0) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP +17 )) and 
					( vsync_cnt <= (tVW + tVBP + 33))) then
					
						if ( line4(1) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif ( ( vsync_cnt >= (tVW + tVBP +34 )) and 
					( vsync_cnt <= (tVW + tVBP + 50))) then
					
						if ( line4(2) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 51 )) and 
					( vsync_cnt <= (tVW + tVBP + 67))) then
						
						if ( line4(3) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 68 )) and 
					( vsync_cnt <= (tVW + tVBP + 84))) then
						
						if ( line4(4) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 85 )) and 
					( vsync_cnt <= (tVW + tVBP + 101))) then
						
						if ( line4(5) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 102 )) and 
					( vsync_cnt <= (tVW + tVBP + 118))) then
						
						if ( line4(6) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 119 )) and 
					( vsync_cnt <= (tVW + tVBP + 135))) then
						
						if ( line4(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif( ( vsync_cnt >= (tVW + tVBP + 136 )) and 
					( vsync_cnt <= (tVW + tVBP + 152))) then
						
						if ( line4(8) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 153 )) and 
					( vsync_cnt <= (tVW + tVBP + 169))) then
					
						if ( line4(9) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif ( ( vsync_cnt >= (tVW + tVBP + 170 )) and 
					( vsync_cnt <= (tVW + tVBP + 186))) then
					
						if ( line4(10) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 187 )) and 
					( vsync_cnt <= (tVW + tVBP + 203))) then
						
						if ( line4(11) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 204 )) and 
					( vsync_cnt <= (tVW + tVBP + 220))) then
						
						if ( line4(12) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 221 )) and 
					( vsync_cnt <= (tVW + tVBP + 237))) then
						
						if ( line4(13) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 238 )) and 
					( vsync_cnt <= (tVW + tVBP + 254))) then
						
						if ( line4(14) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 255 )) and 
					( vsync_cnt <= (tVW + tVBP + 271))) then
						
						if ( line4(15) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 272 )) and 
					( vsync_cnt <= (tVW + tVBP + 288))) then
						
						if ( line4(16) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 289 )) and 
					( vsync_cnt <= (tVW + tVBP + 305))) then
						
						if ( line4(17) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 306 )) and 
					( vsync_cnt <= (tVW + tVBP + 322))) then
						
						if ( line4(18) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 323 )) and 
					( vsync_cnt <= (tVW + tVBP + 339))) then
						
						if ( line4(19) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 340 )) and 
					( vsync_cnt <= (tVW + tVBP + 356))) then
						
						if ( line4(20) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 357 )) and 
					( vsync_cnt <= (tVW + tVBP + 373))) then
						
						if ( line4(21) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 374 )) and 
					( vsync_cnt <= (tVW + tVBP + 390))) then
						
						if ( line4(22) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 391 )) and 
					( vsync_cnt <= (tVW + tVBP + 407))) then
						
						if ( line4(23) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
				else
					r_data<= "10001";
					g_data<= "100000";
					b_data<= "01111";
				end if;
			elsif( ( hsync_cnt >= (tHW+tHBP + 604)) and 
				( hsync_cnt <= (tHW+tHBP + 610)) ) then
				r_data<= "10001";
				g_data<= "100000";
				b_data<= "01111";
			--second line
			elsif ( ( hsync_cnt >= (tHW+tHBP + 611 )) and 
				( hsync_cnt <= (tHW+tHBP + 661 ))) then
				if( ( vsync_cnt >= (tVW + tVBP -1 )) and 
					( vsync_cnt <= (tVW + tVBP +16))) then
						
						if ( line5(0) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP +17 )) and 
					( vsync_cnt <= (tVW + tVBP + 33))) then
					
						if ( line5(1) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif ( ( vsync_cnt >= (tVW + tVBP +34 )) and 
					( vsync_cnt <= (tVW + tVBP + 50))) then
					
						if ( line5(2) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 51 )) and 
					( vsync_cnt <= (tVW + tVBP + 67))) then
						
						if ( line5(3) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 68 )) and 
					( vsync_cnt <= (tVW + tVBP + 84))) then
						
						if ( line5(4) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 85 )) and 
					( vsync_cnt <= (tVW + tVBP + 101))) then
						
						if ( line5(5) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 102 )) and 
					( vsync_cnt <= (tVW + tVBP + 118))) then
						
						if ( line5(6) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 119 )) and 
					( vsync_cnt <= (tVW + tVBP + 135))) then
						
						if ( line5(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif( ( vsync_cnt >= (tVW + tVBP + 136 )) and 
					( vsync_cnt <= (tVW + tVBP + 152))) then
						
						if ( line5(8) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 153 )) and 
					( vsync_cnt <= (tVW + tVBP + 169))) then
					
						if ( line5(9) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif ( ( vsync_cnt >= (tVW + tVBP + 170 )) and 
					( vsync_cnt <= (tVW + tVBP + 186))) then
					
						if ( line5(10) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 187 )) and 
					( vsync_cnt <= (tVW + tVBP + 203))) then
						
						if ( line5(11) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 204 )) and 
					( vsync_cnt <= (tVW + tVBP + 220))) then
						
						if ( line5(12) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 221 )) and 
					( vsync_cnt <= (tVW + tVBP + 237))) then
						
						if ( line5(13) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 238 )) and 
					( vsync_cnt <= (tVW + tVBP + 254))) then
						
						if ( line5(14) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 255 )) and 
					( vsync_cnt <= (tVW + tVBP + 271))) then
						
						if ( line5(15) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 272 )) and 
					( vsync_cnt <= (tVW + tVBP + 288))) then
						
						if ( line5(16) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 289 )) and 
					( vsync_cnt <= (tVW + tVBP + 305))) then
						
						if ( line5(17) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 306 )) and 
					( vsync_cnt <= (tVW + tVBP + 322))) then
						
						if ( line5(18) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 323 )) and 
					( vsync_cnt <= (tVW + tVBP + 339))) then
						
						if ( line5(19) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 340 )) and 
					( vsync_cnt <= (tVW + tVBP + 356))) then
						
						if ( line5(20) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 357 )) and 
					( vsync_cnt <= (tVW + tVBP + 373))) then
						
						if ( line5(21) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 374 )) and 
					( vsync_cnt <= (tVW + tVBP + 390))) then
						
						if ( line5(22) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 391 )) and 
					( vsync_cnt <= (tVW + tVBP + 407))) then
						
						if ( line5(23) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
				else
					r_data<= "10001";
					g_data<= "100000";
					b_data<= "01111";
				end if;
			--third line
			elsif( ( hsync_cnt >= (tHW+tHBP +  662 )) and 
				( hsync_cnt <= (tHW+tHBP + 668)) ) then
				r_data<= "10001";
				g_data<= "100000";
				b_data<= "01111";
			elsif ( ( hsync_cnt >= (tHW+tHBP +  669 )) and 
				( hsync_cnt <= (tHW+tHBP + 719 ))) then
				if( ( vsync_cnt >= (tVW + tVBP -1 )) and 
					( vsync_cnt <= (tVW + tVBP +16))) then
						
						if ( line6(0) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP +17 )) and 
					( vsync_cnt <= (tVW + tVBP + 33))) then
					
						if ( line6(1) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif ( ( vsync_cnt >= (tVW + tVBP +34 )) and 
					( vsync_cnt <= (tVW + tVBP + 50))) then
					
						if ( line6(2) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 51 )) and 
					( vsync_cnt <= (tVW + tVBP + 67))) then
						
						if ( line6(3) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 68 )) and 
					( vsync_cnt <= (tVW + tVBP + 84))) then
						
						if ( line6(4) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 85 )) and 
					( vsync_cnt <= (tVW + tVBP + 101))) then
						
						if ( line6(5) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 102 )) and 
					( vsync_cnt <= (tVW + tVBP + 118))) then
						
						if ( line6(6) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 119 )) and 
					( vsync_cnt <= (tVW + tVBP + 135))) then
						
						if ( line6(7) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif( ( vsync_cnt >= (tVW + tVBP + 136 )) and 
					( vsync_cnt <= (tVW + tVBP + 152))) then
						
						if ( line6(8) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 153 )) and 
					( vsync_cnt <= (tVW + tVBP + 169))) then
					
						if ( line6(9) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	

				elsif ( ( vsync_cnt >= (tVW + tVBP + 170 )) and 
					( vsync_cnt <= (tVW + tVBP + 186))) then
					
						if ( line6(10) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 187 )) and 
					( vsync_cnt <= (tVW + tVBP + 203))) then
						
						if ( line6(11) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 204 )) and 
					( vsync_cnt <= (tVW + tVBP + 220))) then
						
						if ( line6(12) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 221 )) and 
					( vsync_cnt <= (tVW + tVBP + 237))) then
						
						if ( line6(13) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 238 )) and 
					( vsync_cnt <= (tVW + tVBP + 254))) then
						
						if ( line6(14) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
						
				elsif ( ( vsync_cnt >= (tVW + tVBP + 255 )) and 
					( vsync_cnt <= (tVW + tVBP + 271))) then
						
						if ( line6(15) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 272 )) and 
					( vsync_cnt <= (tVW + tVBP + 288))) then
						
						if ( line6(16) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 289 )) and 
					( vsync_cnt <= (tVW + tVBP + 305))) then
						
						if ( line6(17) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 306 )) and 
					( vsync_cnt <= (tVW + tVBP + 322))) then
						
						if ( line6(18) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 323 )) and 
					( vsync_cnt <= (tVW + tVBP + 339))) then
						
						if ( line6(19) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 340 )) and 
					( vsync_cnt <= (tVW + tVBP + 356))) then
						
						if ( line6(20) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 357 )) and 
					( vsync_cnt <= (tVW + tVBP + 373))) then
						
						if ( line6(21) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 374 )) and 
					( vsync_cnt <= (tVW + tVBP + 390))) then
						
						if ( line6(22) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
							
				elsif ( ( vsync_cnt >= (tVW + tVBP + 391 )) and 
					( vsync_cnt <= (tVW + tVBP + 407))) then
						
						if ( line6(23) = '1') then 
							r_data<= "00110";
							g_data<= "001100";
							b_data<= "00110";
						else
							r_data<= (others=>'1');
							g_data<= (others=>'1');
							b_data<= (others=>'1');
						end if;	
				else
					r_data<= "10001";
					g_data<= "100000";
					b_data<= "01111";
				end if;
			elsif( ( hsync_cnt >= (tHW+tHBP + 720 )) and 
				( hsync_cnt <= (tHW+tHBP + 730)) ) then
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