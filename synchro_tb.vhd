--------------------------------------------------------------------------------
--Author:	Jay Aurabind
--Email	:	aurabindo@computer.org
--------------------------------------------------------------------------------

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
          COMPONENT synchro
	PORT(
		x1 : IN std_logic;
		x2 : IN std_logic;
		x3 : IN std_logic;
		y1 : IN std_logic;
		y2 : IN std_logic;
		y3 : IN std_logic;
		vcomp : IN std_logic;
		rst : IN std_logic;
		clock : IN std_logic;    
		phase : INOUT std_logic;
		freq : INOUT std_logic;
		voltage : INOUT std_logic;      
		inst : OUT std_logic
		);
	END COMPONENT;
--signals
      signal x1 : std_logic;
		signal x2 : std_logic;
		signal x3 : std_logic;
		signal y1 : std_logic;
		signal y2 : std_logic;
		signal y3 : std_logic;
		signal vcomp : std_logic;
		signal rst : std_logic;
		signal CLK_I : std_logic;    
		signal phase : std_logic;
		signal freq : std_logic;
		signal voltage : std_logic;      
		signal inst : std_logic;
         
--constants
	constant CLK_I_period : time := 10 ns;

  BEGIN

  -- Component Instantiation
          Inst_synchro: synchro PORT MAP(
		x1 => x1,
		x2 => x2,
		x3 => x3,
		y1 => y1,
		y2 => y2,
		y3 => y3,
		vcomp => vcomp, 
		rst => rst,
		phase => phase ,
		freq => freq ,
		voltage => voltage,
		inst => inst,
		clock => CLK_I);



  --  Test Bench Statements
 

      CLK_I_process :process
   begin
		CLK_I <= '0';
		wait for CLK_I_period/2;
		CLK_I <= '1';
		wait for CLK_I_period/2;
   end process;
 

   -- Stimulus process
   process
   begin		
		x1 <= '0';
		wait for CLK_I_period*30;
		x1 <= '1';
		wait for CLK_I_period*30;
   end process;
	
	process
   begin		
		wait for 20 ns;
		x2 <= '0';
		wait for CLK_I_period*30;
		x2 <= '1';
		wait for CLK_I_period*30;
   end process;
	
	process
	begin		
		wait for 40 ns;
		x3 <= '0';
		wait for CLK_I_period*30;
		x3 <= '1';
		wait for CLK_I_period*30;
   end process;
	
--for y's
	
	
	process
   begin		
		y1 <= '0';
		wait for (CLK_I_period*30);
		wait for 25 ns;
		y1 <= '1';
		wait for (CLK_I_period*30) + 25 ns;
   end process;
	
	process
   begin		
		wait for 20 ns;
		y2 <= '0';
		wait for (CLK_I_period*30) + 25 ns;
		y2 <= '1';
		wait for (CLK_I_period*30) + 25 ns;
   end process;
	
	process
	begin		
		wait for 40 ns;
		y3 <= '0';
		wait for (CLK_I_period*30) + 25 ns;
		y3 <= '1';
		wait for (CLK_I_period*30) + 25 ns;
   end process;
-- break

		process
		begin
			
			vcomp <= '1';
			wait for 100 ns;
			rst <= '1';
			wait for 100 ns;
			rst <= '0';
			wait;
		end process;
  END;
