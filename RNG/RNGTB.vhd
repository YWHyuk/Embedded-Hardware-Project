--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:02:38 05/27/2019
-- Design Name:   
-- Module Name:   F:/RNG/RNGTB.vhd
-- Project Name:  RNG
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RNG
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY RNGTB IS
END RNGTB;
 
ARCHITECTURE behavior OF RNGTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RNG
    PORT(
         clk : IN  std_logic;
         noise : IN  std_logic;
         nclr : IN  std_logic;
         o : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal noise : std_logic := '0';
   signal nclr : std_logic := '0';

 	--Outputs
   signal o : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RNG PORT MAP (
          clk => clk,
          noise => noise,
          nclr => nclr,
          o => o
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		nclr <='1';
		noise <= '1';
		wait for clk_period*2;
		noise <= '0';
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
