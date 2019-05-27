----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:29:34 05/27/2019 
-- Design Name: 
-- Module Name:    RNG - Behavioral 
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

entity RNG is
 Port ( clk,noise : in  STD_LOGIC;
			nclr : in STD_LOGIC;
		  o : out  STD_LOGIC_VECTOR(31 downto 0));
end RNG;

architecture Behavioral of RNG is
	component ThirtyTwoLSFR is
		 Port ( clk : in  STD_LOGIC;
				  sel : in STD_LOGIC_VECTOR(31 downto 0);
				  val : in STD_LOGIC;
				  o : out  STD_LOGIC_VECTOR(31 downto 0));
	end component;
	component shiftreg32bit is
	port( d, clk : in std_logic;
				nclr	 : in std_logic;
				o   : out std_logic_vector(31 downto 0)
		);
	end component;
	component thirtytwoXOR is
    Port ( i : in  STD_LOGIC_VECTOR (31 downto 0);
           o : out  STD_LOGIC);
	end component;
	
	
	signal sig_sel : STD_LOGIC_VECTOR(31 downto 0);
	signal sig_val : STD_LOGIC;
	signal sig_xor_state,sig_xor_noise : STD_LOGIC;
	signal sig_o,sig_noise,sig_state: STD_LOGIC_VECTOR(31 downto 0);
begin
	C1: ThirtyTwoLSFR port map(clk,sig_sel,sig_val,sig_o);
	State_reg: shiftreg32bit port map(sig_o(31),clk,nclr,sig_state);
	Noise_reg: shiftreg32bit port map(noise,clk,nclr,sig_noise);
	C2: thirtytwoXOR port map(sig_noise,sig_xor_noise);
	C3: thirtytwoXOR port map(sig_state,sig_xor_state);
	
	sig_sel <= sig_state and sig_noise;
	sig_val <= sig_xor_noise xor sig_xor_state;
	o<= sig_o;
end Behavioral;

