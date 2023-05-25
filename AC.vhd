library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- AI: Accumulator Input (Stores the current value of bus into ACC)
-- AO: Accumulator Output (Accumulator sends its stored content to the bus)

ENTITY AC IS
	PORT(AI, clk, AO: IN STD_LOGIC;
	     datain: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	     dataout_to_bus: OUT STD_LOGIC_VECTOR(7 DOWNTO 0); 		
	     dataout_to_ALU: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	     );
END AC;

ARCHITECTURE logic OF AC IS

SIGNAL AC_content : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
PROCESS(clk)
BEGIN
	IF rising_edge(clk) THEN
		IF AI = '1' THEN
			AC_content <= datain;
		END IF;
	END IF;
END PROCESS;

dataout_to_ALU <= AC_content;
dataout_to_bus <= AC_content WHEN AO = '1' ELSE (others => 'Z');

END logic;		
