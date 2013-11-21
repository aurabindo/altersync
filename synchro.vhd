--------------------------------------------------------------------------------
--Author:	Jay Aurabind
--Email	:	aurabindo@computer.org
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity synchro is
    Port ( x1 : in  STD_LOGIC;
           x2 : in  STD_LOGIC;
           x3 : in  STD_LOGIC;
           y1 : in  STD_LOGIC;
           y2 : in  STD_LOGIC;
           y3 : in  STD_LOGIC;
           vcomp, rst : in  STD_LOGIC;
           phase : inout  STD_LOGIC;
           freq : inout  STD_LOGIC;
           voltage : inout  STD_LOGIC;
           inst : out  STD_LOGIC;
			  clock : in std_logic);
			  
end synchro;



			
architecture Behavioral of synchro is

	COMPONENT pulse_counter
	PORT(
		Pulse_I : IN std_logic;
		CLK_I : IN std_logic;          
		DAT_O : OUT std_logic_vector(63 downto 0);
		ERR_O : OUT std_logic
		);
	END COMPONENT;
	
	signal error_x, error_y, freq_temp,posedge_x, posedge_y : std_logic;
	signal x1_store, y1_store : std_logic;
	signal countx,county : std_logic_vector(63 downto 0) :=(others => '0');
	
begin  --architecture begins

Inst_pulse_counter_X1: pulse_counter PORT MAP(
		DAT_O => countx,
		ERR_O => error_x,
		Pulse_I => x1,
		CLK_I => clock
	);

Inst_pulse_counter_Y1: pulse_counter PORT MAP(
		DAT_O => county,
		ERR_O => error_y,
		Pulse_I => y1,
		CLK_I => clock
	);
--phase seq

	process(x1,x2,x3, y1,y2,y3)
	variable xph, yph : std_logic_vector(1 downto 0) := "00";
	begin
		if x1'event and x1='1' then
			xph := x2 & x3;
		end if;
		if y1'event and y1='1' then
			yph := y2 & y3;
		end if;
		if xph=yph then
			phase <= '1';
		else
			phase <= '0';
		end if;
	end process;
	
--comparasion--
	process(countx,county,rst)
	
	variable temp_var, temp : std_logic_vector(63 downto 0);
	begin
		if rst = '1' then freq_temp <= '0';
		else
			--flag1 comes from a component instantiation statement at the top
			temp_var := (countx - county);
			temp := "000000" & countx(63 downto 6); 
			if (temp_var <= temp) then
			freq_temp <= '1';
			else 
			freq_temp <='0';
			end if;
		end if;
	end process;
	freq <= freq_temp and (not error_x) and (not error_y); --rdy is high when division is completed
--voltage--
	voltage <= vcomp;
--instant inphase--
	process(clock) --process to store x1 and y1
	
	begin
		if clock'event and clock ='1' then
			if rst = '1' then
				x1_store <= '0';
				y1_store <= '0';
			else
				x1_store <= x1;
				y1_store <= y1;
			end if;
		end if;
	end process;
--process to create a pulse at positive edge of both x1 and y1	
	process(x1_store, x1, y1_store, y1)
	begin
		posedge_x <= x1 and (not x1_store);
		posedge_y <= y1 and (not y1_store);
	end process;
	
	
	process(phase,freq,voltage,posedge_x, posedge_y,error_x,error_y)
	begin
		inst <= posedge_x and posedge_y and phase and freq and voltage;
	end process;

end Behavioral;
