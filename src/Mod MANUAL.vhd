library ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_unsigned.all;


entity mod_manual is
	port(
	clk: in std_logic;
	M_Duty: in std_logic_vector(7 downto 0);
	led: out std_logic; 
	reset: in std_logic
	);
end mod_manual;

architecture structural of mod_manual is

component numarator_generator is
	port(
		en: in std_logic;
		clk: in std_logic;
		pwm_duty: in std_logic_vector(7 downto 0);
		reset: in std_logic;
		led_signal: out std_logic
		);
end component numarator_generator; 

component divizor is
	generic(div_cu: natural);
	port(
	clk_in: in std_logic;
	reset: in std_logic;  
	en: in std_logic;
	clk_div: out std_logic);
end component divizor;

signal clk_div_pwm_gen: std_logic;

begin 
	Div_pwm: divizor generic map(div_cu => 4) port map(clk_in => CLK, reset => reset, en => '1', clk_div => clk_div_pwm_gen);
	Gen: numarator_generator port map(en => '1', clk => clk_div_pwm_gen, pwm_duty => M_Duty, reset => reset, led_signal => led);	
end architecture;