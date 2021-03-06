
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tri_state8 is
    Port ( A    : in  STD_LOGIC_vector(7 downto 0);    -- single buffer input
           EN   : in  STD_LOGIC;    -- single buffer enable
           Y    : out STD_LOGIC_vector(7 downto 0));
end tri_state8;

architecture Behavioral of tri_state8 is

begin
    -- single active low enabled tri-state buffer
    Y <= A when (EN = '1')else (others => 'Z');

end Behavioral;
