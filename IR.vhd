library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.STD_LOGIC_ARITH.ALL;
use ieee.STD_LOGIC_UNSIGNED.ALL;

-- II: instruction-reg Input (Writes the current values of the bus into instruction register)
-- IO: instruction-reg Output (Sends the stored data(Only lower nibble) onto the bus)

entity IR is
    Port ( clk : in  std_logic;
           reset : in  std_logic;
           II : in  std_logic;
           IO : in  std_logic;
           instruction_in : in  std_logic_vector (7 downto 0);
           opcode_out : out  std_logic_vector (3 downto 0);
           address_out : out  std_logic_vector (3 downto 0));
end IR;

architecture logic of IR is

signal IR_content : std_logic_vector (7 downto 0) := (others => '0');

begin
process (clk, reset)
begin
	if reset = '0' then
		IR_content <= (others => '0');
	elsif rising_edge(clk) then
		if II = '1' then
			IR_content <= instruction_in;
		end if;
	end if;
end process;
opcode_out <= IR_content(7 downto 4);
address_out <= IR_content(3 downto 0) when IO = '1' else (others => 'Z');

end logic;
