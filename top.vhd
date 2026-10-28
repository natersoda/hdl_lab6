-------------------------------------------------------------------------------
-- nate ralston
-- lab5 top
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  port (
    clk_50_mhz   : in  std_logic;
    reset        : in  std_logic;
    pb           : in  std_logic;
    sw           : in  std_logic_vector(7 downto 0);
    state_out    : out std_logic_vector(3 downto 0);
    hex0_out     : out std_logic_vector(6 downto 0);
    hex1_out     : out std_logic_vector(6 downto 0); 
	hex2_out     : out std_logic_vector(6 downto 0)
  );  
end top;  

architecture arch of top is

component rising_edge_synchronizer is 
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    input             : in std_logic;
    edge              : out std_logic
  );
end component;
 
component synchronizer_8bit is 
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    async_in          : in std_logic_vector(7 downto 0);
    sync_out          : out std_logic_vector(7 downto 0)
  );
end component;

 component generic_adder_beh is
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
end component;

component seven_seg is
  port (
    clk             : in std_logic; 
    reset           : in std_logic;
    bcd             : in std_logic_vector(3 downto 0);
    seven_seg_out   : out std_logic_vector(6 downto 0)
  );  
end component; 

  type t_state is (input_A, input_B, add, sub);
  
  signal stateReg : t_state := input_A;
  signal stateNext : t_state := input_A;

  signal pb_s : std_logic;
  signal sel_flag : std_logic;
  signal carryout : std_logic;
  signal sw_s  : std_logic_vector(7 downto 0);
  signal sw_s_a  : std_logic_vector(7 downto 0);
  signal sw_s_b  : std_logic_vector(7 downto 0);
  signal result : std_logic_vector(7 downto 0);
  signal displaysig : std_logic_vector(8 downto 0);
  signal digit0 : std_logic_vector(3 downto 0);
  signal digit1 : std_logic_vector(3 downto 0);
  signal digit2 : std_logic_vector(3 downto 0);
  signal hex0_bcd_out : std_logic_vector(6 downto 0);
  signal hex1_bcd_out : std_logic_vector(6 downto 0);
  signal hex2_bcd_out : std_logic_vector(6 downto 0);
 
 signal digit0_temp : std_logic_vector(8 downto 0);
    signal digit1_temp : std_logic_vector(8 downto 0);
    signal digit2_temp : std_logic_vector(8 downto 0);
 
begin

redge_inst_pb_add: rising_edge_synchronizer
    port map(
      reset  => reset,
      clk    => clk_50_mhz,
      input  => pb,
	  edge   => pb_s
    );

sycnhro_sw: synchronizer_8bit
    port map(
      reset      => reset,
      clk        => clk_50_mhz,
      async_in   => sw,
	  sync_out   => sw_s
    );
		
math: generic_adder_beh
    port map(
      a          => sw_s_a,
      b          => sw_s_b,
      sel        => sel_flag,
	  cout       => carryout,
      sum        => result
    );	
		
hex0_out_uut: seven_seg
    port map(
      reset          => reset,
      clk            => clk_50_mhz,
      bcd            => digit0,
	  seven_seg_out  => hex0_bcd_out
    );
		
hex1_out_uut: seven_seg
    port map(
      reset          => reset,
      clk            => clk_50_mhz,
      bcd            => digit1,
	  seven_seg_out  => hex1_bcd_out
    );
	
hex2_out_uut: seven_seg
    port map(
      reset          => reset,
      clk            => clk_50_mhz,
      bcd            => digit2,
	  seven_seg_out  => hex2_bcd_out
    );

 procStateRegister: process(reset, clk_50_mhz)
 begin 
  if (reset = '1') then
   stateReg <= input_A;
  elsif (clk_50_mhz'event and clk_50_mhz = '1') then
  stateReg <= stateNext;
  end if;
 end process;

 StateRegisterNext: process(stateReg, pb_s)
 begin 
  stateNext <= stateReg;
  case stateReg is
    when input_A =>
	 if (pb_s = '1') then
	    stateNext <= input_B;
	 end if;
	when input_B =>
	 if (pb_s = '1') then
	    stateNext <= add;
	 end if;	
	when add =>
		 if (pb_s = '1') then
	    stateNext <= sub;
	 end if;
	when sub =>
		 if (pb_s = '1') then
	    stateNext <= input_A;
	 end if;
  end case;
 end process;

 StateRegisterLogic: process(stateReg)
 begin 
  case stateReg is
    when input_A =>
	state_out <= "0001";
	 sw_s_a <= sw_s;
	 displaysig <= '0' & sw_s_a;
	when input_B =>
     state_out <= "0010";
	 sw_s_b <= sw_s;
     displaysig <= '0' & sw_s_b;	 
	when add =>
	 state_out <= "0100";
	 sel_flag <= '1';
	 displaysig <= carryout & result;
	when sub =>
	 state_out <= "1000";
	 sel_flag <= '0';
	 displaysig <= carryout & result;
  end case;
 end process;

  trunc_process: process(clk_50_mhz, displaysig)
  begin
    digit0_temp <= std_logic_vector( (unsigned(displaysig) - (unsigned(displaysig) mod 100) )/100);
    digit1_temp <= std_logic_vector( ( (unsigned(displaysig) mod 100) - (unsigned(displaysig) mod 10) )/10);
    digit2_temp <= std_logic_vector( (unsigned(displaysig) mod 10) );
    if (clk_50_mhz'event and clk_50_mhz = '1') then
       digit0 <= digit0_temp(3 downto 0);  
       digit1 <= digit1_temp(3 downto 0);  
       digit2 <= digit2_temp(3 downto 0);  
	end if;
  end process;

  main_adder: process(clk_50_mhz, reset)
  begin
    if (reset = '1') then 
      hex0_out <= "1111111";
      hex1_out <= "1111111";
      hex2_out <= "1111111";
    elsif (clk_50_mhz'event and clk_50_mhz = '1') then
      hex0_out <= hex0_bcd_out;
      hex1_out <= hex1_bcd_out;
      hex2_out <= hex2_bcd_out;
    end if;
  end process; 
end arch;