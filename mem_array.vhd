library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use std.textio.ALL;





entity mem_array 
  is generic (  
    DATA_WIDTH: integer := 12;
    ADDR_WIDTH: integer := 8;
    INIT_FILE: string := "inst_mem.mif"
  );
  Port (
    ADDR : in  STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
    DATAIN : in STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
    CLK :in STD_LOGIC;
    WE : in STD_LOGIC;
    OUTPUT : out  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
  );
end mem_array;



architecture behavioral of mem_array is
Type MEMORY_ARRAY is ARRAY ((2**ADDR_WIDTH) - 1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0);
impure function init_memory_wfile(mif_file_name : in string) return 
MEMORY_ARRAY is
   file mif_file : text open read_mode is mif_file_name;
   variable mif_line : line;variable temp_bv : bit_vector(DATA_WIDTH-1 downto 0);
   variable temp_mem : MEMORY_ARRAY;
begin
   for i in MEMORY_ARRAY'range loop
      readline(mif_file, mif_line);
      read(mif_line, temp_bv);
      temp_mem(i) := to_stdlogicvector(temp_bv);
   end loop;
   return temp_mem;
end function;

signal memory : MEMORY_ARRAY := init_memory_wfile(INIT_FILE);

begin
  process(clk)
  begin
    if (rising_edge(clk) and WE = '1') then
      memory(to_integer(unsigned(ADDR))) <= DATAIN;
    elsif (rising_edge(clk) and WE = '0') then
      OUTPUT <= memory(to_integer(unsigned(ADDR)));
    end if;
  end process;

end behavioral;