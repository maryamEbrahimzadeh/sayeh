library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity datapath is
port(
    clk ,
    ResetPC, PCplusI, PCplus1, RplusI, Rplus0:in std_logic;
    RS_On_addressUnitRside,Rd_On_addressUnitRside,
    enablePc : in std_logic;
    b15to0 , aandb, aorb ,notb ,aaddb ,asubb ,axorb ,acompb,shrB ,shlB,twicecompb,amulb : in std_logic;
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
end datapath;

architecture datapatharc of datapath is 
--  alu    component
component  ALU is
  port(
    A : in std_logic_vector(15 downto 0);
    B : in std_logic_vector(15 downto 0);
    cin : in std_logic;
    zin : in std_logic;
    b15to0 , aandb,aorb ,notb ,aaddb ,asubb ,axorb ,acompb,shrB ,shlB,twicecompb,amulb: in std_logic;
    cout : out std_logic;
    zout :  out std_logic;
    aluout : out std_logic_vector(15 downto 0)
  );
end component;
--  registerfile    component
component  registerfile is
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
end component;
--  wp   component
component wp is
  port(
    idata : in std_logic_vector(5 downto 0);
    clk,wpadd,wpreset : in std_logic;
    cout : out std_logic_vector(5 downto 0));
end component;
-- ir   component
component  IR is
  port(
     idata : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- input.
     irload : IN STD_LOGIC ;
     clk : IN std_logic;
     shift : in std_logic;
     odata : out STD_LOGIC_VECTOR(15 DOWNTO 0)
   );
end component;
--flag   component
component  statusreg is
  port(
    clk,cset,creset,zset,zreset,srload,cout,zout : in std_logic;
    cin,zin : out std_logic);
end component;
--addresunit   component
component AddressUnit IS
PORT (
 Rside : IN std_logic_vector (15 DOWNTO 0);
 Iside : IN std_logic_vector (7 DOWNTO 0);
 Address : OUT std_logic_vector (15 DOWNTO 0);
clk, ResetPC, PCplusI, PCplus1 : IN std_logic;
RplusI, Rplus0, EnablePC : IN std_logic
); end component;
--mux 2 component
component mux2to1 is 
port( A,B: in std_logic_vector(3 downto 0);
                  S: in std_logic;
                 O: out std_logic_vector(3 downto 0)
                 );

end component;
--tristate 16  component
component tri_state is
    Port ( A    : in  STD_LOGIC_vector(15 downto 0);    -- single buffer input
           EN   : in  STD_LOGIC;    -- single buffer enable
           Y    : out STD_LOGIC_vector(15 downto 0));
         end component;
--tristate 8 component
component tri_state8 is
    Port ( A    : in  STD_LOGIC_vector(7 downto 0);    -- single buffer input
           EN   : in  STD_LOGIC;    -- single buffer enable
           Y    : out STD_LOGIC_vector(7 downto 0));
         end component;

signal right ,left,opndbus,aluout,irout,address,addressUnitRSidBus : std_logic_vector(15 downto 0);
signal srcin,srzin,srzout,srcout : std_logic;
signal wpoint : std_logic_vector(5 downto 0);
signal addrmuxtoreg : std_logic_vector(3 downto 0);

begin
  databus <= (others=>'Z');
  srcout <= '0';
  srzout <= '0';
--addressunit module
addressuntmodule : addressunit port map(addressUnitRSidBus,irout(7 downto 0),address,
clk,ResetPC, PCplusI, PCplus1,RplusI, Rplus0, EnablePC);
--alu module 
alumodule : alu port map (left,opndbus,srcout,srzout,b15to0 , aandb,aorb ,notb ,aaddb ,
asubb ,axorb ,acompb,shrB ,shlB,
twicecompb,
amulb,srcin,srzin,aluout);
--flag moddule
falgmodule : statusreg port map (clk,cset,creset,zset,zreset,srload,srcout,srzout,srcin,srzin);
--register file module
registerfilemodule : registerfile port map (databus,clk,rflwrite,rfhwrite,wpoint,right,left,addrmuxtoreg);
--IR module
irmodule  : ir port map (databus,irload,clk,shiftir,irout);
-- wp module
wpmodule : wp port map (irout(5 downto 0),clk,wpadd,wpreset,wpoint);


tri1 : tri_state port map (right,Rs_On_addressUnitRside,addressUnitRSidBus);--16 bit
tri2 : tri_state port map (left,Rd_On_addressUnitRside,addressUnitRSidBus);--16 bit


tri3 : tri_state port map (address,address_on_databus,databus);--16bit
tri4 : tri_state port map (aluout,alu_on_databus,databus);--16bit
tri5 : tri_state port map (right,rfright_on_opndbus,opndbus);--16bit
  
  
tri6 : tri_state8 port map (irout(7 downto 0),ir_on_lopndbus,opndbus(7 downto 0));--8 bit
tri7 : tri_state8 port map (irout(7 downto 0),ir_on_hopndbus,opndbus(15 downto 8));--8 bit

--if shadow is 1 we select irout(3 downto 0) else irout(3 downto 0)
mmux : mux2to1 port map(irout(11 downto 8),irout(3 downto 0),shadow,addrmuxtoreg);

--output of sayeh is address bus
addressbus <= address;
instruction <= irout;
cout <= srcout;
zout <= srzout;

  
end;

