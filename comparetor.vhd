library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity cmp16 is
  port (  
	  A,B   : in std_logic_vector(15 downto 0);
	  aeqb, altb, agtb  : out std_logic
   );
end cmp16;

architecture a of cmp16 is
        
begin

  aeqb <= '1' when (a = b) else '0';
  altb <= '1' when (a < b) else '0';
  agtb <= '1' when (a > b) else '0';

end;

--The operators =, /=, <=, <, >, >= are defined in the std_logic_arith package which is part of the IEEE library.


