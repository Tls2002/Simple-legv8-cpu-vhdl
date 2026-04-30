library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity instruction_mem_tb is
end instruction_mem_tb;

architecture behavioral of instruction_mem_tb is

    -- Component Declaration of UUT
    component instruction_mem is
        Generic (
            DATA_WIDTH : integer := 16;
            ADDRESS_WIDTH : integer := 16
            );
        Port (
            Clock : in std_logic;
            Reset : in std_logic;
            DataIn : in std_logic_vector (DATA_WIDTH - 1 downto 0);
            Address : in std_logic_vector (ADDRESS_WIDTH - 1 downto 0);
            WriteEn : in std_logic;
            Enable : in std_logic;
            DataOut : out std_logic_vector (DATA_WIDTH - 1 downto 0)
            );
    end component;

    -- Signals to connect to UUT
    signal Clock : STD_LOGIC := '0';
    signal Reset : STD_LOGIC := '0';
    signal DataIn : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal Address : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal WriteEn : STD_LOGIC := '0';
    signal Enable : STD_LOGIC := '0';
    signal DataOut : STD_LOGIC_VECTOR (15 downto 0);

    constant  clock_period : time := 10 ns;

begin
    UUT: instruction_mem
        generic map (
            DATA_WIDTH => 16,
            ADDRESS_WIDTH => 16
        )
        port map (
            Clock => Clock,
            Reset => Reset,
            DataIn => DataIn,
            Address => Address,
            WriteEn => WriteEn,
            Enable => Enable,
            DataOut => DataOut
        );

    clk: process -- Clock Generation
    begin
        clock <= '0';
        wait for clock_period/2;
        clock <= '1';
        wait for clock_period/2;
    end process;

    -- Test Bench
    tb: process
    begin

        -- Test Case 1: Write memory
        Reset <= '1';
        WriteEn <= '0';
        Enable <= '0';
        wait for 2*clock_period;
        
        Reset <= '0';
        Enable <= '1';

        WriteEn <= '1';
        Address <= x"0000";
        DataIn <= x"9500";
        wait for clock_period;

        Address <= x"0002";
        DataIn <= x"AA03";
        wait for clock_period;

        Address <= x"0004";
        DataIn <= x"8033";
        wait for 2*clock_period;
        WriteEn <= '0';

        -- Test Case 2: Read memory
        Address <= x"0000";
        wait for clock_period;

        Address <= x"0002";
        wait for clock_period;

        Address <= x"0004";
        wait for clock_period;

        wait;

    end process;
end architecture;