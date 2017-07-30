library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mru_array is
    port(address : in STD_LOGIC_VECTOR(5 downto 0);
         k : in STD_LOGIC ;
         valid0,valid1 : in std_logic;
         clk : in STD_LOGIC;
         write : in STD_LOGIC;
         reset : in STD_LOGIC;
         w0_valid_mru : out STD_LOGIC
         
     );
end entity;
architecture behavorial of mru_array is
    type int_array is array (63 downto 0) of integer;
    signal w0s : int_array := (others => 0);
    signal w1s : int_array := (others => 0);
begin
    process (clk)
       variable init : boolean := true;
    begin
    if init = true then
			 w1s(0)<=1;
			 w0s(0)<=0;
			init := false;
		end if;
		
		
        if(reset = '1') then
            if(k = '0') then
                w0s(to_integer(unsigned(address))) <= 0;
            else
                w1s(to_integer(unsigned(address))) <= 0;
            end if;
            
            --it is really write  even in main memory
        elsif(write = '1') then
        
            if(k = '0') then
                w0s(to_integer(unsigned(address))) <=  1;
                w1s(to_integer(unsigned(address))) <=  0;
            elsif(k = '1' ) then
                w1s(to_integer(unsigned(address))) <=  1;
                w0s(to_integer(unsigned(address))) <=  0;
            end if;
      end if;
            
              
            --for know that which column is turn to write in
            if valid0='0' then
              w0_valid_mru <= '1';
            elsif valid1 = '0' then 
                w0_valid_mru <= '0'; 
            elsif(w0s(to_integer(unsigned(address))) = 1) then
                w0_valid_mru <= '1';
            else
                w0_valid_mru <= '0';
            end if;
            
           

    end process;
end behavorial;
