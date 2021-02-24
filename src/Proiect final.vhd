library ieee;
use ieee.std_logic_1164.all;

--interfata proiectului
entity proiect_pwm is
	port(
	M_Duty_Board: in std_logic_vector(7 downto 0);
	Mode: in std_logic_vector(1 downto 0);
	nr_sec: in std_logic_vector(2 downto 0);
	Board_CLK: in std_logic;
	led_0: out std_logic;
	led_1: out std_logic;
	led_2: out std_logic;
	led_3: out std_logic;
	led_4: out std_logic;
	led_5: out std_logic;
	led_6: out std_logic;
	led_7: out std_logic; 
	Anod: out std_logic_vector(7 downto 0);
	Code: out std_logic_vector(0 to 6)
	);
end proiect_pwm;

--arhitectura proiectului
architecture comp of proiect_pwm is

--componentele nivelului cel mai inalt
component demux_1_4 is
	port(
	en: in std_logic;  
	input: in std_logic;
	out0: out std_logic;
	out1: out std_logic;
	out2: out std_logic;
	out3: out std_logic;
	sel: in std_logic_vector(1 downto 0)
	);
end component demux_1_4;

component divizor is
	generic(div_cu: natural);
	port(
	clk_in: in std_logic;
	reset: in std_logic;  
	en: in std_logic;
	clk_div: out std_logic
	);
end component divizor;

component mux_4_1_8bit is
	port(
	en: in std_logic;
	in0: in std_logic_vector(7 downto 0);
	in1: in std_logic_vector(7 downto 0);
	in2: in std_logic_vector(7 downto 0);
	in3: in std_logic_vector(7 downto 0);
	sel: in std_logic_vector(1 downto 0);
	output: out std_logic_vector(7 downto 0)
	);
end component mux_4_1_8bit;		

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

component numarator_auto is
	port(
	en: in std_logic;
	reset: in std_logic;
	clk: in std_logic;
	duty_A: out std_logic_vector(7 downto 0)
	);
end component numarator_auto;	

component numarator_generator is
	port(
		en: in std_logic;
		clk: in std_logic;
		pwm_duty: in std_logic_vector(7 downto 0);
		reset: in std_logic;
		led_signal: out std_logic
		);
end component numarator_generator; 

component numarator_test is
	port(
	en: in std_logic;
	reset: in std_logic;
	clk: in std_logic;
	duty_T: out std_logic_vector(7 downto 0)
	);
end component numarator_test;	  

component afisor2 is
	port(
		clk: in std_logic;
		mode: in std_logic_vector(1 downto 0);	
		nr_sec: in std_logic_vector(2 downto 0);
		anod: out std_logic_vector(7 downto 0);
		code: out std_logic_vector(0 to 6)
	);
end component afisor2;

--semnale de la selectorul modului(demux 1:4)
signal Auto_Enable: std_logic;
signal Test_Enable: std_logic;
signal Reset: std_logic;
--semnalele de la divizoarele de frecventa ale modului auto
signal clk_div_a_0: std_logic;
signal clk_div_a_1: std_logic;
signal clk_div_a_2: std_logic;
signal clk_div_a_3: std_logic;
signal clk_div_a_4: std_logic;
signal clk_div_a_5: std_logic;
signal clk_div_a_6: std_logic;
signal clk_div_a_7: std_logic;
--semnalele de la demux pentru enable divizoare auto
signal en_a_0: std_logic;
signal en_a_1: std_logic;
signal en_a_2: std_logic;
signal en_a_3: std_logic;
signal en_a_4: std_logic;
signal en_a_5: std_logic;
signal en_a_6: std_logic;
signal en_a_7: std_logic;
--semnalele de la divizoarele de frecventa ale modului test																							   
signal clk_div_t_0: std_logic;																														   
signal clk_div_t_1: std_logic;
signal clk_div_t_2: std_logic;
signal clk_div_t_3: std_logic;
signal clk_div_t_4: std_logic;
signal clk_div_t_5: std_logic;
signal clk_div_t_6: std_logic;
signal clk_div_t_7: std_logic;
--clock divizat al modului auto
signal clk_div_auto: std_logic;
--factorul de umplere al modului auto
signal Duty_Auto: std_logic_vector(7 downto 0); 
--factorii de umplere de la modul test
signal Duty_T_0: std_logic_vector(7 downto 0);
signal Duty_T_1: std_logic_vector(7 downto 0);
signal Duty_T_2: std_logic_vector(7 downto 0);
signal Duty_T_3: std_logic_vector(7 downto 0);
signal Duty_T_4: std_logic_vector(7 downto 0);
signal Duty_T_5: std_logic_vector(7 downto 0);
signal Duty_T_6: std_logic_vector(7 downto 0);
signal Duty_T_7: std_logic_vector(7 downto 0);	  
--factorii de umplere pentru generatorul fiecarui led
signal l_0: std_logic_vector(7 downto 0);	
signal l_1: std_logic_vector(7 downto 0);
signal l_2: std_logic_vector(7 downto 0);
signal l_3: std_logic_vector(7 downto 0);
signal l_4: std_logic_vector(7 downto 0);
signal l_5: std_logic_vector(7 downto 0);
signal l_6: std_logic_vector(7 downto 0);
signal l_7: std_logic_vector(7 downto 0);
--semnal enable sistem (not Reset)
signal EN: std_logic;

