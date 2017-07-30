library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity statusreg is
  port(
    clk,cset,creset,zset,zreset,srload,cout,zout : in std_logic;
    cin,zin : out std_logic);
  end;
  architecture arc of statusreg is 
  begin
  process(clk,cset,creset,zset,zreset,cout,zout)
    begin
      if clk'event and clk = '0' and cset ='1' then
        cin <= '1';
    end if;
     if  clk'event and clk = '0' and creset ='1' then
        cin <= '0';
    end if;
     if clk'event and clk = '0' and zset ='1' then
        zin <= '1';
    end if;
     if  clk'event and clk = '0' and zreset ='1' then
        zin <= '0';
    end if;
     if  clk'event and clk = '0' and srload ='1' then
      cin<= cout;
      zin <= zout;
    end if;
  end process;
end;