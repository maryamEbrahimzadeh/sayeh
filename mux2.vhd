library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux2to1 is 
port( A,B: in std_logic_vector(3 downto 0);
                  S: in std_logic;
                 O: out std_logic_vector(3 downto 0));

end mux2to1;

Architecture behavioral of mux2to1 is
Begin

Process(S,A,B)
variable temp : std_logic_vector(3 downto 0);            
Begin

if(S='0')then
temp:=A;

elsif(S='1')then                   
temp:=B;


end if;                                 

O<=temp;                        
end Process;
end behavioral;