library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity numarator_generator is
	port(
		en: in std_logic;
		clk: in std_logic;
		pwm_duty: in std_logic_vector(7 downto 0);
		reset: in std_logic;
		led_signal: out std_logic
		);
end numarator_generator;

architecture comp of numarator_generator is
begin
	process(clk,reset,pwm_duty,en)
		variable numarator_pwm: std_logic_vector(7 downto 0):=(others=>'0');
	begin
		if reset='1' then
			numarator_pwm := (others => '0');
			led_signal <= '0';
		elsif clk'event and clk='1' and en='1' then
			numarator_pwm := numarator_pwm + 1;		 
			if numarator_pwm < pwm_duty then
				led_signal <= '1';
			else
				led_signal <= '0';
			end if;
		end if;	
	end process;
end architecture;