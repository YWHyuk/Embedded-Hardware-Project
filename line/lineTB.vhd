--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:22:11 05/06/2019
-- Design Name:   
-- Module Name:   E:/line/lineTB.vhd
-- Project Name:  line
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: line
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
 
ENTITY lineTB IS
END lineTB;
 
ARCHITECTURE behavior OF lineTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT line
    PORT(
         random1 : IN  std_logic;
         random2 : IN  std_logic;
         random3 : IN  std_logic;
         clk : IN  std_logic;
         nclr : IN  std_logic;
         line1 : OUT  std_logic_vector(7 downto 0);
         line2 : OUT  std_logic_vector(7 downto 0);
         line3 : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal random1 : std_logic := '0';
   signal random2 : std_logic := '0';
   signal random3 : std_logic := '0';
   signal clk : std_logic := '0';
   signal nclr : std_logic := '0';

 	--Outputs
   signal line1 : std_logic_vector(7 downto 0);
   signal line2 : std_logic_vector(7 downto 0);
   signal line3 : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: line PORT MAP (
          random1 => random1,
          random2 => random2,
          random3 => random3,
          clk => clk,
          nclr => nclr,
          line1 => line1,
          line2 => line2,
          line3 => line3
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
	   random1<='1';
	   random2<='1';
	   random3<='1';
	   
		wait for clk_period*2;
		random1<='1';
	   random2<='0';
	   random3<='0';
		
		wait for clk_period*2;
		random1<='0';
	   random2<='1';
	   random3<='1';
		wait for clk_period*3;
		random1<='0';
	   random2<='0';
	   random3<='0';

      -- insert stimulus here 

      wait;
   end process;

END;
