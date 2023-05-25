library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- OI: out-reg input (Stores the current values of the bus into output register)

entity outreg is
port(clk,OI: in std_logic;
     data_in: in std_logic_vector(7 downto 0);
     data_out: out std_logic_vector(7 downto 0));
end outreg;

architecture logic of outreg is
signal out_content: std_logic_vector(7 downto 0) := (others => '0');
begin
process(clk)
begin
	if rising_edge(clk) then
		if OI='1' then
			out_content <= data_in;
		end if;
	end if;
end process;
data_out <= out_content;
end logic;