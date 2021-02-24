library ieee;
use ieee.std_logic_1164.all;

--bistabil T
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

--mux 2:1 pe 4 biti
entity mux_2_1_4bit is
	port(
		en: in std_logic;
		in0: in std_logic_vector(2 downto 0);
		in1: in std_logic_vector(2 downto 0);
		sel: in std_logic;
		output: out std_logic_vector(2 downto 0)
	);
end mux_2_1_4bit;

architecture comp of mux_2_1_4bit is		 
begin
	process(en,sel,in0,in1)									   
	begin			  
		if en='1' then
			case sel is
				when '0' => output <= in0;
				when '1' => output <= in1;	
				when others => output <= "000";
			end case;
		else output <= "000";
		end if;		  		
	end process;
end architecture;


library ieee;
use ieee.std_logic_1164.all;

--decodificator 7 segmente
entity decoder is
	port(
		digit: in std_logic_vector(2 downto 0);
		seg_code: out std_logic_vector(0 to 6)
	);
end entity;

architecture comp of decoder is
begin
	process(digit)
	begin
		case digit is
			when "000" => seg_code <= "0000001";
			when "001" => seg_code <= "1001111";
			when "010" => seg_code <= "0010010";
			when "011" => seg_code <= "0000110";
			when "100" => seg_code <= "1001100";
			when "101" => seg_code <= "0100100";
			when "110" => seg_code <= "0100000";
			when "111" => seg_code <= "0001111";
			when others => seg_code <= "1111111";	
		end case;  
	end process;
end architecture;	  


library ieee;
use ieee.std_logic_1164.all;

--AFISORUL PROPRIU-ZIS----------------------------------------------------------------------------------------------------
entity afisor2 is
	port(
		clk: in std_logic;
		mode: in std_logic_vector(1 downto 0);	
		nr_sec: in std_logic_vector(2 downto 0);
		anod: out std_logic_vector(7 downto 0);
		code: out std_logic_vector(0 to 6)
	);
end afisor2;

architecture arh_afisor of afisor2 is

component decoder is
	port(
		digit: in std_logic_vector(2 downto 0);
		seg_code: out std_logic_vector(0 to 6)
	);
end component decoder;		

component mux_2_1_4bit is
	port(
		en: in std_logic;
		in0: in std_logic_vector(2 downto 0);
		in1: in std_logic_vector(2 downto 0);
		sel: in std_logic;
		output: out std_logic_vector(2 downto 0)
	);
end component mux_2_1_4bit;

component bist_T is
	port(
		reset: in std_logic;
		T: in std_logic;
		en: in std_logic;
		clk_in: in std_logic;
		Q: out std_logic
	);
end component bist_T;

component divizor is
	generic(div_cu: natural);
	port(
	clk_in: in std_logic;
	reset: in std_logic;  
	en: in std_logic;
	clk_div: out std_logic);
end component divizor;	 


signal dig: std_logic_vector(2 downto 0);
signal clk_div: std_logic; 
signal res_bist: std_logic;
signal sel: std_logic;	
signal not_sel: std_logic;

begin
	
	process(mode)
	begin  
		case mode is
			when "00" => res_bist <= '1';
			when "01" => res_bist <= '1';
			when "10" => res_bist <= '0';
			when "11" => res_bist <= '1';
			when others => res_bist <= '1';
		end case;
	end process;
	
	Div: divizor generic map(div_cu => 500000) port map(clk_in => clk, reset => '0', en => '1', clk_div => clk_div);
	
	Bist: bist_T port map(reset => res_bist, T => '1',en => '1', clk_in => clk_div, Q => sel);
	
	Mux: mux_2_1_4bit port map(en => '1', in0(1 downto 0) => mode, in0(2) => '0', in1 => nr_sec, sel => sel, output => dig); 
	
	Decode: decoder port map(digit => dig, seg_code => code);
	
	not_sel <= not sel;
	
	anod(7 downto 5) <= "111";
	anod(3 downto 1) <= "111";
	anod(4)	<= not_sel;
	anod(0)	<= sel;
	
end architecture ;