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
	signal cnt : std_logic_vector(31 downto 0) := (others => '0');
	
begin
	sump0 : entity work.BENCHY_sa_SumpBlaze_LogicAnalyzer8_jtag
	port map(
		clk_32Mhz => clk,
		--extClockIn : in std_logic;
--		extClockOut : out std_logic;
		--extTriggerIn : in std_logic;
		--extTriggerOut : out std_logic;
		--la_input : in std_logic_vector(31 downto 0);
		la0 => la(0),
		la1 => la(1),
		la2 => la(2),
		la3 => la(3),
		la4 => la(4),
		la5 => la(5),
		la6 => la(6),
		la7 => la(7)
		--armLED : out std_logic;
		--triggerLED : out std_logic
	);
--	w1a(7 downto 0) <= "ZZZZZZZZ";
--	la(7 downto 0) <= w1a(7 downto 0);
	process(clk)
	begin
		if rising_edge(clk) then
			cnt <= cnt + 1;
		end if;
	end process;
	la(7 downto 0) <= cnt(7 downto 0);
end Behavioral;
