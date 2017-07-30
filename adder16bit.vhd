
library IEEE;
use IEEE.std_logic_1164.all;

entity sixteen_bit_adder is
	port (
	  a, b : in std_logic_vector(15 downto 0);
		cin : in std_logic;
		cout : out std_logic;
		sum : out std_logic_vector(15 downto 0)
		);
end entity;

architecture arch_sixteen_bit_adder of sixteen_bit_adder is
	component fulladdr is
		port (a, b, c_in : in std_logic;
			sum, c_out : out std_logic);
	end component fulladdr;
	
	signal c : std_logic_vector(16 downto 0);
	--for all:fulladdr use entity work.fulladdr(arch_fulladdr);
begin
	c(0) <= cin;
	cout <= c(16);
	fa0 : fulladdr port map (a(0), b(0), c(0), sum(0), c(1));
	fa1 : fulladdr port map (a(1), b(1), c(1), sum(1), c(2));
	fa2 : fulladdr port map (a(2), b(2), c(2), sum(2), c(3));
	fa3 : fulladdr port map (a(3), b(3), c(3), sum(3), c(4));
	fa4 : fulladdr port map (a(4), b(4), c(4), sum(4), c(5));
	fa5 : fulladdr port map (a(5), b(5), c(5), sum(5), c(6));
	fa6 : fulladdr port map (a(6), b(6), c(6), sum(6), c(7));  
	fa7 : fulladdr port map (a(7), b(7), c(7), sum(7), c(8));
	fa8 : fulladdr port map (a(8), b(8), c(8), sum(8), c(9));
	fa9 : fulladdr port map (a(9), b(9), c(9), sum(9), c(10));
	fa10 : fulladdr port map (a(10), b(10), c(10), sum(10), c(11));
	fa11 : fulladdr port map (a(11), b(11), c(11), sum(11), c(12));
	fa12 : fulladdr port map (a(12), b(12), c(12), sum(12), c(13));
	fa13 : fulladdr port map (a(13), b(13), c(13), sum(13), c(14));
	fa14 : fulladdr port map (a(14), b(14), c(14), sum(14), c(15)); 
	fa15 : fulladdr port map (a(15), b(15), c(15), sum(15), c(16)); 
end architecture arch_sixteen_bit_adder;
