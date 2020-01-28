library ieee;
use ieee.std_logic_1164.all;

entity alu_wRCA is
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
end alu_wRCA;

architecture dataflow of alu_wRCA is

component adder8bit is
port(
      x: in std_logic_vector(7 downto 0);
      y: in std_logic_vector(7 downto 0);
      cin: in std_logic;
      result: out std_logic_vector(7 downto 0);
      cout: out std_logic
);
end component;

component cmp is
port(
      x: in std_logic_vector(7 downto 0);
      y: in std_logic_vector(7 downto 0);
      EQ: out std_logic;
      NEQ: out std_logic
);
end component;

signal andRes, notRes, adderRes, notB, inB, outRes : std_logic_vector(7 downto 0);
signal carryIn : std_logic;

begin
  andRes <= ALU_inA and ALU_inB;
  notRes <= not ALU_inA;

  cmper: cmp port map(ALU_inA, ALU_inB, Eq, NotEq);
  
  notB <= not ALU_inB;
  Adder: adder8bit port map(ALU_inA, inB, carryIn, adderRes, Carry);

  with Operation select inB <=
    notB when "01",
    ALU_inB when others;

  with Operation select carryIn <=
    '1' when "01",
    '0' when others;

  with Operation select outRes <=
    adderRes when "00",
    adderRes when "01",
    andRes   when "10",
    notRes   when others;

  isOutZero <= not (((outRes(0) or outRes(1)) or (outRes(2) or outRes(3))) or ((outRes(4) or outRes(5)) or (outRes(6) or outRes(7))));
  ALU_out <= outRes;

end dataflow;
