library ieee;
use ieee.std_logic_1164.all;

--Numaratorul divizorului
entity numarator_divizor is
	
	generic(MV: natural);
	
	port(
	en: in std_logic;
	clk: in std_logic;
	reset: in std_logic;
	ended: out std_logic
	);
	
end numarator_divizor;

architecture comp of  numarator_divizor is
begin
	process(clk,reset,en)
	variable nr: natural;
	begin
		if reset='1' then
			nr:=0; 
			ended <='0';
		elsif clk'event and clk='1'	then
			if en='1' then
				if nr<MV then
					if nr=MV-1 then 
						ended <= '1';
					else 
						ended <= '0';
					end if;
					nr:=nr+1;
				else 
					ended <= '0'; 
					nr:=0;
				end if;
			else
				nr:=nr;
				ended <= 'Z';
			end if;
		end if;	
	end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
--Bistabilul_T al divizorului
entity bist_T is
	port(
	reset: in std_logic;
	T: in std_logic;
	en: in std_logic;
	clk_in: in std_logic;
	Q: out std_logic
	);
end bist_T;

architecture comp of bist_T is
begin
	process (clk_in,reset,T)
	variable val: std_logic:='0';
	begin
		if reset='1' then
			val:='0';
		else
			if clk_in'event and clk_in='1' and T='1' then
				 if en='1' then
					if val='1' then
						val := '0';
					else
						val := '1';
					end if;	
				else
					val:=val;
				end if;
			end if;
		end if;
		Q <= val;
	end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
--Divizorul compus din numarator signal bistabil_T
entity divizor is
	generic(div_cu: natural);
	port(
	clk_in: in std_logic;
	reset: in std_logic;  
	en: in std_logic;
	clk_div: out std_logic);
end divizor;	   

architecture structural of divizor is

component numarator_divizor
	generic(MV: natural);
	
	port(
	en: in std_logic;
	clk: in std_logic;
	reset: in std_logic;
	ended: out std_logic
	);
end component;

component bist_T
	port(
	reset: in std_logic;
	T: in std_logic:='1';
	en: in std_logic;
	clk_in: in std_logic;
	Q: out std_logic
	);
end component;

signal S: std_logic;

begin
	C1: numarator_divizor generic map(MV => div_cu-1) port map(en => en, clk => clk_in, reset => reset, ended => S);						  
	C2: bist_T port map(reset => reset, T => '1',en => en, clk_in => S, Q => clk_div);
	
	
end architecture;