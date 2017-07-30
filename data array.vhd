library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dataarry Is 
generic (blocksize : integer := 64);
port(
  clk : in std_logic;
  address : in std_logic_vector(5 downto 0);
  wren : in std_logic;
  wrdata : in std_logic_vector(31 downto 0);
  data : out std_logic_vector(31 downto 0)
);
end dataarry;

architecture arc of dataarry is
	type mem is array (0 to blocksize - 1) of std_logic_vector (31 downto 0);
	signal darr0 : mem := (others => (others => '0'));
begin
  
			-- Readiing 
          data <= darr0(to_integer(unsigned(address)));	
	        
  process(clk,wren,wrdata,address)
		  variable ad : integer;
    begin
      
    if  clk'event and clk = '0' then
			ad := to_integer(unsigned(address));

			if wren = '1' and ad < blocksize then -- Writing 
				
					darr0(ad) <= wrdata;
			end if;
			
		end if;
    end process;
  
  
end arc;