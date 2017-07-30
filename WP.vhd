library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity wp is
  port(
    idata : in std_logic_vector(5 downto 0);
    clk,wpadd,wpreset : in std_logic;
    cout : out std_logic_vector(5 downto 0));
  end;
  
  architecture arc of wp is 
  signal wireout : std_logic_vector(5 downto 0);
  begin
    cout <= wireout;
  process(clk,wpadd,wpreset)
    begin
      if clk'event and clk = '0' and wpadd ='1' then
        wireout <= std_logic_vector(unsigned(wireout) + unsigned(idata));
      elsif clk'event and clk = '0' and wpreset ='1' then
        wireout <= "000000";
    end if;
  end process;
end arc;