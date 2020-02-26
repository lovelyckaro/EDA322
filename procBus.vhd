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

signal combinedSelect : STD_LOGIC_VECTOR(1 downto 0);

begin
  combiner: selCombiner port map(instrSEL, dataSEL, accSEL, extdataSEL, combinedSelect, Err);
  with combinedSelect select OUTPUT <=
    INSTRUCTION when "00",
    DATA        when "01",
    ACC         when "10",
    EXTDATA     when others;
end bajs;