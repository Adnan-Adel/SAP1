library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- RO: Ram Out (Put the currently selected RAM byte onto the bus. Output is disconnected when RO is low)	

entity MEM is
	port(RO: in std_logic;
	     addr_in: in std_logic_vector(3 downto 0);
	     --data_in: in std_logic_vector(7 downto 0);
	     data_out: out std_logic_vector(7 downto 0));
end MEM;

architecture logic of MEM is

type MEM_t is array (0 to 15 ) of std_logic_vector(7 downto 0);
constant ram_data: MEM_t:=(
    -- Ex program			Address				program
    "00001001",  -- LDA 9H		0000(0H)			0000 1001
    "00011010",  -- ADD AH		0001(1H)			0001 1010
    "00011011",  -- ADD BH		0010(2H)			0001 1011
    "00101100",  -- SUB CH		0011(3H)			0010 1100
    "11100000",  -- OUT   		0100(4H)			0011 0000
    "11110000",  -- HLT   		0101(5H)			1111 0000
    "00011010",  --			0110(6H)
    "00101110",  --			0111(7H)
    "00111100",  --			1000(8H)
    "00011010",  -- data: 1AH		1001(9H)
    "00101110",  -- data: 2EH		1010(AH)
    "00111100",  -- data: 3CH		1011(BH)
    "00111111",  -- data: 3FH		1100(CH)
    "00111110",  --			1101(DH)
    "00111110",  --  			1110(EH) 
    "00000000" 	 --			1111(FH)
  ); 


signal temp : std_logic_vector (7 downto 0) := (others => '0');

begin
  process(RO)
  begin
      if (RO = '1') then
        temp <= ram_data(conv_integer(unsigned(addr_in)));
      else
        temp <= (others => 'Z');
      end if;
  end process;

data_out <= temp;

end logic;