begin 
	
	--cand Reset=1 -> EN=0 si cand Reset=0 -> EN=1	
	EN <= not Reset;
	--instantiere demux
	Demux_mod: demux_1_4 port map(en => '1', input => '1', out0 => Reset, out2 => Auto_Enable, out3 => Test_Enable, sel => Mode);
	--instantiere demux pentru enable divizor fracventa
	Demux_1_8_auto: demux_1_8 port map(en => EN, input => '1', out0 => en_a_0, out1 => en_a_1, out2 => en_a_2, out3 => en_a_3, out4 => en_a_4, out5 => en_a_5, out6 => en_a_6, out7 => en_a_7, sel => nr_sec);
	--instantierile divizoarelor pentru modul auto
	Div_A_0: divizor generic map(div_cu => 49019) port map(clk_in => Board_CLK, reset => Reset, en => en_a_0, clk_div => clk_div_a_0);
	Div_A_1: divizor generic map(div_cu => 98039) port map(clk_in => Board_CLK, reset => Reset, en => en_a_1, clk_div => clk_div_a_1);
	Div_A_2: divizor generic map(div_cu => 196078) port map(clk_in => Board_CLK, reset => Reset, en => en_a_2, clk_div => clk_div_a_2);
	Div_A_3: divizor generic map(div_cu => 294117) port map(clk_in => Board_CLK, reset => Reset, en => en_a_3, clk_div => clk_div_a_3);
	Div_A_4: divizor generic map(div_cu => 392156) port map(clk_in => Board_CLK, reset => Reset, en => en_a_4, clk_div => clk_div_a_4);
	Div_A_5: divizor generic map(div_cu => 490191) port map(clk_in => Board_CLK, reset => Reset, en => en_a_5, clk_div => clk_div_a_5);
	Div_A_6: divizor generic map(div_cu => 588235) port map(clk_in => Board_CLK, reset => Reset, en => en_a_6, clk_div => clk_div_a_6);
	Div_A_7: divizor generic map(div_cu => 686247) port map(clk_in => Board_CLK, reset => Reset, en => en_a_7, clk_div => clk_div_a_7);
	--instantierile divizoarelor pentru modul test
	Div_T_0: divizor generic map(div_cu => 195312) port map(clk_in => Board_CLK, reset => Reset, en => Test_Enable, clk_div => clk_div_t_0);
	Div_T_1: divizor generic map(div_cu => 390625) port map(clk_in => Board_CLK, reset => Reset, en => Test_Enable, clk_div => clk_div_t_1);
	Div_T_2: divizor generic map(div_cu => 585960) port map(clk_in => Board_CLK, reset => Reset, en => Test_Enable, clk_div => clk_div_t_2);
	Div_T_3: divizor generic map(div_cu => 781250) port map(clk_in => Board_CLK, reset => Reset, en => Test_Enable, clk_div => clk_div_t_3);
	Div_T_4: divizor generic map(div_cu => 976562) port map(clk_in => Board_CLK, reset => Reset, en => Test_Enable, clk_div => clk_div_t_4);
	Div_T_5: divizor generic map(div_cu => 1172058) port map(clk_in => Board_CLK, reset => Reset, en => Test_Enable, clk_div => clk_div_t_5);
	Div_T_6: divizor generic map(div_cu => 1367240) port map(clk_in => Board_CLK, reset => Reset, en => Test_Enable, clk_div => clk_div_t_6);
	Div_T_7: divizor generic map(div_cu => 1562500) port map(clk_in => Board_CLK, reset => Reset, en => Test_Enable, clk_div => clk_div_t_7);
	--instantierea multiplexorului modului auto -->mux 8:1
	Mux_8_1_auto: mux_8_1 port map(en => Auto_Enable, in0 => clk_div_a_0, in1 => clk_div_a_1, in2 => clk_div_a_2, in3 => clk_div_a_3, in4 => clk_div_a_4, in5 => clk_div_a_5, in6 => clk_div_a_6, in7 => clk_div_a_7, sel => nr_sec, output => clk_div_auto);
	--instantierea numaratorului modului auto
	Num_auto: numarator_auto port map(en => Auto_Enable, reset => Reset, clk => clk_div_auto, duty_A => Duty_Auto);	  
	--instantierea numaratoarelor modului test
	
	--Gen_test_num: for I in 7 downto 0 generate
	--	Num_test_I: numarator_test port map(en => Test_Enable, reset => Reset, clk => clk_div_t_I, duty_T => Duty_t_I);
	--end generate Gen_test_num;
	Num_test_0: numarator_test port map(en => Test_Enable, reset => Reset, clk => clk_div_t_0, duty_T => Duty_T_0);
	Num_test_1: numarator_test port map(en => Test_Enable, reset => Reset, clk => clk_div_t_1, duty_T => Duty_T_1);
	Num_test_2: numarator_test port map(en => Test_Enable, reset => Reset, clk => clk_div_t_2, duty_T => Duty_T_2);
	Num_test_3: numarator_test port map(en => Test_Enable, reset => Reset, clk => clk_div_t_3, duty_T => Duty_T_3);
	Num_test_4: numarator_test port map(en => Test_Enable, reset => Reset, clk => clk_div_t_4, duty_T => Duty_T_4);
	Num_test_5: numarator_test port map(en => Test_Enable, reset => Reset, clk => clk_div_t_5, duty_T => Duty_T_5);
	Num_test_6: numarator_test port map(en => Test_Enable, reset => Reset, clk => clk_div_t_6, duty_T => Duty_T_6);
	Num_test_7: numarator_test port map(en => Test_Enable, reset => Reset, clk => clk_div_t_7, duty_T => Duty_T_7);	   
	--instantierea multiplexoarelor pentru intrarile generatorului
	Mux_pwm_0: mux_4_1_8bit port map(en => EN, in0 => "00000000", in1 => M_Duty_Board, in2 => Duty_Auto, in3 => Duty_T_0, sel => Mode, output => l_0);
	Mux_pwm_1: mux_4_1_8bit port map(en => EN, in0 => "00000000", in1 => M_Duty_Board, in2 => Duty_Auto, in3 => Duty_T_1, sel => Mode, output => l_1);
	Mux_pwm_2: mux_4_1_8bit port map(en => EN, in0 => "00000000", in1 => M_Duty_Board, in2 => Duty_Auto, in3 => Duty_T_2, sel => Mode, output => l_2);
	Mux_pwm_3: mux_4_1_8bit port map(en => EN, in0 => "00000000", in1 => M_Duty_Board, in2 => Duty_Auto, in3 => Duty_T_3, sel => Mode, output => l_3);
	Mux_pwm_4: mux_4_1_8bit port map(en => EN, in0 => "00000000", in1 => M_Duty_Board, in2 => Duty_Auto, in3 => Duty_T_4, sel => Mode, output => l_4);
	Mux_pwm_5: mux_4_1_8bit port map(en => EN, in0 => "00000000", in1 => M_Duty_Board, in2 => Duty_Auto, in3 => Duty_T_5, sel => Mode, output => l_5);
	Mux_pwm_6: mux_4_1_8bit port map(en => EN, in0 => "00000000", in1 => M_Duty_Board, in2 => Duty_Auto, in3 => Duty_T_6, sel => Mode, output => l_6);
	Mux_pwm_7: mux_4_1_8bit port map(en => EN, in0 => "00000000", in1 => M_Duty_Board, in2 => Duty_Auto, in3 => Duty_T_7, sel => Mode, output => l_7);
	--instantierea generatoarelor
	PWM_Gen_0: numarator_generator port map(en => EN, clk => Board_CLK, pwm_duty => l_0, reset => Reset, led_signal => led_0);
	PWM_Gen_1: numarator_generator port map(en => EN, clk => Board_CLK, pwm_duty => l_1, reset => Reset, led_signal => led_1);
	PWM_Gen_2: numarator_generator port map(en => EN, clk => Board_CLK, pwm_duty => l_2, reset => Reset, led_signal => led_2);
	PWM_Gen_3: numarator_generator port map(en => EN, clk => Board_CLK, pwm_duty => l_3, reset => Reset, led_signal => led_3);
	PWM_Gen_4: numarator_generator port map(en => EN, clk => Board_CLK, pwm_duty => l_4, reset => Reset, led_signal => led_4);
	PWM_Gen_5: numarator_generator port map(en => EN, clk => Board_CLK, pwm_duty => l_5, reset => Reset, led_signal => led_5);
	PWM_Gen_6: numarator_generator port map(en => EN, clk => Board_CLK, pwm_duty => l_6, reset => Reset, led_signal => led_6);
	PWM_Gen_7: numarator_generator port map(en => EN, clk => Board_CLK, pwm_duty => l_7, reset => Reset, led_signal => led_7);
	--instantierea afisorului
	Afis: afisor2 port map(clk => Board_CLK,mode => Mode, nr_sec => nr_sec, anod => Anod, code => Code); 
	
end architecture;






