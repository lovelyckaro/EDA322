library ieee;
use ieee.std_logic_1164.all;

entity EDA322_processor is
  Port ( 
    externalIn : in  STD_LOGIC_VECTOR (7 downto 0);--?extIn? in Figure 1
    CLK : in STD_LOGIC;
    master_load_enable: in STD_LOGIC;
    ARESETN: in STD_LOGIC;
    pc2seg :out  STD_LOGIC_VECTOR (7 downto 0);--PC  
    instr2seg : out  STD_LOGIC_VECTOR (11 downto 0);--Instruction register
    Addr2seg : out  STD_LOGIC_VECTOR (7 downto 0);--Address registerd
    MemOut2seg : out  STD_LOGIC_VECTOR (7 downto 0);--Data memory outputalu
    Out2seg : out  STD_LOGIC_VECTOR (7 downto 0);--ALU output
    acc2seg : out  STD_LOGIC_VECTOR (7 downto 0);--Accumulator
    flag2seg : out  STD_LOGIC_VECTOR (3 downto 0);--Flags
    busOut2seg : out  STD_LOGIC_VECTOR (7 downto 0);--Value on the bus
    disp2seg: out STD_LOGIC_VECTOR(7 downto 0);--Display register
    errSig2seg : out STD_LOGIC;--Bus Error signal
    ovf : out STD_LOGIC;--Overflow 
    zero : out STD_LOGIC--zero
  );
end EDA322_processor;

architecture hellifiknow of EDA322_processor is
component procBus is
  Port ( 
    INSTRUCTION : in  STD_LOGIC_VECTOR (7 downto 0);
    DATA : in  STD_LOGIC_VECTOR (7 downto 0);
    ACC : in  STD_LOGIC_VECTOR (7 downto 0);
    EXTDATA :in  STD_LOGIC_VECTOR (7 downto 0);
    OUTPUT : out  STD_LOGIC_VECTOR (7 downto 0);
    ERR : out  STD_LOGIC;
    instrSEL : in  STD_LOGIC;
    dataSEL : in  STD_LOGIC;
    accSEL : in  STD_LOGIC;
    extdataSEL :in  STD_LOGIC
  );
end component;

component alu_wRCA is
port(
      ALU_inA: in std_logic_vector(7 downto 0 );
      ALU_inB: in std_logic_vector(7 downto 0 );
      Operation: in std_logic_vector(1 downto 0);
      ALU_out: out std_logic_vector(7 downto 0);
      Carry: out std_logic;
      NotEq: out std_logic;
      Eq: out std_logic;
      isOutZero: out std_logic
);
end component;

component mem_array is 
component gen_register is
  generic(W: integer);
  port(
    aresetn: in std_logic;
    clk: in std_logic;
    input: in std_logic_vector(W-1 downto 0);
    load_enable: in std_logic;
    result: out std_logic_vector(w-1 downto 0)
  );
end component;
begin
  FEDE : gen_register generic map (W => ) 
  iBus : procBus port map()

end hellifiknow;

