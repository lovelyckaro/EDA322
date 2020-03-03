library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
generic( W : integer := 8);

port(
      in1: in std_logic_vector(W-1 downto 0);
      in2: in std_logic_vector(W-1 downto 0);
      sel: in std_logic;
      output: out std_logic_vector(W-1 downto 0)
);
end mux2to1;

architecture beh of mux2to1 is
begin
  with sel select output <=
    in1 when '0',
    in2 when others;
end beh;
