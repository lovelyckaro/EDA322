library ieee;
use ieee.std_logic_1164.all;

entity selCombiner is
  port(
    instrSEL : in  STD_LOGIC;
    dataSEL : in  STD_LOGIC;
    accSEL : in  STD_LOGIC;
    extdataSEL : in  STD_LOGIC;
    combinedSel : out STD_LOGIC_VECTOR(1 downto 0);  
    Err : out STD_LOGIC
  );
end selCombiner;

architecture behavioral of selCombiner is
begin
  with std_logic_vector'(instrSEL & dataSEL & accSEL & extdataSEL) select combinedSel <=
    "00" when "1000",
    "01" when "0100",
    "10" when "0010",
    "11" when others;
  with std_logic_vector'(instrSEL & dataSEL & accSEL & extdataSEL) select Err <=
    '0' when "1000",
    '0' when "0100",
    '0' when "0010",
    '0' when "0001",
    '1' when others;
end behavioral;