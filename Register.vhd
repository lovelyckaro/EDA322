library ieee;
use ieee.std_logic_1164.all;

entity gen_register is
  generic(W: integer);
  port(
    aresetn: in std_logic;
    clk: in std_logic;
    input: in std_logic_vector(W-1 downto 0);
    load_enable: in std_logic;
    result: out std_logic_vector(w-1 downto 0)
  );
end gen_register;

architecture behavioral of gen_register is

begin
  process(clk)
  begin
    if (rising_edge(clk) and load_enable='1') then
      result <= input;
    end if;
  end process;
end behavioral;
