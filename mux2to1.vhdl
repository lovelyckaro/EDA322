library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
port(
      in1: in std_logic;
      in2: in std_logic;
      sel: in std_logic;
      output: out std_logic
);
end mux2to1;

architecture beh of mux2to1 is
begin
  with sel select output <=
    in1 when '0',
    in2 when others;
end beh;
