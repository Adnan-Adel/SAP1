LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

-----------------------------------------------------------------------------------------------------------------------------
-- T0	 Address State	     MAR <- PC  	   (CO, MI)
-- T1	 Increment State     PC <- PC+1   	   (CE)
-- T2	 Memory State  	     IR <- M[MAR]          (RO, II)  

-- Operation:  LDA		      ADD	  			SUB	  			OUT	  		        
-- T3	       MAR <- IR(0 - 3)	      MAR <- IR(0 - 3) 		   	MAR <- IR(0 - 3)		Out-reg <- AC
-- T4	       AC <- M[MAR]	      B-reg <- M[MAR]   	  	B-reg <- M[MAR]			No Operation	
-- T5	       No Operation	      AC <- AC + B-reg			AC <- AC - B-reg	        No Operation

-- Mnemonic	 Opcode
--  LDA		 0000
--  ADD		 0001
--  SUB		 0010
--  OUT  	 0011
--  HLT		 1111
-----------------------------------------------------------------------------------------------------------------------------


ENTITY controller IS
   PORT(clk,clr: IN STD_LOGIC;
     	IR_in: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
     	CE: OUT STD_LOGIC;
	CO: OUT STD_LOGIC;
	MI: OUT STD_LOGIC;
	RO: OUT STD_LOGIC;
	II: OUT STD_LOGIC;
	IO: OUT STD_LOGIC;
	AI: OUT STD_LOGIC;
	AO: OUT STD_LOGIC;
	SU: OUT STD_LOGIC;
	EO: OUT STD_LOGIC;
	BI: OUT STD_LOGIC;
	OI: OUT STD_LOGIC;
        HLT: OUT STD_LOGIC);
END controller;

ARCHITECTURE logic of controller IS

TYPE T_state IS (idle, T0, T1, T2, T3, T4, T5);
signal current_state, next_state : T_state := T0;
signal ctrl_signal : STD_LOGIC_VECTOR(11 DOWNTO 0) := (others => '0');
signal HLT_signal : STD_LOGIC := '1';

begin

process(clk, clr)
begin
	if clr= '0' then
		current_state <= idle;
	elsif rising_edge(clk) then
		current_state <= next_state;
	end if;
end process;

-- CE CO MI RO II IO AI AO SU EO BI OI
-- 11 10 09 08 07 06 05 04 03 02 01 00

process(current_state)
begin
	case current_state is
		when idle =>  --DO Nothing
			ctrl_signal <= "000000000000";
			HLT_signal <= '1';
			next_state <= T0;

		when T0 =>  -- Fetch Address
			-- Enable PC output (CO = 1), Enable input of MAR (MI = 1)
			ctrl_signal <= (9=>'1', 10=>'1', others=>'0');
			next_state <= T1;

		when T1 =>  -- Incremen Program Counter
			-- CE = 1
			ctrl_signal <= (11=>'1', others=>'0');
			next_state <= T2;

		when T2 =>  -- Load Instruction From Memory
			-- Enable mem out (RO = 1), Enable input of IR (II = 1)
			ctrl_signal <= (7=>'1', 8=>'1', others=>'0');
			next_state <= T3;

		when T3 =>  
			-- OUT Instruction
			if IR_in = "0011" then  				
				ctrl_signal <= (0=>'1', 4=>'1', others=>'0');   -- Output of ACC (AO = 1) and Output Register Input (OI = 1)
			-- HLT Instruction
			elsif IR_in = "1111" then 				
				ctrl_signal <= "000000000000";			
				HLT_signal <= '0';
			-- Others (LDA, Add or Sub)
			else							
				ctrl_signal <= (6=>'1', 9=>'1', others=>'0');   -- Output IR (IO = 1) and MAR Input (MI = 1)
			end if;
			next_state <= T4;

		when T4 =>
			-- LDA Instruction
			if IR_in = "0000" then  				
				ctrl_signal <= (5=>'1', 8=>'1', others=>'0');   -- Output Mem (RO = 1) and ACC Input (AI = 1)
			-- ADD Instruction
			elsif IR_in = "0001" then 				
				ctrl_signal <= (1=>'1', 8=>'1', others=>'0');   -- Output Mem (RO = 1) and B-reg Input (BI = 1)
			-- SUB Instruction
			elsif IR_in = "0010" then 				
				ctrl_signal <= (1=>'1', 8=>'1', others=>'0');   -- Output Mem (RO = 1) and B-reg Input (BI = 1)
			-- Others (LDA, Add or Sub)
			else							
				ctrl_signal <= "000000000000";
			end if;
			next_state <= T5;

		when T5 =>
			-- ADD Instruction
			if IR_in = "0001" then  				
				ctrl_signal <= (2=>'1', 5=>'1', others=>'0');   	-- ALU Output (EO = 1) and ACC Input (AI = 1)
			-- SUB Instruction
			elsif IR_in = "0010" then 				
				ctrl_signal <= (2=>'1', 5=>'1', 3=>'1', others=>'0');    -- ALU Output (EO = 1, SU= 1) and ACC Input (AI = 1)
			-- Others
			else							
				ctrl_signal <= "000000000000";
			end if;
			next_state <= T0;
	end case;
end process;

	OI <= ctrl_signal(0);
	BI <= ctrl_signal(1);
	EO <= ctrl_signal(2);
	SU <= ctrl_signal(3);
	AO <= ctrl_signal(4);
	AI <= ctrl_signal(5);
	IO <= ctrl_signal(6);
	II <= ctrl_signal(7);
	RO <= ctrl_signal(8);
	MI <= ctrl_signal(9);
	CO <= ctrl_signal(10);
	CE <= ctrl_signal(11);
	HLT <= HLT_signal;
end logic;























