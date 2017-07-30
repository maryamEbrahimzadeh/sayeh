library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity IR is
  port(
     idata : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- input.
     irload : IN STD_LOGIC ;
     clk : IN std_logic;
     shift : in std_logic;
     odata : out STD_LOGIC_VECTOR(15 DOWNTO 0)
   );
 end entity;
 architecture IR_ARC of IR is
   begin
  process (clk, irload)
   begin
	
     if clk = '0' and clk'event  then
       if irload='1'  then 
       odata <= idata;
     end if;
   end if;
   if shift ='1' then
     odata <= (others => 'Z');
     odata <= idata(7 downto 0) & "00001111";
   end if;
   
 end process;
 end;
	