library ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_unsigned.all;



entity numarator_test is
	port(
	en: in std_logic;
	reset: in std_logic;
	clk: in std_logic;
	duty_T: out std_logic_vector(7 downto 0)
	);
end numarator_test;

architecture comportamental of numarator_test is

begin
	process(reset,clk,en)
	variable numarator_test: std_logic_vector(7 downto 0):=(others =>'0');
	begin
		if reset='1' then
			numarator_test :=(others =>'0');  
		elsif clk'event and clk='1' and en='1' then   
			numarator_test:=numarator_test+1;
		end if;
		duty_T <= numarator_test;
	end process;
end architecture;