-------------------------------------------------------------------------------
-- Dr. Kaputa
-- arithmatic logic unit
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;     

entity alu is
  port (
    reset         : in  std_logic;
    a             : in  std_logic_vector(7 downto 0); 
    b             : in  std_logic_vector(7 downto 0);
    op            : in  std_logic_vector(1 downto 0); -- 00: add, 01: sub, 10: mult, 11: div
    result        : out std_logic_vector(7 downto 0)
  );  
end alu;  

architecture beh of alu  is

signal mult_temp : std_logic_vector(15 downto 0);
signal div_temp  : std_logic_vector(7 downto 0);

begin

mult_temp <= std_logic_vector(unsigned(a) * unsigned(b));
div_temp  <= std_logic_vector(unsigned(a) / unsigned(b));

process(reset,a,b,op,mult_temp,div_temp)
  begin
    if (reset = '1') then 
      result <= (others => '0');
    elsif (op = "00") then
      result  <= std_logic_vector(unsigned(a) + unsigned(b));
    elsif (op = "01") then
      result  <= std_logic_vector(unsigned(a) - unsigned(b));
    elsif (op = "10") then
      result  <= mult_temp(7 downto 0);
    else
      result  <= div_temp;
    end if;
  end process;
end beh;