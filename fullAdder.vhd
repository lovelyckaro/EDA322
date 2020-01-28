library ieee;
use ieee.std_logic_1164.all;

entity fullAdder is
port(
      x: in std_logic;
      y: in std_logic;
      cin: in std_logic;
      result: out std_logic;
      cout: out std_logic
);
end fullAdder;

architecture dataflow of fullAdder is
begin
  result <= cin xor (x xor y);
  cout <= (cin and (x xor y)) or (x and y);
end dataflow;