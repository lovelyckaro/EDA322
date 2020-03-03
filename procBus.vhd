library ieee;
use ieee.std_logic_1164.all;

entity procBus is
  Port ( 
    INSTRUCTION : in  STD_LOGIC_VECTOR (7 downto 0);
    DATA : in  STD_LOGIC_VECTOR (7 downto 0);
    ACC : in  STD_LOGIC_VECTOR (7 downto 0);
    EXTDATA :in  STD_LOGIC_VECTOR (7 downto 0);
    OUTPUT : out  STD_LOGIC_VECTOR (7 downto 0);
    ERR : out  STD_LOGIC;
    instrSEL : in  STD_LOGIC;
    dataSEL : in  STD_LOGIC;
    accSEL : in  STD_LOGIC;
    extdataSEL :in  STD_LOGIC
  );
end procBus;

architecture bajs of procBus is
component selCombiner is
  port(
    instrSEL : in  STD_LOGIC;
    dataSEL : in  STD_LOGIC;
    accSEL : in  STD_LOGIC;
    extdataSEL : in  STD_LOGIC;
    combinedSel : out STD_LOGIC_VECTOR(1 downto 0);  
    Err : out STD_LOGIC
  );
end component;

signal combinedSelect : STD_LOGIC_VECTOR(3 downto 0);
signal zeroes : std_logic_vector(7 downto 0);

begin
  combinedSelect <= instrSEL & dataSEL & accSEL & extdataSEL;
  zeroes <= (others => '0');

  with combinedSelect select OUTPUT <=
    INSTRUCTION when "1000",
    DATA        when "0100",
    ACC         when "0010",
    EXTDATA     when "0001",
    zeroes      when others;

  with combinedSelect select Err <=
    '0' when "1000",
    '0' when "0100",
    '0' when "0010",
    '0' when "0001",
    '0' when "0000",
    '1' when others;
end bajs;