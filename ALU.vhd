library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Su: Addition/Subtraction Select 
--	When SU= 0, addition operation
--	When SU= 1, subtraction operation

-- EO: ALU out (Puts the ALU output onto the bus)

ENTITY ALU is
    PORT ( datain_a : IN  STD_LOGIC_VECTOR (7 downto 0);
           datain_b : IN  STD_LOGIC_VECTOR (7 downto 0);
	   SU : IN STD_LOGIC;
	   EO : IN STD_LOGIC;
           dataout : OUT  STD_LOGIC_VECTOR (7 downto 0)
	  );
END ALU;

ARCHITECTURE logic OF ALU IS

BEGIN

dataout <= datain_a + datain_b WHEN EO = '1' and Su = '0' ELSE
	   datain_a - datain_b WHEN EO = '1' and Su = '1' ELSE
           (others => 'Z');
END logic;
