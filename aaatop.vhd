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

	signal spi_clk : std_logic;
	signal spi_csn : std_logic;
	signal spi_mosi : std_logic;
	signal spi_miso : std_logic;
	signal spimaster0_cs : std_logic;
   SIGNAL wspi         : std_logic;
	signal clk25 : std_logic;
	signal cnt25 : std_logic_vector(2 downto 0);

	signal LED : std_logic_vector(7 downto 0);
	signal leds : std_logic_vector(3 downto 0);
	signal buttons : std_logic_vector(3 downto 0);
begin
	sump0 : entity work.BENCHY_sa_SumpBlaze_LogicAnalyzer8_jtag
	port map(
		clk_32Mhz => clk,
		clk_out => clk2,
		la_input2 => la
		--armLED : out std_logic;
		--triggerLED : out std_logic
	);
--	la <= LED;
--	la <= cnt25(1 downto 0) & wspi & spimaster0_cs & spi_miso & spi_mosi & spi_csn & spi_clk;
	la <= LED(3 downto 0) & spi_csn & spi_mosi & spi_miso & spi_clk;
	process(clk2)
	begin
		if rising_edge(clk2) then
			cnt25 <= cnt25 + 1;
		end if;
	end process;
	clk25 <= cnt25(0);
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
		clk => clk25
	);
	rom0 : entity work.rom Port map(
		address => address,
		instruction => instruction,
		proc_reset => picoreset,
		clk => clk25
	);
	wspi <= write_strobe;
	spimaster0_cs <= '1' when port_id(7 downto 3)="11110" else '0';
	spimaster0 : entity work.spimaster
	port map (
		clk => clk25,
		reset => picoreset,
		cpu_address => port_id(2 downto 0),
		cpu_wait => open,
		data_in => out_port,
		data_out => open,
		enable => spimaster0_cs,
		req_read => '0',
		req_write => wspi,

		slave_cs => spi_csn,
		slave_clk => spi_clk,
		slave_mosi => spi_mosi,
		slave_miso => spi_miso
	);
	spislave0 : entity work.spi_vhdl
	Port map( 
		clk => clk25,
		SCK => spi_clk,
		MOSI => spi_mosi,
		MISO => spi_miso,
		SSEL => spi_csn,
		LED => LED
	);
	butled0: entity work.wingbutled
	Port map(
		io => w1b(7 downto 0),
		buttons => buttons,
		leds => leds
	);
	leds <= LED(3 downto 0);
end Behavioral;
