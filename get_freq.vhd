--------------------------------------------------------------------------------
--Author:	Jay Aurabind
--Email	:	aurabindo@computer.org
--------------------------------------------------------------------------------
	
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity pulse_counter is
port ( DAT_O : out std_logic_vector(63 downto 0);
         ERR_O : out std_logic;  --This is '1' if the pulse freq is more than clk freq.
         Pulse_I : in std_logic;  
       CLK_I : in std_logic
     );
end pulse_counter;


architecture Behavioral of pulse_counter is
signal Curr_Count,Prev_Count : std_logic_vector(63 downto 0):=(others => '0');

begin
--Increment Curr_Count every clock cycle.This is the max freq which can be measured by the module.
process(CLK_I)
	begin
		if( CLK_I'event and CLK_I='1' ) then
			Curr_Count <= Curr_Count + 1;
		end if;
	end process;
--Calculate the time period of the pulse input using the current and previous counts.
	process(Pulse_I)
	begin
		if( Pulse_I'event and Pulse_I = '1' ) then
		--These different conditions eliminate the count overflow problem
		--which can happen once the module is run for a long time.
			if( Prev_Count < Curr_Count ) then
					DAT_O <= Curr_Count - Prev_Count;
					ERR_O <= '0';
			elsif( Prev_Count > Curr_Count ) then
			--X"F_F" is same as "1111_1111".
			--'_' is added for readability.
					DAT_O <= X"1_0000_0000_0000" - Prev_Count + Curr_Count;    
					ERR_O <= '0';
			else
				DAT_O <= (others => '0');
            ERR_O <= '1';  --Error bit is inserted here.
			end if;    
       Prev_Count <= Curr_Count;  --Re-setting the Prev_Count.
		end if;
end process;
end Behavioral;
