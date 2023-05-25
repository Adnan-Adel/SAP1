library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- CE: Counter Enable (Increments the Program Counter on the next clock cycle)
-- CO: Counter Out (Output is disconnected when CO is low)

entity PC is
port(clk, reset, CE, CO: in std_logic;
     PC_out: out std_logic_vector(3 downto 0));
end PC;

architecture logic of PC is
signal PC_content: std_logic_vector(3 downto 0) := (others => '0');

begin
process(clk, reset)
begin

	if reset = '1' then
		PC_content <= (others => '0');
	elsif rising_edge(clk) then
		if CE = '1' then
			PC_content <= PC_content + 1;
		end if;
	end if;
end process;
PC_out <= PC_content when CO = '1' else (others => 'Z');

end logic;