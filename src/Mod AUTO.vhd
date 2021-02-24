library ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_unsigned.all;


entity mod_auto is
	port(
	CLK: in std_logic;
	nr_sec: in std_logic_vector(2 downto 0);
	led: out std_logic; 
	reset: in std_logic
	);
end mod_auto;

architecture structural of mod_auto is

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

component demux_1_8 is
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
end component demux_1_8;	

component mux_8_1 is
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
end component mux_8_1;

component numarator_auto is
	port(
	en: in std_logic;
	reset: in std_logic;
	clk: in std_logic;
	duty_A: out std_logic_vector(7 downto 0)
	);
end component numarator_auto;	

signal clk_div_a_0: std_logic;
signal clk_div_a_1: std_logic;
signal clk_div_a_2: std_logic;
signal clk_div_a_3: std_logic;
signal clk_div_a_4: std_logic;
signal clk_div_a_5: std_logic;
signal clk_div_a_6: std_logic;
signal clk_div_a_7: std_logic;	

signal en_a_0: std_logic;
signal en_a_1: std_logic;
signal en_a_2: std_logic;
signal en_a_3: std_logic;
signal en_a_4: std_logic;
signal en_a_5: std_logic;
signal en_a_6: std_logic;
signal en_a_7: std_logic;	

signal clk_div_auto: std_logic;

signal Duty_Auto: std_logic_vector(7 downto 0);



begin 
	
	Div_A_0: divizor generic map(div_cu => 97847) port map(clk_in => CLK, reset => Reset, en => en_a_0, clk_div => clk_div_a_0);
	Div_A_1: divizor generic map(div_cu => 195694) port map(clk_in => CLK, reset => Reset, en => en_a_1, clk_div => clk_div_a_1);
	Div_A_2: divizor generic map(div_cu => 391389) port map(clk_in => CLK, reset => Reset, en => en_a_2, clk_div => clk_div_a_2);
	Div_A_3: divizor generic map(div_cu => 587095) port map(clk_in => CLK, reset => Reset, en => en_a_3, clk_div => clk_div_a_3);
	Div_A_4: divizor generic map(div_cu => 782778) port map(clk_in => CLK, reset => Reset, en => en_a_4, clk_div => clk_div_a_4);
	Div_A_5: divizor generic map(div_cu => 978473) port map(clk_in => CLK, reset => Reset, en => en_a_5, clk_div => clk_div_a_5);
	Div_A_6: divizor generic map(div_cu => 1174260) port map(clk_in => CLK, reset => Reset, en => en_a_6, clk_div => clk_div_a_6);
	Div_A_7: divizor generic map(div_cu => 1369863) port map(clk_in => CLK, reset => Reset, en => en_a_7, clk_div => clk_div_a_7);
	
	Demux_1_8_auto: demux_1_8 port map(en => '1', input => '1', out0 => en_a_0, out1 => en_a_1, out2 => en_a_2, out3 => en_a_3, out4 => en_a_4, out5 => en_a_5, out6 => en_a_6, out7 => en_a_7, sel => nr_sec);
	
	Mux_8_1_auto: mux_8_1 port map(en => '1', in0 => clk_div_a_0, in1 => clk_div_a_1, in2 => clk_div_a_2, in3 => clk_div_a_3, in4 => clk_div_a_4, in5 => clk_div_a_5, in6 => clk_div_a_6, in7 => clk_div_a_7, sel => nr_sec, output => clk_div_auto);
	
	Num_auto: numarator_auto port map(en => '1', reset => Reset, clk => clk_div_auto, duty_A => Duty_Auto);
	
	Gen: numarator_generator port map(en => '1', clk => CLK, pwm_duty => Duty_Auto, reset => Reset, led_signal => led);	
end architecture;