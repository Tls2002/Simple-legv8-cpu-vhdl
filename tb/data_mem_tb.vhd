library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity data_mem_tb is
end data_mem_tb;

architecture behavioral of data_mem_tb is

    -- Component Declaration of UUT
    component data_mem is
        Generic (
            DATA_WIDTH : integer := 16;
            ADDRESS_WIDTH : integer := 16
        );
        Port (
            Clock : in STD_LOGIC;
            Reset : in STD_LOGIC;
            DataIn : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
            Address : in STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
            MemWrite : in STD_LOGIC;
            MemRead : in STD_LOGIC;
            Enable : in STD_LOGIC;
            DataOut : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
        );
    end component;

    -- Signals to connect to UUT
    signal Clock : STD_LOGIC := '0';
    signal Reset : STD_LOGIC := '0';
    signal DataIn : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal Address : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal MemWrite : STD_LOGIC := '0';
    signal MemRead : STD_LOGIC := '0';
    signal Enable : STD_LOGIC := '0';
    signal DataOut : STD_LOGIC_VECTOR (15 downto 0);

    constant  clock_period : time := 10 ns;

begin
    UUT: data_mem
        generic map (
            DATA_WIDTH => 16,
            ADDRESS_WIDTH => 16
        )
        port map (
            Clock => Clock,
            Reset => Reset,
            DataIn => DataIn,
            Address => Address,
            MemWrite => MemWrite,
            MemRead => MemRead,
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

        -- Test Case 1: Write data to memory (store operations)
        Reset <= '1';
        MemWrite <= '0';
        MemRead <= '0';
        Enable <= '0';
        wait for 2*clock_period;
        Reset <= '0';
        Enable <= '1';
        MemWrite <= '1';

        Address <= x"0000";
        DataIn <= x"1221";
        wait for clock_period;

        Address <= x"0002";
        DataIn <= x"3221";
        wait for clock_period;

        Address <= x"0004";
        DataIn <= x"3225";
        wait for 2*clock_period;
        MemWrite <= '0';

        -- Test Case 2: Read data from memory (load operations)
        MemRead <= '1';
        Address <= x"0000";
        wait for clock_period;

        Address <= x"0002";
        wait for clock_period;

        Address <= x"0004";
        wait for clock_period;
        MemRead <= '0';

        wait;

    end process;
end architecture;