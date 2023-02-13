library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity GCC_Bit_Sampler is
generic ( 
	N: Integer := 288 -- 
); 
port (
	Cin: in std_logic_vector(5 downto 0);	-- 2uS period for each sampled bit
	Din : in std_logic; 							-- Data Line to sample bits from
	sample : in std_logic; 						-- Start
	done : out std_logic := '1'; 				-- Stop
	buttons : out std_logic_vector(3 downto 0) -- 		-- status of button states
  );
end GCC_Bit_Sampler;

architecture bit_sampler of GCC_Bit_Sampler is 

	signal bits: std_logic := '0';
	--signal state: std_logic := '1';								
	--signal latch_debounce: std_logic:= '0';
	--signal latch_debounce: std_logic := '0';
	--signal din : std_logic := '1';
	
begin			-- LED3 = 1 --- LED2 = 0 --- LED1 = 0 --- LED0 = 0 ------ 

	
	process(Cin(5)) 
		variable count : integer range 0 to N := 0; -- bits(count) iterates through bits from RIGHT to LEFT 
		variable bitcount : integer range 0 to 5 := 0;
	begin
	
		if( sample = '0' and rising_edge(Cin(5)) ) then
			done <= '0';
			count := 0;
		end if;
	
		if(rising_edge(Cin(5)) and sample = '1') then-- and (sample='1')) -- when enabled ----> Sample the bit
				
				if(count = 12 or count = 15 or count = 20 or count = 24) then	-- if each GCC bit is 4uS in length & being able to tell if its 1 or 0 happens after 2uS then we need to count on the odd bit after every bit ( each sample bit length of each GCC bit is 2x ) 
					buttons(bitcount) <= Din; -- sample the 4th bit 
					bitcount := bitcount + 1;										--if(count = 104 or count = 105 or count = 106 or count = 107) 
					--stop <= '1'; 			
					--count := 9;
				--else
					--LED <= '0'; -- show the status of the bit ( should change with button press ) 
					--stop <= '0';
				end if;
				
				if(count /= N) then 
					count := count + 1;	
					done <= '0';	
				else 
					done <= '1';
				end if;
				
		end if; 
		--stop <= Cin(6);
	end process;		-- When this vhdl block finishes after reading all the GCC bytes then have it tell the other vhdl block to reset the counter to read again
	
	
	
end architecture;
