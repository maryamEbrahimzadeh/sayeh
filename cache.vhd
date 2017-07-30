library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity cache is port
(clk,wren0,wren1, reset,k,muxen,mruen: in std_logic;
        mainaddress : in std_logic_vector(9 downto 0);
        wrdata :in STD_LOGIC_VECTOR(15 downto 0);
        invalidate0,invalidate1,validate0,validate1 :in STD_LOGIC;
        data: out STD_LOGIC_VECTOR(15 downto 0);
        hit,w0_valid,w1_valid,w0_valid_mru: out STD_LOGIC
);
end cache;
architecture arc of cache is
  
component dataarry Is 
generic (blocksize : integer := 64);
port(
  clk : in std_logic;
  address : in std_logic_vector(5 downto 0);
  wren : in std_logic;
  wrdata : in std_logic_vector(15 downto 0);
  data : out std_logic_vector(15 downto 0)
);
end component;
component misshitlogic is
  port(
    tag : in std_logic_vector(3 downto 0);
    w0  : in std_logic_vector(4 downto 0);
    w1  : in std_logic_vector(4 downto 0);
    hit : out std_logic;
    w0_valid : out std_logic;
    w1_valid : out std_logic
  );
end component;
component tag_valid_array is
    port(clk,wren,reset_n,invalidate,validate:in STD_LOGIC;
         address:in STD_LOGIC_VECTOR(5 downto 0);
         wrdata:in STD_LOGIC_VECTOR(3 downto 0);
         output:out STD_LOGIC_VECTOR(4 downto 0)
     );
end component;
 component mux is
     port(clk,sel:in STD_LOGIC;
         en : in std_logic;
         w0:in STD_LOGIC_VECTOR(15 downto 0);
         w1:in STD_LOGIC_VECTOR(15 downto 0);
         output: out STD_LOGIC_VECTOR(15 downto 0)
     );
end component;
component mru_array is
    port(address : in STD_LOGIC_VECTOR(5 downto 0);
         k : in STD_LOGIC;
         valid0,valid1 : in std_logic;
         clk : in STD_LOGIC;
         write : in STD_LOGIC;
         reset : in STD_LOGIC;
         w0_valid_mru : out STD_LOGIC
     );
end component;

signal data_arr0_out,data_arr1_out:std_logic_vector(15 downto 0);
signal tag_valid0_out,tag_valid1_out:std_logic_vector(4 downto 0):="00000";
begin
  da0:dataarry  port map(clk,mainaddress(5 downto 0),wren0,wrdata,data_arr0_out);
  da1:dataarry  port map(clk,mainaddress(5 downto 0),wren1,wrdata,data_arr1_out);
    
  tva0 : tag_valid_array port map(clk,wren0,reset,invalidate0,validate0,mainaddress(5 downto 0)
  ,mainaddress(9 downto 6),tag_valid0_out);
  tva1 : tag_valid_array port map(clk,wren1,reset,invalidate1,validate1,mainaddress(5 downto 0)
  ,mainaddress(9 downto 6),tag_valid1_out);
    
  mhl: misshitlogic port map(mainaddress(9 downto 6),tag_valid0_out,tag_valid1_out,hit,
  w0_valid,w1_valid);
 
  
   mru : mru_array port map  (mainaddress(5 downto 0),k,tag_valid0_out(4),tag_valid1_out(4),clk
    ,mruen,reset,w0_valid_mru);
  
  --sel en w0 w1 out
   m : mux port map (clk,k,muxen,data_arr0_out,data_arr1_out,data);
end arc;
  
  
   