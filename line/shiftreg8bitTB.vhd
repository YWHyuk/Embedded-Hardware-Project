--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:13:08 05/06/2019
-- Design Name:   
-- Module Name:   E:/line/shiftreg8bitTB.vhd
-- Project Name:  line
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: shiftreg8bit
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
 
ENTITY shiftreg8bitTB IS
END shiftreg8bitTB;
 
ARCHITECTURE behavior OF shiftreg8bitTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT shiftreg8bit
    PORT(
         d : IN  std_logic;
         clk : IN  std_logic;
         nclr : IN  std_logic;
         line : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal d : std_logic := '0';
   signal clk : std_logic := '0';
   signal nclr : std_logic := '0';

 	--Outputs
   signal line : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 40 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: shiftreg8bit PORT MAP (
          d => d,
          clk => clk,
          nclr => nclr,
          line => line
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
     nclr<='0';
	  wait for 20ns;
	  nclr<='1';
	  d<='1';
	  wait for clk_period*5;
	  d<='0';
      -- insert stimulus here 

      wait;
   end process;

END;
