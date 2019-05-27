--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   05:22:56 05/27/2019
-- Design Name:   
-- Module Name:   F:/Dector/LineNDetectorTB.vhd
-- Project Name:  Dector
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: LineAndDetector
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
 
ENTITY LineNDetectorTB IS
END LineNDetectorTB;
 
ARCHITECTURE behavior OF LineNDetectorTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT LineAndDetector
    PORT(
         random1 : IN  std_logic;
         random2 : IN  std_logic;
         random3 : IN  std_logic;
         clk : IN  std_logic;
         btn1 : IN  std_logic;
         btn2 : IN  std_logic;
         btn3 : IN  std_logic;
         line1 : OUT  std_logic_vector(7 downto 0);
         line2 : OUT  std_logic_vector(7 downto 0);
         line3 : OUT  std_logic_vector(7 downto 0);
         score : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal random1 : std_logic := '0';
   signal random2 : std_logic := '0';
   signal random3 : std_logic := '0';
   signal clk : std_logic := '0';
   signal btn1 : std_logic := '0';
   signal btn2 : std_logic := '0';
   signal btn3 : std_logic := '0';

 	--Outputs
   signal line1 : std_logic_vector(7 downto 0);
   signal line2 : std_logic_vector(7 downto 0);
   signal line3 : std_logic_vector(7 downto 0);
   signal score : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: LineAndDetector PORT MAP (
          random1 => random1,
          random2 => random2,
          random3 => random3,
          clk => clk,
          btn1 => btn1,
          btn2 => btn2,
          btn3 => btn3,
          line1 => line1,
          line2 => line2,
          line3 => line3,
          score => score
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
      random1 <= '1';
		random2 <= '1';
		random3 <= '1';
		wait for 100 ns;	
		btn1 <= '1';
      wait for clk_period*10;
		btn1 <= '1';
      btn2 <= '1';
      btn3 <= '1';
      
		wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
