library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity sayeh is 
port(
  input :in std_logic_vector(15 downto 0);
  output :out std_logic_vector(15 downto 0);
  clk,externalreset : in std_logic);
 end entity;
  
  architecture rtl of sayeh is
  component  datapath is
  port(
    clk ,
    ResetPC, PCplusI, PCplus1, RplusI, Rplus0:in std_logic;
    RS_On_addressUnitRside,Rd_On_addressUnitRside,
    enablePc : in std_logic;
    b15to0 , aandb,aorb ,notb ,aaddb ,asubb ,axorb ,acompb,shrB ,shlB,twicecompb,amulb : in std_logic;
    RFLwrite,RFHwrite,
    wpadd,wpreset,
    irload,
    srload,
    address_on_databus,alu_on_databus,
    ir_on_lopndbus,ir_on_hopndbus,rfright_on_opndbus,
    cset,creset,zset,zreset,shiftir,
    shadow: in std_logic;
    databus: inout std_logic_vector (15 downto 0);
    addressbus,instruction: out std_logic_vector(15 downto 0);
    cout,zout :out std_logic
  );
  end component;
  --controller
   component  controller IS
	PORT (
		externalreset, memdataready : IN std_logic;
		clk, cflag, zflag : IN std_logic;
		irout : IN std_logic_vector(15 DOWNTO 0);
		ResetPC, PCplusI, PCplus1, RplusI, Rplus0 : OUT std_logic;
		RS_On_addressUnitRside, Rd_On_addressUnitRside, enablePc : OUT std_logic;
		b15to0, aandb, aorb, notb, aaddb, asubb, axorb, acompb, shrB, shlB, twicecompb,amulb : OUT std_logic;
		RFLwrite, RFHwrite, wpadd, wpreset, 
		irload, srload, 
		address_on_databus, alu_on_databus, ir_on_lopndbus, ir_on_hopndbus, rfright_on_opndbus, 
		cset, creset, zset, zreset,readmem, writemem 
		,readio,writeio,shiftir: OUT std_logic;
		shadow: out std_logic
	);
	end component;
	-- memory component
	component cachemem is
		 port(clk, readmem, writemem ,readio,writeio,reset: in std_logic;
	  input :in  std_logic_vector (15 downto 0);
	  output : out  std_logic_vector (15 downto 0);
		addressbus: in std_logic_vector (15 downto 0);
		databus : in std_logic_vector (15 downto 0);
		databusout : out std_logic_vector (15 downto 0);
    memdataready : out std_logic
  );
end component;

	
	
	--signals
	  --signal clk : std_logic;
    signal ResetPC, PCplusI, PCplus1, RplusI, Rplus0: std_logic;
    signal RS_On_addressUnitRside,Rd_On_addressUnitRside,
    enablePc :  std_logic;
    signal b15to0 , aandb,aorb ,notb ,aaddb ,asubb ,axorb ,acompb,shrB ,shlB,twicecompb,amulb : std_logic;
    signal RFLwrite,RFHwrite,
    wpadd,wpreset,
    irload,
    srload,
    address_on_databus,alu_on_databus,
    ir_on_lopndbus,ir_on_hopndbus,rfright_on_opndbus,
    cset,creset,zset,zreset
    ,readio,writeio,
    shadow,shiftir:  std_logic;
	  signal databus:  std_logic_vector (15 downto 0);
    signal addressbus,instruction: std_logic_vector(15 downto 0);
    signal cout,zout : std_logic;
    
   -- signal externalreset: std_logic;
    signal readmem, writemem, memdataready  :  std_logic;
  
  begin
    output <= (others => 'Z');
     controllermodule : controller port map (externalreset , memdataready,clk,cout,zout,
                                     instruction,
                                     ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
		                                 RS_On_addressUnitRside, Rd_On_addressUnitRside,
		                                 enablePc,
		                                 b15to0, aandb, aorb, notb, aaddb, asubb,
		                                  axorb, acompb, shrB, shlB, twicecompb,amulb,
	                                   	RFLwrite, RFHwrite,
	                                   	 wpadd, wpreset, 
		                                  irload, srload, 
		                                  address_on_databus, alu_on_databus, ir_on_lopndbus,
		                                  ir_on_hopndbus, rfright_on_opndbus, 
		                                  cset, creset, zset, zreset,
		                                  readmem, writemem
		                                  ,readio,writeio,shiftir 
                                      ,shadow
                                      );
                                      
      
     datapathmodule : datapath port map (
                               clk,
                               ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
                               RS_On_addressUnitRside,Rd_On_addressUnitRside,
                               enablePc,
                               b15to0 , aandb,aorb ,notb ,aaddb ,asubb 
                              ,axorb ,acompb,shrB ,shlB,
                               twicecompb ,
                               amulb,
                               RFLwrite,RFHwrite,
                               wpadd,wpreset,
                               irload,
                               srload,
                               address_on_databus,alu_on_databus,
                               ir_on_lopndbus,ir_on_hopndbus,rfright_on_opndbus,
                               cset,creset,zset,zreset,shiftir,
                               shadow,
                               databus,addressbus,instruction,
                               cout,zout);                          
     
                                      
    -- memorymodule : memory port map ( clk, readmem, writemem,readio,writeio, input,  output, addressbus,databus,memdataready );
	           
	     memotymodule : cachemem port map(clk, readmem, writemem,readio,writeio,externalreset, input,  output, addressbus,databus,databus,memdataready);      
	                    

end ;


