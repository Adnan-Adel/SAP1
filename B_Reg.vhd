library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- BI: B-reg input (Stores the current values of bus into B reg)

entity B_reg is
port(clk,BI: in std_logic;
     data_in: in std_logic_vector(7 downto 0);
     data_to_ALU: out std_logic_vector(7 downto 0));
end B_reg;

architecture logic of B_reg is
signal B_content: std_logic_vector(7 downto 0) := (others => '0');

begin
process(clk)
begin
	if rising_edge(clk) then
		if BI = '1' then
			B_content <= data_in;
		end if;
	end if;
end process;
data_to_ALU <= B_content;

end logic;
