library ieee;
use ieee.std_logic_1164.all;

entity mux4to1 is
port(
      input: in std_logic_vector(3 downto 0);
      sel: in std_logic_vector(1 downto 0);
      output: out std_logic
);
end mux4to1;

architecture behavior of mux4to1 is
signal mid0, mid1 : std_logic;

begin
  mux0: entity work.mux2to1 port map(input(0), input(1), sel(0), mid0);
  mux1: entity work.mux2to1 port map(input(2), input(3), sel(0), mid1);
  mux2: entity work.mux2to1 port map(mid0, mid1, sel(1), output);
end behavior;