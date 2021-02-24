library ieee;
use ieee.std_logic_1164.all;

entity demux_1_8 is
	port(
	en: in std_logic;  
	input: in std_logic;
	out0: out std_logic;
	out1: out std_logic;
	out2: out std_logic;
	out3: out std_logic;
	out4: out std_logic;
	out5: out std_logic;
	out6: out std_logic;
	out7: out std_logic;
	sel: in std_logic_vector(2 downto 0)
	);
end demux_1_8;

architecture comp of demux_1_8 is
begin			 
	process(en,sel,input)
	begin
		if en='1' then
			case sel is
				when "000" => out0 <= input;	
							  out1 <= '0'; out2 <= '0';out3 <= '0';out4 <= '0';out5 <= '0';out6 <= '0';out7 <= '0';
				when "001" => out1 <= input;  
							  out0 <= '0'; out2 <= '0';out3 <= '0';out4 <= '0';out5 <= '0';out6 <= '0';out7 <= '0';
				when "010" => out2 <= input;
							  out0 <= '0'; out1 <= '0';out3 <= '0';out4 <= '0';out5 <= '0';out6 <= '0';out7 <= '0';
				when "011" => out3 <= input;
							  out0 <= '0'; out1 <= '0';out2 <= '0';out4 <= '0';out5 <= '0';out6 <= '0';out7 <= '0';
				when "100" => out4 <= input;
							  out0 <= '0'; out1 <= '0';out2 <= '0';out3 <= '0';out5 <= '0';out6 <= '0';out7 <= '0';
				when "101" => out5 <= input;
							  out0 <= '0'; out1 <= '0';out2 <= '0';out3 <= '0';out4 <= '0';out6 <= '0';out7 <= '0';
				when "110" => out6 <= input;
							  out0 <= '0'; out1 <= '0';out2 <= '0';out3 <= '0';out4 <= '0';out5 <= '0';out7 <= '0';
				when "111" => out7 <= input;
							  out0 <= '0'; out1 <= '0';out2 <= '0';out3 <= '0';out4 <= '0';out5 <= '0';out6 <= '0';
				when others => null;
			end case;
		end if;
	end process;
end architecture;