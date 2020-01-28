library ieee;
use ieee.std_logic_1164.all;

entity cmp is
port(
      x: in std_logic_vector(7 downto 0);
      y: in std_logic_vector(7 downto 0);
      EQ: out std_logic;
      NEQ: out std_logic
);
end cmp;

architecture structural of cmp is

component adder8bit is
port(
      x: in std_logic_vector(7 downto 0);
      y: in std_logic_vector(7 downto 0);
      cin: in std_logic;
      result: out std_logic_vector(7 downto 0);
      cout: out std_logic
);
end component;

signal negY, res : std_logic_vector(7 downto 0); 
signal overflow, tmp : std_logic;

begin
  negY <= not y;
  Adder: adder8bit port map(x, negY, '1', res, overflow);
  tmp <= ((res(0) or res(1)) or (res(2) or res(3))) or ((res(4) or res(5)) or (res(6) or res(7)));
  NEQ <= tmp;
  EQ <= not tmp;


end structural;