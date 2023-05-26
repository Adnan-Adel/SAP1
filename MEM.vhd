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
    "00110000",  -- OUT	  		0001(1H)			0011 0000
    "00011010",  -- ADD AH		0001(2H)			0001 1010
    "00110000",  -- OUT	  		0001(3H)			0011 0000
    "00011011",  -- ADD BH		0011(4H)			0001 1011
    "00101011",  -- SUB CH		0100(5H)			0010 1100
    "00110000",  -- OUT   		0101(6H)			0011 0000
    "11110000",  -- HLT   		0110(7H)			1111 0000
    "00011010",  --			0111(8H)
    "00101110",  -- data: 2EH		1000(9H)
    "00111100",  -- data: 3CH		1001(AH)
    "00011010",  -- data: 1AH		1010(BH)
    "00101110",  -- data: 2EH		1011(CH)
    "00111100",  -- data: 3CH		1100(DH)
    "00111111",  -- data: 3FH		1101(EH)
    "00111110"   --			1110(FH)
  ); 


begin

data_out <= ram_data(conv_integer(unsigned(addr_in))) when RO = '1' else (others => 'Z');



end logic;