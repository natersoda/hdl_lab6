-------------------------------------------------------------------------------
-- Dr. Kaputa
-- generic adder [behavioral]
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_adder_beh is
  generic (
    bits    : integer := 8
  );
  port (
    a       : in  std_logic_vector(bits-1 downto 0);
    b       : in  std_logic_vector(bits-1 downto 0);
    sel     : in  std_logic;
	cout    : out std_logic;
    sum     : out std_logic_vector(bits-1 downto 0)
  );
end entity generic_adder_beh;

architecture beh of generic_adder_beh is

signal sum_temp   : std_logic_vector(bits downto 0);

begin
 process (a,b,sel)
 begin
    if (sel = '1') then 
     sum_temp  <= std_logic_vector(unsigned('0' & a) + unsigned('0' & b));
     
    elsif (sel = '0') then
      sum_temp  <= std_logic_vector(unsigned('0' & a) - unsigned('0' & b));
      
    end if;
	 sum       <= sum_temp(bits-1 downto 0);
	 cout      <= sum_temp(bits);
	end process;
end beh;