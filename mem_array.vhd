library ieee;
use ieee.std_logic_1164.all;

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

architecture bajs of mem_array is
Type MEMORY_ARRAY is ARRAY (ADDR_WIDTH - 1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0);
signal memory : MEMORY_ARRAY := init_memory_wfile(INIT_FILE);

begin

end bajs;