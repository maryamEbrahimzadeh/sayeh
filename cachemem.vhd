library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity cachemem is
  port(clk, readmem, writemem ,readio,writeio,reset: in std_logic;
	  input :in  std_logic_vector (15 downto 0);
	  output : out  std_logic_vector (15 downto 0);
		addressbus: in std_logic_vector (15 downto 0);
		databus : in std_logic_vector (15 downto 0);
		databusout : out std_logic_vector (15 downto 0);
    memdataready : out std_logic
  );
end entity;

architecture arc of cachemem is 
 component cache is port
(clk   ,wren0,wren1, reset,k,muxen,mruen: in std_logic;
        mainaddress : in std_logic_vector(9 downto 0);
        wrdata :in STD_LOGIC_VECTOR(15 downto 0);
        invalidate0,invalidate1,validate0,validate1 :in STD_LOGIC;
        data: out STD_LOGIC_VECTOR(15 downto 0);
        hit,w0_valid,w1_valid,w0_valid_mru: out STD_LOGIC
);
end component;
component  memorycache is
	generic (blocksize : integer := 1024);

	port (
	  clk, readmem, writemem ,readio,writeio: in std_logic;
	  input :in  std_logic_vector (15 downto 0);
	  output : out  std_logic_vector (15 downto 0);
		addressbus: in std_logic_vector (15 downto 0);
		databus : in std_logic_vector (15 downto 0);
		databusout : out std_logic_vector (15 downto 0)
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
component cachecontroller is
    port(clk, readmem, writemem,hit,w0_valid,w1_valid,w0_valid_mru: in std_logic;
		    addressbus: in std_logic_vector (9 downto 0);
		    wren0,wren1,k,muxen,mruen,wrtiiput: out std_logic;
        invalidate0,invalidate1,validate0,validate1 :out STD_LOGIC;
		    memdataready: out std_logic  
  );
end component;

signal wren1,wren0,k,invalidate0,invalidate1,validate0,validate1
,hit,wrtiiput,w0_valid,w1_valid,muxen,mruen,w0_valid_mru: std_logic;
signal outofmem,datainchache : std_logic_vector (15 downto 0);
begin
   muxm : mux port map (clk,wrtiiput,'1',outofmem,databus,datainchache);
     
     
  chachemodule : cache port map(clk,wren0,wren1, reset,k,muxen,mruen,
  addressbus(9 downto 0),datainchache,
  invalidate0,invalidate1,validate0,validate1,databusout,hit,w0_valid,w1_valid,w0_valid_mru);
  
  
  
  memmodule : memorycache port map(clk, readmem, writemem ,readio,writeio,input,output,
  addressbus,databus,outofmem);
  
 
  controllerm : cachecontroller port map(clk,readmem,writemem,hit,w0_valid,w1_valid,w0_valid_mru
  ,addressbus(9 downto 0),wren0,wren1,k,muxen,mruen,wrtiiput,invalidate0,
  invalidate1,validate0, validate1,memdataready);   
  
end architecture;
                          