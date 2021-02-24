										 library ieee;
use ieee.std_logic_1164.all;

entity mux_4_1_8bit is
	port(
	en: in std_logic;
	in0: in std_logic_vector(7 downto 0);
	in1: in std_logic_vector(7 downto 0);
	in2: in std_logic_vector(7 downto 0);
	in3: in std_logic_vector(7 downto 0);
	sel: in std_logic_vector(1 downto 0);
	output: out std_logic_vector(7 downto 0)
	);
end mux_4_1_8bit;

architecture comp of mux_4_1_8bit is		 
begin
	process(en,sel,in0,in1,in2,in3)									   
	begin			  
		if en='1' then
			case sel is
				when "00" => output <= in0;
				when "01" => output <= in1;
				when "10" => output <= in2;
				when "11" => output <= in3;
				when others => output <= "00000000";
			end case;
		else output <= "00000000";
		end if;		  		
	end process;
end architecture;