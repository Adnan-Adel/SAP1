library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SAP1 is
    Port ( clk : in  std_logic;
           clr : in  std_logic;
           sap_out : out  std_logic_vector (7 downto 0));
end SAP1;
	
architecture logic of SAP1 is

--------------------------- Component Declaration ---------------------------

component ALU is
    Port ( datain_a : IN  STD_LOGIC_VECTOR (7 downto 0);
           datain_b : IN  STD_LOGIC_VECTOR (7 downto 0);
	   SU : IN STD_LOGIC;
	   EO : IN STD_LOGIC;
           dataout : OUT  STD_LOGIC_VECTOR (7 downto 0)
	  );
end component;

component AC is
	Port(AI, clk, AO: IN STD_LOGIC;
	     datain: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	     dataout_to_bus: OUT STD_LOGIC_VECTOR(7 DOWNTO 0); 		
	     dataout_to_ALU: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	     );
end component;

component controller is
   	port(clk,clr: IN STD_LOGIC;
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
end component;

component out_reg is
	port(clk,OI: in std_logic;
     	     data_in: in std_logic_vector(7 downto 0);
     	     data_out: out std_logic_vector(7 downto 0));
end component;

component B_reg is
	port(clk,BI: in std_logic;
             data_in: in std_logic_vector(7 downto 0);
     	     data_to_ALU: out std_logic_vector(7 downto 0));
end component;

component PC is
	port(clk, reset, CE, CO: in std_logic;
    	     PC_out: out std_logic_vector(3 downto 0));
end component;

component IR is
    	Port(clk : in  std_logic;
             reset : in  std_logic;
             II : in  std_logic;
             IO : in  std_logic;
             instruction_in : in  std_logic_vector (7 downto 0);
             opcode_out : out  std_logic_vector (3 downto 0);
             address_out : out  std_logic_vector (3 downto 0));
end component;

component MAR is
    	Port(clk : in  std_logic;
             MI : in  std_logic;
             address_in : in  std_logic_vector (3 downto 0);
             address_out : out  std_logic_vector (3 downto 0));
end component;

component MEM is
	port(RO: in std_logic;
	     addr_in: in std_logic_vector(3 downto 0);
	     --data_in: in std_logic_vector(7 downto 0);
	     data_out: out std_logic_vector(7 downto 0));
end component;

--------------------------- Intermediate Signal Declaration ---------------------------
--signal control_sig : std_logic_vector(7 downto 0);
signal OI	: std_logic := '0';
signal BI	: std_logic := '0';
signal EO	: std_logic := '0';
signal SU	: std_logic := '0';
signal AO	: std_logic := '0';
signal AI	: std_logic := '0';
signal IO	: std_logic := '0';
signal II	: std_logic := '0';
signal RO	: std_logic := '0';
signal MI	: std_logic := '0';
signal CO	: std_logic := '0';
signal CE	: std_logic := '0';
signal HLT 	: std_logic := '1';


signal mar_to_ram    	: std_logic_vector ( 3 downto 0);
signal ir_to_controller : std_logic_vector ( 3 downto 0);
signal acc_to_alu 	: std_logic_vector ( 7 downto 0);
signal breg_to_alu      : std_logic_vector ( 7 downto 0);
signal bus_sig      	: std_logic_vector(7 downto 0);
signal active_clk 	: STD_LOGIC :=  clk;

begin
active_clk <= HLT and clk;
--------------------------- Component Instantiation ---------------------------

S_ACC: AC port map (
	AI            		=> AI,
        AO            		=> AO,
        clk           		=> active_clk,
	datain			=> bus_sig,
        dataout_to_bus          => bus_sig,
        dataout_to_ALU 		=> acc_to_alu
);

S_BReg: B_Reg port map (
	BI            		=> BI,
        clk           		=> active_clk,
        data_in         	=> bus_sig,
        data_to_ALU 		=> breg_to_alu
);

S_OutReg: out_reg port map (
	OI            		=> OI,
        clk           		=> active_clk,
        data_in         	=> bus_sig,
        data_out 		=> sap_out
);

S_PC: PC port map (
	CE            		=> CE,
	CO            		=> CO,
        clk           		=> active_clk,
	reset            	=> clr,
        PC_out 			=> bus_sig(3 downto 0)
);

S_ALU: ALU port map (
	SU            		=> SU,
	EO            		=> EO,
	datain_a		=> acc_to_alu,
	datain_b		=> breg_to_alu,
        dataout 		=> bus_sig
);

S_MAR: MAR port map (
	MI            		=> MI,
	clk           		=> active_clk,
	address_in		=> bus_sig(3 downto 0),
	address_out		=> mar_to_ram
);

S_IR: IR port map (
	II            		=> II,
	IO            		=> IO,
	clk           		=> active_clk,
	reset			=> clr,
	instruction_in		=> bus_sig,
	opcode_out		=> ir_to_controller,
	address_out		=> bus_sig(3 downto 0)
);

S_MEM: MEM port map (
	RO            		=> RO,
	addr_in			=> mar_to_ram,
	--data_in			=> ir_to_controller,
	data_out		=> bus_sig
);

S_Controller: Controller port map (
	clk           		=> active_clk,
	clr           		=> clr,
	IR_in			=> ir_to_controller,

	CE            		=> CE,
	CO            		=> CO,
	MI            		=> MI,
	RO            		=> RO,
	II            		=> II,
	IO            		=> IO,
	AI            		=> AI,
	AO            		=> AO,
	SU            		=> SU,
	EO            		=> EO,
	BI            		=> BI,
	OI            		=> OI,
	HLT			=> HLT
);


end logic;

