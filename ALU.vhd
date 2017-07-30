library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity ALU is
  port(
    A : in std_logic_vector(15 downto 0);
    B : in std_logic_vector(15 downto 0);
    cin : in std_logic;
    zin : in std_logic;
    b15to0 , aandb,aorb ,notb ,aaddb ,asubb ,axorb ,acompb,shrB ,shlB,twicecompb,amulb : in std_logic;
    cout : out std_logic;
    zout :  out std_logic;
    aluout : out std_logic_vector(15 downto 0)
  );
end entity ;
architecture aluarc of ALU is
  --adder component
  component sixteen_bit_adder is
	port (
	  a, b : in std_logic_vector(15 downto 0);
		cin : in std_logic;
		cout : out std_logic;
		sum : out std_logic_vector(15 downto 0)
		);
end component;
--comparetor component
component cmp16 is
  port (  
	  A,B   : in std_logic_vector(15 downto 0);
	  aeqb, altb, agtb  : out std_logic
   );
end component;
--mux component
component mux16 is
    Port ( a : in  STD_LOGIC_VECTOR (15 downto 0);
           b : out  STD_LOGIC;
           s : in  STD_LOGIC_VECTOR (3 downto 0));
end component;

signal add,subsig1,subsig2,nb,ncinvec,twicecompbsig :std_logic_vector(15 downto 0);
signal eqsig,lsig,gsig,ncin,ctemp: std_logic;
signal coutsig,zoutsig : std_logic:='0';
signal x,y  :std_logic_vector(7 downto 0);

begin
  
 

  x <= a (7 downto 0);
  y <= b (7 downto 0);
  
  ncin <= cin xor '1';
  ncinvec <= "111111111111111" & ncin;
  nb <= b xor "1111111111111111";
  twicecompbmodule : sixteen_bit_adder port map(nb,"0000000000000000",'1',ctemp,twicecompbsig);
  adder : sixteen_bit_adder port map (a,b,cin,coutsig,add);
  subtractor : sixteen_bit_adder port map (a,nb,'1',ctemp,subsig1);
  subtractor2 : sixteen_bit_adder port map (subsig1,ncinvec,'1',ctemp,subsig2);
  comparator : cmp16 port map (a,b,eqsig,lsig,gsig);

  process(b15to0 , aandb,aorb ,notb ,aaddb ,asubb ,axorb ,acompb,shrB ,shlB,twicecompb,amulb )
   variable mulres0,mulres1,mulres2,mulres3,mulres4,mulres5,mulres6,mulres7  :integer:=0;
   begin
    if b15to0='1' then 
      aluout <=  b ;
      cout<=cin; zout<=zin;
      
    elsif  amulb ='1' then
      
    if y(0) = '1' then
       mulres0 := to_integer(unsigned("00000000" & x));
     end if;
    if y(1) = '1' then
       mulres1 := to_integer(unsigned("0000000" & x & "0"));
     end if; 
    if y(2) = '1' then
       mulres2 := to_integer(unsigned("000000" & x & "00"));
     end if;  
    if y(3) = '1' then
       mulres3 := to_integer(unsigned("00000" & x & "000"));
     end if; 
    if y(4) = '1' then
       mulres4 := to_integer(unsigned("0000" & x & "0000"));
     end if; 
    if y(5) = '1' then
       mulres5 := to_integer(unsigned("000" & x & "00000"));
     end if; 
    if y(6) = '1' then
       mulres6 :=to_integer(unsigned("00" & x & "000000"));
     end if; 
    if y(7) = '1' then
       mulres7 :=to_integer(unsigned( "0" & x & "0000000"));
     end if; 
     aluout <=  std_logic_vector(to_unsigned(mulres0+mulres1+mulres2+mulres3+mulres4+mulres5+mulres6+mulres7,aluout'length));
         
         
    elsif   aandb ='1' then
      aluout <= a and b;
      cout<=cin; zout<=zin;
    elsif   aorb ='1' then
      aluout <= a or b;
      cout<=cin; zout<=zin;
    elsif   notb ='1' then
      aluout <= b xor "1111111111111111";
      cout<=cin; zout<=zin;
    elsif   aaddb ='1' then
      aluout <= add;
      cout <= coutsig;
      zout <= zin;
    elsif   asubb ='1' then
      aluout <= subsig2;
      cout<=cin; zout<=zin;
      cout<=cin; zout<=zin;
    elsif   axorb ='1' then
      aluout <= a xor b;
      cout<=cin; zout<=zin;
    elsif   acompb ='1' then
      if eqsig ='1' then 
        zout <='1';
     elsif gsig ='1' then
        cout <= '1';
      end if;
    elsif shrB='1' then
      aluout <= '0' & b(15 downto 1);
      cout<=cin; zout<=zin;
    elsif shlB='1' then
      aluout <=  b(14 downto 0) & '0';
      cout<=cin; zout<=zin;
    elsif twicecompb='1' then
      aluout <=  twicecompbsig;
    
    end if;
  end process;
      
    
    
    
end;

