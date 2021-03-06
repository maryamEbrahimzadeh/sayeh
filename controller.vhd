LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY controller IS
	PORT (
		externalreset, memdataready : IN std_logic;
		clk, cflag, zflag : IN std_logic;
		irout : IN std_logic_vector(15 DOWNTO 0);
		ResetPC, PCplusI, PCplus1, RplusI, Rplus0 : OUT std_logic;
		RS_On_addressUnitRside, Rd_On_addressUnitRside, enablePc : OUT std_logic;
		b15to0, aandb, aorb, notb, aaddb, asubb, axorb, acompb, shrB, shlB, twicecompb, amulb : OUT std_logic;
		RFLwrite, RFHwrite, wpadd, wpreset, irload, srload, 
		address_on_databus, alu_on_databus, ir_on_lopndbus, ir_on_hopndbus, rfright_on_opndbus, cset, creset, zset, zreset, readmem, writemem,
		readio, writeio, shiftir : OUT std_logic;
		shadow : OUT std_logic
	);
END ENTITY;

ARCHITECTURE arc OF controller IS
 
	TYPE State_type IS (reset, halt, fetch, fetch2, fetch3, decode, exec2); -- Define the states
	SIGNAL peresents : State_Type := reset; 
	SIGNAL nexts : State_Type; 
 

	CONSTANT nop : std_logic_vector(7 DOWNTO 0) := 
	"00000000";
	CONSTANT hlt : std_logic_vector(7 DOWNTO 0) := 
	"00000001";
	CONSTANT szf : std_logic_vector(7 DOWNTO 0) := 
	"00000010";
	CONSTANT czf : std_logic_vector(7 DOWNTO 0) := 
	"00000011";
	CONSTANT scf : std_logic_vector(7 DOWNTO 0) := 
	"00000100";
	CONSTANT ccf : std_logic_vector(7 DOWNTO 0) := 
	"00000101";
	CONSTANT cwp : std_logic_vector(7 DOWNTO 0) := 
	"00000110";

	CONSTANT mvr : std_logic_vector(3 DOWNTO 0) := 
	"0001";
	CONSTANT lda : std_logic_vector(3 DOWNTO 0) := 
	"0010";
	CONSTANT sta : std_logic_vector(3 DOWNTO 0) := 
	"0011";
	CONSTANT inp : std_logic_vector(3 DOWNTO 0) := 
	"0100";
	CONSTANT oup : std_logic_vector(3 DOWNTO 0) := 
	"0101";
	CONSTANT andr : std_logic_vector(3 DOWNTO 0) := 
	"0110";
	CONSTANT orr : std_logic_vector(3 DOWNTO 0) := 
	"0111";
	CONSTANT notr : std_logic_vector(3 DOWNTO 0) := 
	"1000";
	CONSTANT shl : std_logic_vector(3 DOWNTO 0) := 
	"1001";
	CONSTANT shr : std_logic_vector(3 DOWNTO 0) := 
	"1010";
	CONSTANT add : std_logic_vector(3 DOWNTO 0) := 
	"1011";
	CONSTANT sub : std_logic_vector(3 DOWNTO 0) := 
	"1100";
	CONSTANT mul : std_logic_vector(3 DOWNTO 0) := 
	"1101";
	CONSTANT cmp : std_logic_vector(3 DOWNTO 0) := 
	"1110";

 
	SIGNAL instruction : std_logic_vector(7 DOWNTO 0) := "00000001";
	SIGNAL shadowsig : std_logic := '0';
