library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux16 is
    Port ( a : in  STD_LOGIC_VECTOR (15 downto 0);
           b : out  STD_LOGIC;
           s : in  STD_LOGIC_VECTOR (3 downto 0));
end mux16;

architecture Behavioral of mux16 is
signal e0,e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15:STD_LOGIC;
begin
  
e0 <= not (s(3))and  not(s(2)) and not(s(1)) and not(s(0)) and a(0);
e1 <= not (s(3))and  not(s(2)) and not(s(1)) and (s(0))    and a(1);
e2 <= not (s(3))and  not(s(2)) and (s(1))    and not(s(0)) and a(2);
e3 <= not (s(3))and  not(s(2)) and (s(1))    and (s(0))    and a(3);
e4 <= not (s(3))and (s(2))     and not(s(1)) and not(s(0)) and a(4);
e5 <= not (s(3))and (s(2))     and not(s(1)) and (s(0))    and a(5);
e6 <= not (s(3))and (s(2))     and (s(1))    and not(s(0)) and a(6);
e7 <= not (s(3))and (s(2))     and (s(1))    and (s(0))    and a(7);
e8 <=     (s(3))and not (s(2)) and not (s(1))and not (s(0)) and a(8);
e9 <=     (s(3))and  not(s(2)) and not(s(1)) and (s(0))    and a(9);
e10 <=    (s(3))and  not(s(2)) and (s(1))    and not(s(0)) and a(10);
e11 <=    (s(3))and  not(s(2)) and (s(1))    and (s(0))    and a(11);
e12 <=    (s(3))and (s(2))     and not(s(1)) and not(s(0)) and a(12);
e13 <=    (s(3))and (s(2))     and not(s(1)) and (s(0))    and a(13);
e14 <=    (s(3))and (s(2))     and (s(1))    and not(s(0)) and a(14);
e15 <=    (s(3))and (s(2))     and (s(1))    and (s(0))    and a(15);

b <= e0 or e1 or e2 or e3 or e4 or e5 or e6 or e7 or e8 or e9 or e10 or e11 or e12 or e13 or e14 or e15;
end Behavioral;



