--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:22:51 05/27/2019
-- Design Name:   
-- Module Name:   F:/RNG/shiftreg32bitTB.vhd
-- Project Name:  RNG
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: shiftreg32bit
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
 
ENTITY shiftreg32bitTB IS
END shiftreg32bitTB;
 
ARCHITECTURE behavior OF shiftreg32bitTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT shiftreg32bit
    PORT(
         d : IN  std_logic;
         clk : IN  std_logic;
         nclr : IN  std_logic;
         o : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal d : std_logic := '0';
   signal clk : std_logic := '0';
   signal nclr : std_logic := '0';

 	--Outputs
   signal o : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: shiftreg32bit PORT MAP (
          d => d,
          clk => clk,
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
      nclr <='0';
		wait for 100 ns;	
		nclr <='1';
		d<='1';
		wait for clk_period;
		d<='0';
      wait for clk_period*32;

      -- insert stimulus here 

      wait;
   end process;

END;
