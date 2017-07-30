library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity registerfile is
  generic (blocksize : integer := 64);
  port(
    idata : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- input.
    clk : IN STD_LOGIC; -- clock. 
    RFLwrite : IN STD_LOGIC; -- write enable
    RFHwrite : IN STD_LOGIC; -- write enable
    r0pointer : IN STD_LOGIC_VECTOR(5 DOWNTO 0);--WP pointer show R0
    RS : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);--16 bit
    RD : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);--16 bit
    --next input come from a mux
    address : IN STD_LOGIC_VECTOR(3 DOWNTO 0) 
  );
end;

architecture rtl of registerfile is
  component six_bit_adder is
	port (
	  a, b : in std_logic_vector(5 downto 0);
		c_in : in std_logic;
		sum : out std_logic_vector(5 downto 0)
		);
 end component;

signal firstaddress,secondaddress : STD_LOGIC_VECTOR(5 DOWNTO 0);
type mem is array (0 to blocksize - 1) of std_logic_vector (15 downto 0);
signal helpd,helps : STD_LOGIC_VECTOR(5 DOWNTO 0);

begin
  helpd <= "0000" & address(3 downto 2);
  helps <= "0000" & address(1 downto 0);
  f1 :  six_bit_adder port map(helpd,r0pointer,'0',secondaddress);
  f2 :  six_bit_adder port map(helps,r0pointer,'0',firstaddress);  
   

 
 
 
  process(clk,rflwrite,rfhwrite,firstaddress,secondaddress)
    
    variable memory : mem := (others => (others => '0'));
		variable init : boolean := true;
	begin
		if init = true then
			-- some initiation
			init := false;
		end if;
		
    if clk'event and clk = '0'   and RFLwrite='1' then
       memory(to_integer(unsigned(secondaddress))) (7 downto 0) := idata(7 downto 0);
    end if;
    if   clk'event and clk = '0'  and RFHwrite='1' then
       memory(to_integer(unsigned(secondaddress))) (15 downto 8) := idata(15 downto 8);
    end if;
   -- if clk'event and clk = '0'  then
     RS <= memory(to_integer(unsigned(firstaddress))); 
     RD <= memory(to_integer(unsigned(secondaddress))); 
   -- end if;
    end process;
end architecture;
  


