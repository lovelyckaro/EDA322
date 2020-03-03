library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity procController is
    Port (
	master_load_enable: in STD_LOGIC;
	opcode : in  STD_LOGIC_VECTOR (3 downto 0);
	neq : in STD_LOGIC;
	eq : in STD_LOGIC; 
	CLK : in STD_LOGIC;
	ARESETN : in STD_LOGIC;
	pcSel : out  STD_LOGIC;
	pcLd : out  STD_LOGIC;
	instrLd : out  STD_LOGIC;
	addrMd : out  STD_LOGIC;
	dmWr : out  STD_LOGIC;
	dataLd : out  STD_LOGIC;
	flagLd : out  STD_LOGIC;
	accSel : out  STD_LOGIC;
	accLd : out  STD_LOGIC;
	im2bus : out  STD_LOGIC;
	dmRd : out  STD_LOGIC;
	acc2bus : out  STD_LOGIC;
	ext2bus : out  STD_LOGIC;
	dispLd: out STD_LOGIC;
	aluMd : out STD_LOGIC_VECTOR(1 downto 0));
end procController;

architecture Behavioral of procController is
type state_type is (FE, DE, DE2, EX, ME);

signal current_state : state_type := FE;
signal next_state : state_type;

begin

-- switching between states

fsm : process(CLK, ARESETN)
begin 
-- if reset start over at FE
if (ARESETN = '0') then
  current_state <= FE;
-- on the clocks rising edge switch to next state
elsif (rising_edge(CLK) and master_load_enable = '1') then
  current_state <= next_state;
-- reset all outputs for the next state to set them
  pcSel <= '0';
  pcLd  <= '0';
  instrLd <= '0';
  addrMd <= '0';
  dmWr <= '0';
  dataLd <= '0';
  flagLd <= '0';
  accSel <= '0';
  accLd <= '0';
  im2bus <= '0';
  dmRd <= '0';
  acc2bus <= '0';
  ext2bus <= '0';
  dispLd <= '0';
  
end if;
end process;

-- determening the next state 

next_state_process : process(current_state, opcode)
begin
-- if at FE always go to DE
if (current_state = FE) then
  next_state <= DE;
-- if at DE and opcode is ADX, LBX or SBX goto DE2
elsif (current_state = DE and (opcode = "1000" or opcode = "1001" or opcode = "1010")) then
  next_state <= DE2;
-- if at DE and opcode is SB goto ME
elsif (current_state = DE and (opcode = "0111")) then
  next_state <= ME;
-- if at DE and opcode is IN, J, JEQ or JNE goto FE
elsif (current_state = DE and (opcode = "1011" or opcode = "1100" or opcode = "1101" or opcode = "1110")) then
  next_state <= FE;
-- if at DE and opcode is anything that hasn't been tested yet, go to EX
elsif (current_state = DE) then 
  next_state <= EX;
-- if at DE2 and b1 = 0 goto EX
elsif (current_state = DE2 and (opcode(1) = '0')) then
  next_state <= EX;
-- if at DE2 and b1 = 1 goto ME 
elsif (current_state = DE2) then
  next_state <= ME;
-- else, we are at a final state and need to wrap around to FE
elsif (current_state = EX or current_state = ME) then
  next_state <= FE;
end if;
end process;

-- setting the output signals

-- instrLd is always 1
instrLd <= '1';



-- outputs that depend on the current state, and/or neq/eq
output_signal_process : process(current_state, opcode, neq, eq)
begin
if (not (current_state = FE)) then
-- Setting ALU mode, Sub -> "01", not -> "11", and -> "10", all others "00"or dont care
with opcode select aluMD <=
  "01" when "0010",
  "11" when "0011",
  "10" when "0001",
  "00" when others;

-- im2bus
with opcode select im2bus <=
  '1' when "1100",
  '1' when "1101",
  '1' when "1110",
  '0' when others;

-- acc2bus
with opcode select acc2bus <=
  '1' when "0111",
  '1' when "1010",
  '0' when others;

-- ext2bus
with opcode select ext2bus <=
  '1' when "1011",
  '0' when others;
end if;

