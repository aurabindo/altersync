--------------------------------------------------------------------------------
--Author:	Jay Aurabind
--Email	:	aurabindo@computer.org
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY pulse_tb IS
END pulse_tb;
 
ARCHITECTURE behavior OF pulse_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pulse_counter
    PORT(
         DAT_O : OUT  std_logic_vector(63 downto 0);
         ERR_O : OUT  std_logic;
         Pulse_I : IN  std_logic;
         CLK_I : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Pulse_I : std_logic := '0';
   signal CLK_I : std_logic := '0';

 	--Outputs
   signal DAT_O : std_logic_vector(63 downto 0);
   signal ERR_O : std_logic;

   -- Clock period definitions
   constant CLK_I_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pulse_counter PORT MAP (
          DAT_O => DAT_O,
          ERR_O => ERR_O,
          Pulse_I => Pulse_I,
          CLK_I => CLK_I
        );

   -- Clock process definitions
   CLK_I_process :process
   begin
		CLK_I <= '0';
		wait for CLK_I_period/2;
		CLK_I <= '1';
		wait for CLK_I_period/2;
   end process;
 
   Pulse_I_process :process
   begin
		Pulse_I <= '0';
		wait for CLK_I_period*100;
		Pulse_I <= '1';
		wait for CLK_I_period*100;
   end process Pulse_I_process;


END;
