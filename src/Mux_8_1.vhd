library ieee;
use ieee.std_logic_1164.all;

entity mux_8_1 is
	port(
	en: in std_logic;
	in0: in std_logic;
	in1: in std_logic;
	in2: in std_logic;
	in3: in std_logic;
	in4: in std_logic;
	in5: in std_logic;
	in6: in std_logic;
	in7: in std_logic;
	sel: in std_logic_vector(2 downto 0);
	output: out std_logic
	);
end mux_8_1;

architecture comp of mux_8_1 is		 
begin
	process(en,sel,in0,in1,in2,in3,in4,in5,in6,in7)									   
	begin			  
		if en='1' then
			case sel is
				when "000" => output <= in0;
				when "001" => output <= in1;
				when "010" => output <= in2;
				when "011" => output <= in3;
				when "100" => output <= in4;
				when "101" => output <= in5;
				when "110" => output <= in6;
				when "111" => output <= in7;
				when others => output <= '0';
			end case;
		else output <= '0';
		end if;		  		
	end process;
end architecture;