
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

entity EDA322Testbench is
end EDA322Testbench;

architecture Behavioral of EDA322Testbench is

component EDA322_processor is
    Port ( externalIn : in  STD_LOGIC_VECTOR (7 downto 0);
			  CLK : in STD_LOGIC;
			  master_load_enable: in STD_LOGIC;
			  ARESETN : in STD_LOGIC;
           pc2seg : out  STD_LOGIC_VECTOR (7 downto 0);
           instr2seg : out  STD_LOGIC_VECTOR (11 downto 0);
           Addr2seg : out  STD_LOGIC_VECTOR (7 downto 0);
           dMemOut2seg : out  STD_LOGIC_VECTOR (7 downto 0);
           aluOut2seg : out  STD_LOGIC_VECTOR (7 downto 0);
           acc2seg : out  STD_LOGIC_VECTOR (7 downto 0);
           flag2seg : out  STD_LOGIC_VECTOR (3 downto 0);
           busOut2seg : out  STD_LOGIC_VECTOR (7 downto 0);
			  disp2seg: out STD_LOGIC_VECTOR(7 downto 0);
			  errSig2seg : out STD_LOGIC;
			  ovf : out STD_LOGIC;
			  zero : out STD_LOGIC);
end component;

Type TRACE is ARRAY (0 to 255) of std_logic_vector(7 downto 0);

impure function init_trace_wfile(mif_file_name : in string) return 
TRACE is
   file mif_file : text open read_mode is mif_file_name;
   variable mif_line : line;variable temp_bv : bit_vector(7 downto 0);
   variable temp_mem : TRACE;
   variable i : integer := 0;
begin
   while (not endfile(mif_file)) loop
      readline(mif_file, mif_line);
      read(mif_line, temp_bv);
      temp_mem(i) := to_stdlogicvector(temp_bv);
      i := i + 1;
   end loop;
   return temp_mem;
end function;

signal test_time_step : integer := 0;
signal disp_step : integer := 0;
signal acc_step : integer := 0;
signal pc_step : integer := 0;
signal dMemOut_step : integer := 0;
signal flag_step : integer := 0;

signal CLK:  std_logic := '0';
signal ARESETN:  std_logic := '0';

signal master_load_enable:  std_logic := '0';


signal pc2seg: std_logic_vector(7 downto 0);
signal addr2seg: std_logic_vector(7 downto 0);
signal instr2seg: std_logic_vector(11 downto 0);
signal dMemOut2seg: std_logic_vector(7 downto 0);
signal aluOut2seg: std_logic_vector(7 downto 0);
signal acc2seg: std_logic_vector(7 downto 0);
signal flag2seg: std_logic_vector(3 downto 0);
signal busOut2seg: std_logic_vector(7 downto 0);
signal disp2seg: std_logic_vector(7 downto 0);
signal errSig2seg: std_logic;
signal ovf: std_logic;
signal zero: std_logic;

signal disptrace : TRACE := init_trace_wfile("disptrace.txt");
signal acctrace : TRACE := init_trace_wfile("acctrace.txt");
signal pctrace : TRACE := init_trace_wfile("pctrace.txt");
signal dMemOuttrace : TRACE := init_trace_wfile("dMemOuttrace.txt");
signal flagtrace : TRACE := init_trace_wfile("flagtrace.txt");

begin
-- Processor port map 
processor : EDA322_processor port map ("00000000", CLK, master_load_enable, ARESETN, pc2seg, instr2seg, Addr2seg, dMemOut2seg, aluOut2seg, acc2seg, flag2seg, busOut2seg, disp2seg, errSig2seg, ovf, zero);

-- Drive inputs

CLK <= not CLK after 5 ns; -- CLK with period of 10ns

-- Control reset and master_load_enable with CLK 
process (CLK)
begin
  master_load_enable <= not master_load_enable; -- Toggle master_load_enable every time clock changes
  if rising_edge(CLK) then
    test_time_step <= test_time_step + 1;
  end if;
  if test_time_step = 2 then
    ARESETN <= '1'; -- release reset
  end if;
end process;

-- The first 10 times disp2seg changes, after aresetn = '1' check if disp2seg = expected for that step
process(disp2seg)
begin
if (ARESETN = '1') then
  assert (disptrace(disp_step) /= x"90")
    report "TESTS DONE";
  assert (disptrace(disp_step) = disp2seg)
    report "disp is not what it hould be.";
  disp_step <= disp_step + 1;
end if;
end process;

-- The first 30 times acc2seg changes, after aresetn = '1' check if acc2seg = expected for that step
process(acc2seg)
begin
if (ARESETN = '1') then
  assert (acctrace(acc_step) = acc2seg)
    report "acc is not what it hould be.";
  acc_step <= acc_step + 1;
end if;
end process;

-- The first 66 times pc2seg changes, after aresetn = '1' check if pc2seg = expected for that step
process(pc2seg)
begin
if (ARESETN = '1') then
  assert (pctrace(pc_step) = pc2seg)
    report "pc is not what it hould be.";
  pc_step <= pc_step + 1;
end if;
end process;

-- The first 20 times dMemOut2seg changes, after aresetn = '1' check if dMemOut2seg = expected for that step
process(dMemOut2seg)
begin
if (ARESETN = '1') then
  assert (dMemOuttrace(dMemOut_step) = dMemOut2seg)
    report "dMemOut is not what it hould be.";
  dMemOut_step <= dMemOut_step + 1;
end if;
end process;

-- The first 20 times flag2seg changes, after aresetn = '1' check if flag2seg = expected for that step
process(flag2seg)
begin
if (ARESETN = '1') then
  assert (flagtrace(flag_step) = flag2seg)
    report "flag is not what it hould be.";
  flag_step <= flag_step + 1;
end if;
end process;

end behavioral;