library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- MI: memory-address-reg input (Stores the current values of the bus into the memory address register)

entity MAR is
    Port ( clk : in  std_logic;
           MI : in  std_logic;
           address_in : in  std_logic_vector (3 downto 0);
           address_out : out  std_logic_vector (3 downto 0));
end MAR;	

architecture logic of MAR is
signal MAR_content: std_logic_vector (3 downto 0) := (others => '0');
begin
process(clk)
begin
	if rising_edge(clk) then
		if MI='1' then
			MAR_content <= address_in;
		end if;
	end if;
end process;
address_out <= MAR_content;

end logic;