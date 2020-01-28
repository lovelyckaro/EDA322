library ieee;
use ieee.std_logic_1164.all;

entity adder8bit is
port(
      x: in std_logic_vector(7 downto 0);
      y: in std_logic_vector(7 downto 0);
      cin: in std_logic;
      result: out std_logic_vector(7 downto 0);
      cout: out std_logic
);
end adder8bit;

architecture structural of adder8bit is

component fullAdder is
port(
      x: in std_logic;
      y: in std_logic;
      cin: in std_logic;
      result: out std_logic;
      cout: out std_logic
);
end component;

signal cmid : std_logic_vector(8 downto 0);

begin
  cmid(0) <= cin;
  cout <= cmid(8);
  Adders: for i in 0 to 7 generate
    ADDi:  fullAdder port map(x(i), y(i), cmid(i), result(i), cmid(i+1));
  end generate Adders;
  
end structural;