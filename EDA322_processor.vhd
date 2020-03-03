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
    Addr2seg : out  STD_LOGIC_VECTOR (7 downto 0);--Address register
    dMemOut2seg : out  STD_LOGIC_VECTOR (7 downto 0);--Data memory output
    aluOut2seg : out  STD_LOGIC_VECTOR (7 downto 0);--ALU output
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

component mem_array 
  is generic (  
    DATA_WIDTH: integer := 12;
    ADDR_WIDTH: integer := 8;
    INIT_FILE: string := "inst_mem.mif"
  );
  Port (
    ADDR : in  STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
    DATAIN : in STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
    CLK :in STD_LOGIC;
    WE : in STD_LOGIC;
    OUTPUT : out  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
  );
end component;

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

component procController is
    Port ( 	master_load_enable: in STD_LOGIC;
		opcode : in  STD_LOGIC_VECTOR (3 downto 0);
		neq : in STD_LOGIC;
		eq : in STD_LOGIC; 
		CLK : in STD_LOGIC;
		ARESETN : in STD_LOGIC;
		pcSel : out  STD_LOGIC;
		pcLd : out  STD_LOGIC;
		instrLd : out  STD_LOGIC;
		addrMd : out  STD_LOGIC;
		dmWr : out  STD_LOGIC;
		dataLd : out  STD_LOGIC;
		flagLd : out  STD_LOGIC;
		accSel : out  STD_LOGIC;
		accLd : out  STD_LOGIC;
		im2bus : out  STD_LOGIC;
		dmRd : out  STD_LOGIC;
		acc2bus : out  STD_LOGIC;	
		ext2bus : out  STD_LOGIC;
		dispLd: out STD_LOGIC;
		aluMd : out STD_LOGIC_VECTOR(1 downto 0));
end component;


component adder8bit is
port(
      x: in std_logic_vector(7 downto 0);
      y: in std_logic_vector(7 downto 0);
      cin: in std_logic;
      result: out std_logic_vector(7 downto 0);
      cout: out std_logic
);
end component;


component mux2to1 is
generic( W : integer := 8);

port(
      in1: in std_logic_vector(W-1 downto 0);
      in2: in std_logic_vector(W-1 downto 0);
      sel: in std_logic;
      output: out std_logic_vector(W-1 downto 0)
);
end component;
-- Signals
signal InstrMemOut : std_logic_vector(11 downto 0);
signal opcode : std_logic_vector(3 downto 0);
signal addrFromInstruction : std_logic_vector(7 downto 0);
signal addr : std_logic_vector(7 downto 0);
signal instruction : std_logic_vector(11 downto 0);
signal neq : STD_LOGIC;
signal eq : STD_LOGIC; 
signal pcSel : STD_LOGIC;
signal pcLd : STD_LOGIC;
signal instrLd : STD_LOGIC;
signal addrMd : STD_LOGIC;
signal dmWr : STD_LOGIC;
signal dataLd : STD_LOGIC;
signal flagLd : STD_LOGIC;
signal accSel : STD_LOGIC;
signal accLd : STD_LOGIC;
signal im2bus : STD_LOGIC;
signal dmRd : STD_LOGIC;
signal acc2bus : STD_LOGIC;	
signal ext2bus : STD_LOGIC;
signal dispLd: STD_LOGIC;
signal aluMd : STD_LOGIC_VECTOR(1 downto 0);
signal pc : std_logic_vector(7 downto 0);
signal pcIncrOut : std_logic_vector(7 downto 0);

signal instr_In : std_logic_vector(11 downto 0) := "000000000000"; -- Unused, only used to fulfill port map of InstructionMemory
signal instr_We : std_logic := '0'; -- Unused, only used to fulfill port map of InstructionMemory
signal busOut : std_logic_vector(7 downto 0);
signal nxtPc : std_logic_vector(7 downto 0);

signal memDataOut : std_logic_vector(7 downto 0);
signal memDataOutReged : std_logic_vector(7 downto 0);

signal aluOut : std_logic_vector(7 downto 0);
signal flagInp : std_logic_vector(3 downto 0);
signal flagOut : std_logic_vector(3 downto 0);
signal aluOvf : std_logic;
signal aluNEQ : std_logic;
signal aluEQ : std_logic;
signal aluZero : std_logic;
signal outFromAcc : std_logic_vector(7 downto 0);

signal accIn : std_logic_vector(7 downto 0);

begin
  -- Controller
  controller : procController port map (MASTER_LOAD_ENABLE, opcode, neq, eq, CLK, ARESETN, pcSel, pcLd, instrLd, addrMd, dmWr, dataLd, flagLd, accSel, accLd, im2bus, dmRd, acc2bus, ext2bus, dispLd, aluMd);

  -- Instruction memory, signals and register
  opcode <= instruction(11 downto 8);
  addrFromInstruction <= instruction(7 downto 0);
  instr2seg <= instruction;
  InstructionMemory : mem_array generic map(DATA_WIDTH => 12, ADDR_WIDTH => 8, INIT_FILE => "inst_mem.mif") port map (pc, instr_In, CLK, instr_We, InstrMemOut);
  pc2seg <= pc;

  PCincr : adder8bit port map (pc, "00000000", '1', pcIncrOut, open); 
  pcMux : mux2to1 generic map (W => 8) port map (pcIncrOut, busOut, pcSel, nxtPc);
  FE : gen_register generic map (W => 8) port map (ARESETN, CLK, nxtPc, pcLd, pc); 

  FEDE : gen_register generic map (W => 12) port map (ARESETN, CLK, InstrMemOut, instrLd, instruction); 
  -- DataMemory and co.
  Addr2Seg <= addr;
  dataMux : mux2to1 generic map (W => 8) port map(addrFromInstruction, memDataOutReged, addrMd, Addr);
  DataMemory : mem_array generic map(DATA_WIDTH => 8, ADDR_WIDTH => 8, INIT_FILE => "data_mem.mif") port map (addr, busOut, CLK, dmWr, MemDataOut);
  DEEX : gen_register generic map (W => 8) port map (ARESETN, CLK, MemDataOut, dataLd, memDataOutReged);
  dMemOut2Seg <= memDataOutReged;

  -- ALU and co.
  aluOut2Seg <= aluOut;
  flagInp <= aluOvf & aluNEQ & aluEQ & aluZero;
  ALU : alu_wRCA port map (OutFromAcc, BusOut, aluMd, aluOut, aluOvf, aluNEQ, aluEQ, aluZero);
  FReg : gen_register generic map (W => 4) port map (ARESETN, CLK, FlagInp, flagLd, flagOut);
  flag2seg <= flagOut;  
  neq <= flagOut(2);
  eq <= flagOut(1);

  -- ACC and co.
  accMux : mux2to1 generic map (W => 8) port map (aluOut, busOut, accSel, AccIn);
  ACC : gen_register generic map (W => 8) port map (ARESETN, CLK, AccIn, accLd, outFromAcc);
  acc2seg <= outFromAcc;
  Display : gen_register generic map (W => 8) port map (ARESETN, CLK, outFromAcc, dispLd, disp2seg);

  -- Bus
  iBus : procBus port map (addrFromInstruction, memDataOutReged, outFromAcc, externalIn, busOut, errSig2seg, im2bus, dmRd, acc2bus, ext2bus );
  busOut2Seg <= busOut;
end hellifiknow;

