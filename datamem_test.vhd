library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use std.textio.ALL;

entity data_memory is
  Port (
    ADDR : in  STD_LOGIC_VECTOR (7 downto 0);
    DATAIN : in STD_LOGIC_VECTOR (7 downto 0);
    CLK :in STD_LOGIC;
    WE : in STD_LOGIC;
    OUTPUT : out  STD_LOGIC_VECTOR (7 downto 0)
  );
end data_memory;

architecture behavioral of data_memory is
component mem_array 
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
end component;

begin
mem : mem_array generic map (DATA_WIDTH => 8, ADDR_WIDTH => 8, INIT_FILE => "data_mem.mif") port map (ADDR, DATAIN, CLK, WE, OUTPUT);

end behavioral;
