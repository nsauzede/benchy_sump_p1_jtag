----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:45:19 12/19/2010 
-- Design Name: 
-- Module Name:    aaatop - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity aaatop is
    Port ( rx : in  STD_LOGIC;
           tx : inout  STD_LOGIC;
           W1A : inout  STD_LOGIC_VECTOR (15 downto 0);
           W1B : inout  STD_LOGIC_VECTOR (15 downto 0);
           W2C : inout  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC);
end aaatop;

architecture Behavioral of aaatop is
--signal la	: std_logic_vector(31 downto 0);
signal la	: std_logic_vector(7 downto 0);

signal address : std_logic_vector(9 downto 0);
signal instruction : std_logic_vector(17 downto 0);
signal port_id : std_logic_vector(7 downto 0);
signal write_strobe : std_logic;
signal out_port : std_logic_vector(7 downto 0);
signal read_strobe : std_logic;
signal in_port : std_logic_vector(7 downto 0);
signal interrupt : std_logic;
signal interrupt_ack : std_logic;
signal picoreset : std_logic;
signal clk2 : std_logic;

signal buttons : STD_LOGIC_VECTOR (3 downto 0);
signal leds : STD_LOGIC_VECTOR (3 downto 0);

signal cntuart : STD_LOGIC_VECTOR (3 downto 0);
signal en_16_x_baud : std_logic;
signal write_buffer : std_logic;
signal the_tx : std_logic;
begin
	sump0 : entity work.BENCHY_sa_SumpBlaze_LogicAnalyzer8_jtag
	port map(
		clk_32Mhz => clk,
		clk_out => clk2,
		la_input2 => la
		--armLED : out std_logic;
		--triggerLED : out std_logic
	);
--	la <= out_port;
--	la <= en_16_x_baud & write_buffer & out_port(5 downto 0);
	la <= "00000" & en_16_x_baud & write_buffer & the_tx;
--	la <= port_id;
--	la <= 
--		"00" & en_16_x_baud & write_buffer & "00" & write_strobe & read_strobe & 
--		port_id & 
--		in_port & 
--		out_port;
	kcpsm0: entity work.kcpsm3 Port map(
		address => address,
		instruction => instruction,
		port_id => port_id,
		write_strobe => write_strobe,
		out_port => out_port,
		read_strobe => read_strobe,
		in_port => in_port,
		interrupt => interrupt,
		interrupt_ack => interrupt_ack,
		reset => picoreset,
		clk => clk2
	);
	rom0 : entity work.rom Port map(
		address => address,
		instruction => instruction,
		proc_reset => picoreset,
		clk => clk2
	);
	butled0: entity work.wingbutled
	Port map(
		io => w1b(7 downto 0),
		buttons => buttons,
		leds => leds
	);
--	leds <= out_port(3 downto 0);
	leds <= write_buffer & out_port(2 downto 0);
	process(clk2)
	begin
		if rising_edge(clk2) then
			cntuart <= cntuart + 1;
		end if;
	end process;
	en_16_x_baud <= cntuart(3);
	tx <= the_tx;
	uart_rx0: entity work.uart_rx
	Port map(
		serial_in => rx,
		data_out => in_port,
		read_buffer => read_strobe,
		reset_buffer => '0',
		en_16_x_baud => en_16_x_baud,
		buffer_data_present => interrupt,
		buffer_full => open,
		buffer_half_full => open,
		clk => clk2
	);
	write_buffer <= write_strobe and port_id(7);
	uart_tx0 : entity work.uart_tx Port map(
		data_in => out_port,
		write_buffer => write_buffer,
		reset_buffer => '0',
		en_16_x_baud => en_16_x_baud,
		serial_out => the_tx,
		buffer_full => open,
		buffer_half_full => open,
		clk => clk2
	);
end Behavioral;
