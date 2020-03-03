library ieee;
use ieee.std_logic_1164.all;

entity mux4to1 is
generic(W : integer := 8);
port(
      input0 : in std_logic_vector(W-1 downto 0);
      input1 : in std_logic_vector(W-1 downto 0);
      input2 : in std_logic_vector(W-1 downto 0);
      input3 : in std_logic_vector(W-1 downto 0);
      sel: in std_logic_vector(1 downto 0);
      output: out std_logic_vector(W-1 downto 0)
);
end mux4to1;

architecture behavior of mux4to1 is
signal mid0, mid1 : std_logic_vector(W-1 downto 0);

begin
  mux0: entity work.mux2to1 port map(input0, input1, sel(0), mid0);
  mux1: entity work.mux2to1 port map(input2, input3, sel(0), mid1);
  mux2: entity work.mux2to1 port map(mid0, mid1, sel(1), output);
end behavior;