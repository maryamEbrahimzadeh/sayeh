library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity cachecontroller is
  port(clk, readmem, writemem,hit,w0_valid,w1_valid,w0_valid_mru: in std_logic;
		    addressbus: in std_logic_vector (9 downto 0);
		    wren0,wren1,k,muxen,mruen,wrtiiput: out std_logic;
        invalidate0,invalidate1,validate0,validate1 :out STD_LOGIC;
		    memdataready: out std_logic  
  );
end entity;
architecture arc of cachecontroller is 
    TYPE State_type IS (init,missread0,missread1,write0,write1,readhit1,readhit0,readhit,readmiss,write,read,writehit,writef); -- Define the states
	  SIGNAL peresents : State_Type:=init ; 
	  SIGNAL nexts : State_Type;
begin
 	
	
	process( peresents,readmem, writemem)
	 begin
	    wren0<='0';
	    wren1<='0';
	    k<='0';
	    invalidate0<='0';
	    invalidate1<='0';
	    validate0<='0';
	    validate1<='0';
	    wrtiiput<='0';
	    muxen <='0';
	    mruen<='0';
		  
	CASE peresents IS
	  --init
	WHEN init =>   	    
	if readmem='1'  then 
	     nexts <= read;	     
	elsif ( writemem ='1') then 
	      wrtiiput <='1';
	       nexts <=writef;  
	end if;
	---------------------------------------------------------------------------
	WHEN writef =>
	       if hit='0' then
	         nexts <=write;  
	       elsif hit='1' then 
	         nexts <= writehit;
	       end if; 
	---------------------------------------------------------------------------
		WHEN read =>
	  	if  hit='1' then 
	     nexts <= readhit;	 
	  elsif hit='0' then
	       nexts<=readmiss;
	   end if;
	---------------------------------------------------------------------------
	WHEN write =>
	    --or (hit='1' and w0_valid='1' )
	      if ( ( w0_valid_mru ='1') )  then
	        wren0<='1';
	        validate0<='1';
	        nexts<= write1;
	        --or (hit='1' and w1_valid='1' ) 
	      elsif ( ( w0_valid_mru ='0' )) then
	        wren1<='1'; 
	        validate1<='1';
	        nexts<= write0;	        
	      end if;
	WHEN writehit =>
	  if w0_valid='1' then
	        wren0<='1';
	        validate0<='1';
	        nexts<= write1;
	  elsif w1_valid='1'then
	        wren1<='1'; 
	        validate1<='1';
	        nexts<= write0;
	  end if;
	---------------------------------------------------------------------------
	WHEN readhit =>
	  if w0_valid='1' then 
	       nexts<=readhit1;
	      
	  elsif w1_valid='1' then
	       nexts<=readhit0;
	  end if;
	---------------------------------------------------------------------------
	WHEN readhit1 =>
	       k <='0';
	       muxen<='1';
	       mruen<='1';
	       memdataready<='1';
	       nexts<=init;
	---------------------------------------------------------------------------
	 WHEN readhit0 =>
	       k <= '1';
	       muxen<='1';
	       mruen<='1';
	       memdataready<='1';
	       nexts<=init;
	---------------------------------------------------------------------------
	WHEN write1 =>    
	      --if w0_valid_mru ='1' then
	        mruen<='1';
	        k <= '0';
	        muxen<='1';
	        memdataready <= '1';
	        nexts<=init;
	  ---------------------------------------------------------------------------
	WHEN write0 =>
	     --elsif  w0_valid_mru ='0' then
	        mruen<='1';
	        k <= '1';
	        muxen<='1';
	        memdataready <= '1';
	        nexts<=init;
	  ---------------------------------------------------------------------------
	WHEN readmiss =>
	   wrtiiput<='0';
	      if w0_valid_mru ='1' then
	        nexts<= missread1;
	      elsif  w0_valid_mru ='0' then
	        nexts<= missread0;
	      end if;
    ---------------------------------------------------------------------------
	WHEN missread1=>
          wren0<='1';
	        validate0<='1';
	        nexts<=write1;
	  ---------------------------------------------------------------------------
	WHEN missread0=>
          wren1<='1';
	        validate1<='1';
	        nexts<=write0;
	 --------------------------------------
	WHEN others =>
	end case;	
		end process;
		
			PROCESS (clk)
		BEGIN
			IF clk'EVENT AND clk = '1' THEN
				peresents <= nexts;
			END IF;
		END PROCESS;
end arc;






