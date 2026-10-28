-------------------------------------------------------------------------------
-- nate ralston
-- bcd
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;      

entity seven_seg is
  port (
    clk             : in std_logic; 
    reset           : in std_logic;
    bcd             : in std_logic_vector(3 downto 0);
    seven_seg_out   : out std_logic_vector(6 downto 0)
  );  
end seven_seg; 

architecture arch of seven_seg  is

begin
process(clk,reset)
  begin
    if (reset = '1') then 
      seven_seg_out <= "1111111";
    elsif (clk'event and clk = '1') then
       if (bcd = "0000") then
	    seven_seg_out <= "1000000";
	   elsif (bcd = "0001") then
	    seven_seg_out <= "1111001";
	   elsif (bcd = "0010") then
	    seven_seg_out <= "0100100";
	   elsif (bcd = "0011") then
	    seven_seg_out <= "0110000";
	   elsif (bcd = "0100") then
	    seven_seg_out <= "0011001";
	   elsif (bcd = "0101") then
	    seven_seg_out <= "0010010";
	   elsif (bcd = "0110") then
	    seven_seg_out <= "0000010";
	   elsif (bcd = "0111") then
	    seven_seg_out <= "1111000";
	   elsif (bcd = "1000") then
	    seven_seg_out <= "0000000";
	   elsif (bcd = "1001") then
	    seven_seg_out <= "0011000";
	   elsif (bcd = "1010") then
 	    seven_seg_out <= "0001000";
	   elsif (bcd = "1011") then
	    seven_seg_out <= "0000011";
	   elsif (bcd = "1100") then
	    seven_seg_out <= "1000110";
	   elsif (bcd = "1101") then
	    seven_seg_out <= "0100001";
	   elsif (bcd = "1110") then
	    seven_seg_out <= "0000110";
	   elsif (bcd = "1111") then
	    seven_seg_out <= "0001110";
 	   else
	    seven_seg_out <= "1111111";
	   end if;
    end if;
  end process;
  
end arch;