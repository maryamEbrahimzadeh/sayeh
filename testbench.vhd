library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity test is 
end test;

architecture rtl of test is
  component sayeh is 
  port(
  input :in std_logic_vector(15 downto 0);
  output :out std_logic_vector(15 downto 0);
  clk,externalreset : in std_logic);
 end component;
signal inp,oup :std_logic_vector(15 downto 0);
signal clks,externalresets : std_logic;
begin
  sm : sayeh port map(inp,oup,clks,externalresets);
  
  process (clks)
    begin
    clks <= not clks after 10 ns;
  end process;
  externalresets <='1' ,'0' after 100 ns;
end;