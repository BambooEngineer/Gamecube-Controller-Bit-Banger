library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity GCC_Talker is
generic ( 
	N: Integer := 108 -- 1 GCC command is 1 byte, 1 byte is 9 bits, each bit is split into 4x 1uS bits for the FPGA to replicate : 0x40, 0x03, 0x02 = (9*4)*3 = 108
); -- 9 sets of 4 bits to make a gamecube byte + 1x stop bit( 4 + bits ) 
port (
	clk: in std_logic_vector(5 downto 0);	-- 1uS period of each bit
	Dout : out std_logic := '0';
	start : in std_logic;
	finished : out std_logic := '0';
	Reset : in std_logic
	--LEDs : out std_logic_vector(N-1 downto 0)
  );
end GCC_Talker;

architecture serializer of GCC_Talker is 

	signal bits: std_logic_vector(N-1 DOWNTO 0) := "111010001000100010001000111010001000111010001000100010001110111010001000111010001000100010001000100011101000"; --0--1--0--1--0--1 ---> bits on gpio 000101110001011100010111 ----> bits stored 111010001110100011101000
	signal state: std_logic := '1';								-- 0x40, 0x03, 0x02 GCC commands from bits starting with LSB to MSB ---- RIGHT TO LEFT
	--signal latch_debounce: std_logic:= '0';
	--signal latch_debounce: std_logic := '0';
	--signal din : std_logic := '1';
	
begin

	
	process(clk(5), start) 
		variable count : integer range 0 to N := 0; -- bits(count) iterates through bits from RIGHT to LEFT ( invert the bits )
	begin
		
		if(rising_edge(clk(5)) and start = '0') then 
			if(count < N-1) then 
				count := count + 1;
			   finished <= '0';
			else 								-- get rid of the else statement to have it stop after sending bits
				--count := 0;
				finished <= '1';	-- THIS SIGNAL WILL TURN ON THE GCC BIT SAMPLER/READER
				--state <= '1';
			end if;
			
			if(Reset = '1') then
				finished <= '0';
				count := 0;
			end if;
			
			Dout <= bits(count); 
		end if; 
	end process;
	
	
	
	
	
end architecture;