BEGIN
	shadow <= shadowsig;
 
 
	PROCESS (instruction, peresents, externalreset, memdataready)
 

 
	BEGIN
		--reset signals
		ResetPC <= '0';
		PCplusI <= '0';
		PCplus1 <= '0';
		RplusI <= '0';
		Rplus0 <= '0';
		RS_On_addressUnitRside <= '0';
		Rd_On_addressUnitRside <= '0';
		enablePc <= '0';
		b15to0 <= '0';
		aandb <= '0';
		aorb <= '0';
		notb <= '0';
		aaddb <= '0';
		asubb <= '0';
		axorb <= '0';
		acompb <= '0';
		shrB <= '0';
		shlB <= '0';
		twicecompb <= '0';
		amulb <= '0';
		RFLwrite <= '0';
		RFHwrite <= '0';
		wpadd <= '0';
		wpreset <= '0';
		irload <= '0';
		srload <= '0';
		address_on_databus <= '0';
		alu_on_databus <= '0';
		ir_on_lopndbus <= '0';
		ir_on_hopndbus <= '0';
		rfright_on_opndbus <= '0';
		cset <= '0';
		creset <= '0';
		zset <= '0';
		zreset <= '0';
		readmem <= '0';
		writemem <= '0';
		readio <= '0';
		writeio <= '0';
		shiftir <= '0';
 
 
 
 
 
		IF externalreset = '1' THEN
					nexts <= reset;
		ELSE
			CASE peresents IS
				WHEN halt => 
					nexts <= halt;
					------------------------------------ 
				WHEN reset => 
					resetpc <= '1';
					EnablePC <= '1';
					--wpreset <= '1';
					creset <= '1';
					zreset <= '1';
					nexts <= fetch;
					------------------------------------ 
				WHEN fetch => 
					readmem <= '1';
					nexts <= fetch2;
					------------------------------------ 
				WHEN fetch2 => 
					IF memdataready = '0' THEN
						readmem <= '1';
						nexts <= fetch2;
					ELSE
						irload <= '1';
						shadowsig <= '0';
						nexts <= fetch3;
					END IF;
					------------------------------------
				WHEN fetch3 => 
					IF shadowsig = '0' THEN
						instruction <= irout(15 DOWNTO 8);
					ELSE
						instruction <= irout(7 DOWNTO 0);
					END IF;
					nexts <= decode;
					-------------------------------------
				WHEN decode => 
 
					--mil
					IF instruction(7 DOWNTO 4) = "1111" AND instruction(1 DOWNTO 0) = "00" THEN
						ir_on_lopndbus <= '1';
						--shadowsig <= '0';
						nexts <= exec2;
						--mih
					ELSIF instruction(7 DOWNTO 4) = "1111" AND instruction(1 DOWNTO 0) = "01" THEN
						ir_on_hopndbus <= '1';
						--shadowsig <= '0';
						nexts <= exec2; 
						--spc
					ELSIF instruction(7 DOWNTO 4) = "1111" AND instruction(1 DOWNTO 0) = "10" THEN
						PCplusI <= '1';
						address_on_databus <= '1';
						rflwrite <= '1';
						rfhwrite <= '1';
 
						--shadowsig <= '0';
						nexts <= fetch;
						PCplus1 <= '1';
						EnablePC <= '1';
						--jpa
					ELSIF instruction(7 DOWNTO 4) = "1111" AND instruction(1 DOWNTO 0) = "11" THEN
						rd_on_addressunitrside <= '1';
						nexts <= fetch;
						rplusI <= '1';
						EnablePC <= '1';
						--shadowsig <= '0';
						--jpr
					ELSIF instruction(7 DOWNTO 0) = "00000111" THEN
						nexts <= fetch;
						pcplusI <= '1';
						EnablePC <= '1';
						--shadowsig <= '0';
						--brz
					ELSIF instruction(7 DOWNTO 0) = "00001000" AND zflag = '1' THEN
						nexts <= fetch;
						pcplusI <= '1';
						EnablePC <= '1';
						--shadowsig <= '0';
						--brc
					ELSIF instruction(7 DOWNTO 0) = "00001001" AND cflag = '1' THEN
 
						nexts <= fetch;
						pcplusI <= '1';
						EnablePC <= '1';
						--shadowsig <= '0';
						--awp
					ELSIF instruction(7 DOWNTO 0) = "00001010" THEN
						wpadd <= '1';
						nexts <= fetch;
						pcplus1 <= '1';
						EnablePC <= '1';
						--shadowsig <= '0';
						--nop
					ELSIF instruction(7 DOWNTO 0) = nop THEN
						IF shadowsig = '1' THEN
							nexts <= fetch;
							PCplus1 <= '1';
							EnablePC <= '1';
						ELSE
							shadowsig <= '1';
							nexts <= fetch3;
						END IF;
						--hlt 
					ELSIF instruction(7 DOWNTO 0) = hlt THEN
						nexts <= halt;
						--szf
					ELSIF instruction(7 DOWNTO 0) = szf THEN
						zset <= '1';
						IF shadowsig = '1' THEN
							nexts <= fetch;
							PCplus1 <= '1';
							EnablePC <= '1';
						ELSE
							shadowsig <= '1';
							nexts <= fetch3;
						END IF;
						--czf
					ELSIF instruction(7 DOWNTO 0) = czf THEN
						zreset <= '1';
						IF shadowsig = '1' THEN
							nexts <= fetch;
							PCplus1 <= '1';
							EnablePC <= '1';
						ELSE
							shadowsig <= '1';
							nexts <= fetch3;
						END IF;
						--scf
					ELSIF instruction(7 DOWNTO 0) = scf THEN
						cset <= '1';
						IF shadowsig = '1' THEN
							nexts <= fetch;
							PCplus1 <= '1';
							EnablePC <= '1';
						ELSE
							shadowsig <= '1';
							nexts <= fetch3;
						END IF;
						--ccf
					ELSIF instruction(7 DOWNTO 0) = ccf THEN
						creset <= '1';
						IF shadowsig = '1' THEN
							nexts <= fetch;
							PCplus1 <= '1';
							EnablePC <= '1';
						ELSE
							shadowsig <= '1';
							nexts <= fetch3;
						END IF;
						--cwp
					ELSIF instruction(7 DOWNTO 0) = cwp THEN
						wpreset <= '1';
						IF shadowsig = '1' THEN
							nexts <= fetch;
							PCplus1 <= '1';
							EnablePC <= '1';
						ELSE
							shadowsig <= '1';
							nexts <= fetch3;
						END IF;
						-- end of case for first 7 istruction
					ELSE
						--case for instruction related to alu or register file
						CASE instruction(7 DOWNTO 4) IS
							--mvr
							WHEN mvr => 
								RFright_on_OpndBus <= '1';
								nexts <= exec2;
								--lda
							WHEN lda => 
								rplus0 <= '1';
								rs_on_addressunitrside <= '1';
								readmem <= '1';
								nexts <= exec2;
								--sta
							WHEN sta => 
								rplus0 <= '1';
								rd_on_addressunitrside <= '1';
								RFright_on_OpndBus <= '1';
								writemem <= '1';
								nexts <= exec2;
								--inp
							WHEN inp => 
								readio <= '1';
								nexts <= exec2;
								--oup
							WHEN oup => 
								--idont know
								writeio <= '1';
								RFright_on_OpndBus <= '1';
								nexts <= exec2;
								--and | or | not | shl | shr | add | sub | mul | cmp
							WHEN andr | orr | notr | shl | shr | add | sub | mul | cmp => 
								rfright_on_opndbus <= '1';
								nexts <= exec2;
							WHEN OTHERS => 
						END CASE;
						--end case for instruction related to alu or register file
					END IF;
 
 
					-------------------------------------
				WHEN exec2 => 
					CASE instruction(7 DOWNTO 4) IS
						--mvr
						WHEN mvr => 
							RFright_on_OpndBus <= '1';
							B15to0 <= '1';
							ALU_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							SRload <= '1';
						IF shadowsig = '1' THEN
							nexts <= fetch;
							PCplus1 <= '1';
							EnablePC <= '1';
						ELSE
							shadowsig <= '1';
							nexts <= fetch3;
						END IF;
							--lda
						WHEN lda => 
							IF memdataready = '0' THEN
								rplus0 <= '1';
								rs_on_addressunitrside <= '1';
								readmem <= '1';
								nexts <= exec2;
							ELSE
								rflwrite <= '1';
								rfhwrite <= '1';
								--check shadow
								IF shadowsig = '1' THEN
									nexts <= fetch;
									PCplus1 <= '1';
									EnablePC <= '1';
								ELSE
									shadowsig <= '1';
									nexts <= fetch3;
								END IF;
							END IF;
							--inp
						WHEN inp => 
							IF memdataready = '0' THEN
								readio <= '1';
								nexts <= exec2;
							ELSE
								rflwrite <= '1';
								rfhwrite <= '1';
								--check shadow
								IF shadowsig = '1' THEN
									nexts <= fetch;
									PCplus1 <= '1';
									EnablePC <= '1';
								ELSE
									shadowsig <= '1';
									nexts <= fetch3;
								END IF;
							END IF;
							--oup
						WHEN oup => 
							RFright_on_OpndBus <= '1';
							B15to0 <= '1';
							ALU_on_Databus <= '1';
							writeio <= '1';
								--check shadow
								IF shadowsig = '1' THEN
									nexts <= fetch;
									PCplus1 <= '1';
									EnablePC <= '1';
								ELSE
									shadowsig <= '1';
									nexts <= fetch3;
								END IF;
							--sta
						WHEN sta => 
							rplus0 <= '1';
							rd_on_addressunitrside <= '1';
							RFright_on_OpndBus <= '1';
							B15to0 <= '1';
							ALU_on_Databus <= '1';
							writemem <= '1';
								--check shadow
								IF shadowsig = '1' THEN
									nexts <= fetch;
									PCplus1 <= '1';
									EnablePC <= '1';
								ELSE
									shadowsig <= '1';
									nexts <= fetch3;
								END IF;
							--and
						WHEN andr => 
							RFright_on_OpndBus <= '1';
							aandb <= '1';
							ALU_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							SRload <= '1';
								--check shadow
								IF shadowsig = '1' THEN
									nexts <= fetch;
									PCplus1 <= '1';
									EnablePC <= '1';
								ELSE
									shadowsig <= '1';
									nexts <= fetch3;
								END IF;
							--or
						WHEN orr => 
							RFright_on_OpndBus <= '1';
							aorb <= '1';
							ALU_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							SRload <= '1';
								--check shadow
								IF shadowsig = '1' THEN
									nexts <= fetch;
									PCplus1 <= '1';
									EnablePC <= '1';
								ELSE
									shadowsig <= '1';
									nexts <= fetch3;
								END IF;
							--not
						WHEN notr => 
							RFright_on_OpndBus <= '1';
							notb <= '1';
							ALU_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							SRload <= '1';
								--check shadow
								IF shadowsig = '1' THEN
									nexts <= fetch;
									PCplus1 <= '1';
									EnablePC <= '1';
								ELSE
									shadowsig <= '1';
									nexts <= fetch3;
								END IF;
							--shl
						WHEN shl => 
							RFright_on_OpndBus <= '1';
							shlB <= '1';
							ALU_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							SRload <= '1';
								--check shadow
								IF shadowsig = '1' THEN
									nexts <= fetch;
									PCplus1 <= '1';
									EnablePC <= '1';
								ELSE
									shadowsig <= '1';
									nexts <= fetch3;
								END IF;
							--shr
						WHEN shr => 
							RFright_on_OpndBus <= '1';
							shrB <= '1';
							ALU_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							SRload <= '1';
								--check shadow
								IF shadowsig = '1' THEN
									nexts <= fetch;
									PCplus1 <= '1';
									EnablePC <= '1';
								ELSE
									shadowsig <= '1';
									nexts <= fetch3;
								END IF;
							--add
						WHEN add => 
							RFright_on_OpndBus <= '1';
							aaddb <= '1';
							ALU_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							SRload <= '1';
								--check shadow
								IF shadowsig = '1' THEN
									nexts <= fetch;
									PCplus1 <= '1';
									EnablePC <= '1';
								ELSE
									shadowsig <= '1';
									nexts <= fetch3;
								END IF;
							--sub
						WHEN sub => 
							RFright_on_OpndBus <= '1';
							asubb <= '1';
							ALU_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							SRload <= '1';
								--check shadow
								IF shadowsig = '1' THEN
									nexts <= fetch;
									PCplus1 <= '1';
									EnablePC <= '1';
								ELSE
									shadowsig <= '1';
									nexts <= fetch3;
								END IF;
							--mul
						WHEN mul => 
							RFright_on_OpndBus <= '1';
							amulb <= '1';
							ALU_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							SRload <= '1';
								--check shadow
								IF shadowsig = '1' THEN
									nexts <= fetch;
									PCplus1 <= '1';
									EnablePC <= '1';
								ELSE
									shadowsig <= '1';
									nexts <= fetch3;
								END IF;
							--shl
						WHEN cmp => 
							RFright_on_OpndBus <= '1';
							acompb <= '1';
							ALU_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							SRload <= '1';
								--check shadow
								IF shadowsig = '1' THEN
									nexts <= fetch;
									PCplus1 <= '1';
									EnablePC <= '1';
								ELSE
									shadowsig <= '1';
									nexts <= fetch3;
								END IF;
 
						WHEN OTHERS => 
				END CASE;
 
				IF instruction(7 DOWNTO 4) = "1111" AND instruction(1 DOWNTO 0) = "00" THEN
					--mil
					ir_on_lopndbus <= '1';
					B15to0 <= '1';
					ALU_on_Databus <= '1';
					rflwrite <= '1';
 
					nexts <= fetch;
					PCplus1 <= '1';
					EnablePC <= '1';
				ELSIF instruction(7 DOWNTO 4) = "1111" AND instruction(1 DOWNTO 0) = "01" THEN
					--mih
					ir_on_hopndbus <= '1';
					B15to0 <= '1';
					ALU_on_Databus <= '1';
					rfhwrite <= '1';
 
					nexts <= fetch;
					PCplus1 <= '1';
					EnablePC <= '1';
 
				END IF; 
				------------------------------------- 
				WHEN OTHERS => 
			END CASE;
		END IF;
	END PROCESS;
	--------------------------------------------------
 
	PROCESS (clk, externalreset)
		BEGIN
			IF clk'EVENT AND clk = '1' THEN
				peresents <= nexts;
			END IF;
		END PROCESS;
		END;