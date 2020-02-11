library ieee;
use ieee.std_logic_1164.all;

entity register8bit is
  port(
    aresetn: in std_logic;
    clk: in std_logic;
    input: in std_logic_vector(7 downto 0);
    load_enable: in std_logic;
    result: out std_logic_vector(7 downto 0)
  );
end register8bit;

architecture behavioral of register8bit is 
component gen_register is
  generic(W: integer);
  port(
    aresetn: in std_logic;
    clk: in std_logic;
    input: in std_logic_vector(W-1 downto 0);
    load_enable: in std_logic;
    result: out std_logic_vector(w-1 downto 0)
  );
end component gen_register;

begin
  reg: component gen_register generic map (W => 8) port map (aresetn, clk, input, load_enable, result);
end behavioral;