case (opcode) is
--   NOP   | Add  | Sub  | Not  | And  : These all share control signals, except for aluMd 
when "0000"|"0001"|"0010"|"0011"|"0100" =>
  pcSel <= '0';
  addrMd <= '0';
  dmWr <= '0';
  accSel <= '0';
  dispLd <= '0';
  if (current_state = EX) then
    flagLd <= '1';
    pcLd <= '1';
    accLd <= '1';
    dmRd <= '1';
  elsif (current_state = DE) then
    dataLd <= '1';
  end if;
 
-- Cmp
when "0101" =>
  pcSel <= '0';
  addrMd <= '0';
  dmWr <= '0';
  accSel <= '0';
  dispLd <= '0';
  accLd <= '0';
  if (current_state = EX) then
    flagLd <= '1';
    pcLd <= '1';
    dmRd <= '1';
  elsif (current_state = DE) then
    dataLd <= '1';
  end if;

-- Lb
when "0110" =>
  pcSel <= '0';
  addrMd <= '0';
  dmWr <= '0';
  flagLd <= '0';
  dispLd <= '0';
  if (current_state = EX) then
    pcLd <= '1';
    accSel <= '1';
    accLd <= '1';
    dmRd <= '1';
  elsif (current_state = DE) then
    dataLd <= '1';
  end if;

-- Sb
when "0111" =>
  pcSel <= '0';
  addrMd <= '0';
  dataLd <= '0';
  flagLd <= '0';
  accSel <= '0';
  accLd <= '0';
  dmRd <= '0';
  dispLd <= '0';
  if (current_state = ME) then
    pcLd <= '1';
    dmWr <= '1';
  end if;

-- ADX
when "1000" =>
  pcSel <= '0';
  dmWr <= '0';
  accSel <= '0';
  dispLd <= '0';
  if (current_state = DE) then
    dataLd <= '1';
  elsif (current_state = DE2) then
    dataLd <= '1';
    addrmd <= '1';
  elsif (current_state = EX) then
    pcLd <= '1';
    flagLd <= '1';
    accLd <= '1';
    dmRd <= '1';
  end if;

-- LBX
when "1001" =>
  pcSel <= '0';
  dmWr <= '0';
  flagLd <= '0';
  dispLd <= '0';
  if (current_state = DE) then
    dataLd <= '1';
  elsif (current_state = DE2) then
    dataLd <= '1';
    addrmd <= '1';
  elsif (current_state = EX) then
    pcLd <= '1';
    accSel <= '1';
    accLd <= '1';
    dmRd <= '1';
  end if;

-- SBX
when "1010" =>
  pcSel <= '0';
  flagLd <= '0';
  accSel <= '0';
  accLd <= '0';
  dmRd <= '0';
  dispLd <= '0';
  if (current_state = DE) then
    dataLd <= '1';
  elsif (current_state = ME) then
    pcLd <= '1';
    addrMd <= '1';
    dmWr <= '1';
  end if;

-- IN
when "1011" =>
  pcSel <= '0';
  addrMd <= '0';
  dataLd <= '0';
  flagLd <= '0';
  accSel <= '0';
  accLd <= '0';
  dmRd <= '0';
  dispLd <= '0';
  if (current_state = DE) then
    pcLd <= '1';
    dmWr <= '1';
  end if;

-- J | JEQ | JNE
when "1100"|"1101"|"1110" =>
  addrMd <= '0';
  dmWr <= '0';
  dataLd <= '0';
  flagLd <= '0';
  accSel <= '0';
  accLd <= '0';
  dmRd <= '0';
  dispLd <= '0';
  if (current_state = DE) then
    pcLd <= '1';
    if (opcode = "1100") then
      pcSel <= '1';
    elsif (opcode = "1101" and eq = '1') then
      pcSel <= '1';
    elsif (opcode = "1110" and neq = '1') then
      pcSel <= '1';
    end if;
  end if;

-- DS
when "1111" =>
  pcSel <= '0';
  addrMd <= '0';
  dmWr <= '0';
  dataLd <= '0';
  flagLd <= '0';
  accSel <= '0';
  accLd <= '0';
  dmRd <= '0';
  if (current_state = EX) then
    dispLd <= '1';
    pcLd <= '1';
  end if;
  
when others =>

end case;
end process;

end Behavioral;


