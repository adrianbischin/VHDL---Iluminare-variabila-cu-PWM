library ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_unsigned.all;


entity mod_test is
	port(
	CLK: in std_logic;						 
	led0: out std_logic;
	led1: out std_logic;
	led2: out std_logic;
	led3: out std_logic;
	Reset: in std_logic
	);
end mod_test;

architecture structural of mod_test is

component numarator_generator is
	port(
		en: in std_logic;
		clk: in std_logic;
		pwm_duty: in std_logic_vector(7 downto 0);
		Reset: in std_logic;
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

component numarator_test is
	port(
	en: in std_logic;
	reset: in std_logic;
	clk: in std_logic;
	duty_T: out std_logic_vector(7 downto 0)
	);
end component numarator_test;

signal clk_div_pwm_gen: std_logic;	 

signal clk_div_t_0: std_logic;																														   
signal clk_div_t_1: std_logic;
signal clk_div_t_2: std_logic;
signal clk_div_t_3: std_logic;

signal Duty_T_0: std_logic_vector(7 downto 0);
signal Duty_T_1: std_logic_vector(7 downto 0);
signal Duty_T_2: std_logic_vector(7 downto 0);
signal Duty_T_3: std_logic_vector(7 downto 0);

begin 
	
	Div_T_0: divizor generic map(div_cu => 390625) port map(clk_in => CLK, reset => Reset, en => '1', clk_div => clk_div_t_0);
	Div_T_1: divizor generic map(div_cu => 781250) port map(clk_in => CLK, reset => Reset, en => '1', clk_div => clk_div_t_1);
	Div_T_2: divizor generic map(div_cu => 1171920) port map(clk_in => CLK, reset => Reset, en => '1', clk_div => clk_div_t_2);
	Div_T_3: divizor generic map(div_cu => 1562500) port map(clk_in => CLK, reset => Reset, en => '1', clk_div => clk_div_t_3);
	
	
	Num_test_0: numarator_test port map(en => '1', reset => Reset, clk => clk_div_t_0, duty_T => Duty_T_0);
	Num_test_1: numarator_test port map(en => '1', reset => Reset, clk => clk_div_t_1, duty_T => Duty_T_1);
	Num_test_2: numarator_test port map(en => '1', reset => Reset, clk => clk_div_t_2, duty_T => Duty_T_2);
	Num_test_3: numarator_test port map(en => '1', reset => Reset, clk => clk_div_t_3, duty_T => Duty_T_3);
	
	PWM_Gen_0: numarator_generator port map(en => '1', clk => CLK, pwm_duty => Duty_T_0, reset => Reset, led_signal => led0);
	PWM_Gen_1: numarator_generator port map(en => '1', clk => CLK, pwm_duty => Duty_T_1, reset => Reset, led_signal => led1);
	PWM_Gen_2: numarator_generator port map(en => '1', clk => CLK, pwm_duty => Duty_T_2, reset => Reset, led_signal => led2);
	PWM_Gen_3: numarator_generator port map(en => '1', clk => CLK, pwm_duty => Duty_T_3, reset => Reset, led_signal => led3);
	
end architecture;