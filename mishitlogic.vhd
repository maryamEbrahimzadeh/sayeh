library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity misshitlogic is
  port(
    tag : in std_logic_vector(3 downto 0);
    w0  : in std_logic_vector(4 downto 0);
    w1  : in std_logic_vector(4 downto 0);
    hit : out std_logic;
    w0_valid : out std_logic;
    w1_valid : out std_logic
  );
end misshitlogic;

architecture arc of misshitlogic is 
begin
  process(tag,w0,w1)
    begin
    if tag =w0(3 downto 0) and w0(4)='1' then
      hit <= '1';
      w0_valid <= '1';
      w1_valid <= '0';
    elsif  tag =w1(3 downto 0) and w1(4)='1'  then
      hit <= '1';
      w1_valid <= '1';
      w0_valid <= '0';
    else 
      hit<='0';
      w0_valid <= '0';
      w1_valid <= '0';      
    end if;
    end process;
end arc;

