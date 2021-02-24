library ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_unsigned.all;



entity numarator_auto is
	port(
	en: in std_logic;
	reset: in std_logic;
	clk: in std_logic;
	duty_A: out std_logic_vector(7 downto 0)
	);
end numarator_auto;

architecture comportamental of numarator_auto is
begin
	process(reset,clk,en)
	variable numarator_auto: std_logic_vector(7 downto 0):=(others =>'0');
	variable direction: std_logic:='0';
	begin
		if reset='1' then
			numarator_auto :=(others =>'0'); 
			direction:='0';
		elsif clk'event and clk='1' and en='1' then   
			if direction='0' then
				numarator_auto:=numarator_auto+1;
				if numarator_auto=255 then
					direction:='1';
				end if;
			else 
				numarator_auto:=numarator_auto-1;
				if numarator_auto=0 then
					direction:='0';
				end if;
			end if;
		end if;
		duty_A <= numarator_auto;
	end process;
end architecture;