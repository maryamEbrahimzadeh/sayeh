--------------------------------------------------------------------------------
-- Author:        Parham Alvani (parham.alvani@gmail.com)
--
-- Create Date:   16-03-2017
-- Module Name:   memory.vhd
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memorycache is
	generic (blocksize : integer := 1024);

	port (
	  clk, readmem, writemem ,readio,writeio: in std_logic;
	  input :in  std_logic_vector (15 downto 0);
	  output : out  std_logic_vector (15 downto 0);
		addressbus: in std_logic_vector (15 downto 0);
		databus : in std_logic_vector (15 downto 0);
		databusout : out std_logic_vector (15 downto 0)
		);
end entity memorycache;

architecture behavioral of memorycache is
	type mem is array (0 to blocksize - 1) of std_logic_vector (15 downto 0);
begin
	process (clk, readmem,writemem)
		variable buffermem : mem := (others => (others => '0'));
		variable ad : integer;
		variable init : boolean := true;
	begin
		if init = true then
			-- some initiation
		      
           -- cwp
          buffermem(0) := "0000000000000110";

          -- mil r0, 01011101
          buffermem(1) := "1111000000000010";

          -- mih r0, 00000101
          buffermem(2) := "1111000100000000";

          -- mil r1, 00000001
          buffermem(3) := "1111010000000110";

          -- mih r1, 00000000
          buffermem(4) := "1111010100000000";

          -- mul r1, r0
          buffermem(5) := "0000000011010100";

         		init := false;
		end if;

		
		

		if  clk'event  then
			ad := to_integer(unsigned(addressbus));

			if readmem = '1' then -- Readiing :)
				if ad >= blocksize then
					databusout <= (others => 'Z');
				else
					databusout <= buffermem(ad);
				end if;
			elsif writemem = '1' then -- Writing :)
				
				if ad < blocksize then
					buffermem(ad) := databus;
					databusout<= databus;
				end if;
				
			elsif readio ='1' then --read from port
			  databusout <= input;
			 elsif writeio ='1'  then --writeio 
			   output <= databus ;
			else
			  databusout <= (others => 'Z');

			end if;
		end if;
	end process;
end architecture behavioral;


