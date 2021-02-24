library ieee;
use ieee.std_logic_1164.all;

entity demux_1_4 is
	port(
	en: in std_logic;  
	input: in std_logic;
	out0: out std_logic;
	out1: out std_logic;
	out2: out std_logic;
	out3: out std_logic;
	sel: in std_logic_vector(1 downto 0)
	);
end demux_1_4;

architecture comp of demux_1_4 is
begin			 
	process(en,sel,input)
	begin
		if en='1' then
			case sel is
				when "00" => out0 <= input;
							 out1 <= '0'; out2 <= '0'; out3 <= '0';
				when "01" => out1 <= input;	
							 out0 <= '0'; out2 <= '0'; out3 <= '0';
				when "10" => out2 <= input;	   
							 out0 <= '0'; out1 <= '0'; out3 <= '0';
				when "11" => out3 <= input;
							 out0 <= '0'; out1 <= '0'; out2 <= '0';
				when others => null;
			end case;
		end if;
	end process;
end architecture;