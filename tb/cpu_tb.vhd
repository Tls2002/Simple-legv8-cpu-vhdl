library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


Entity cpu_tb is
end cpu_tb;

architecture Behavioral of cpu_tb is

    -- Component Declaration for the CPU
    component cpu is
        Generic (
            DATA_WIDTH : integer := 16;
            ADDRESS_WIDTH : integer := 16;
            REGS_NUM : integer := 4
        );
        Port (
            Clock : in STD_LOGIC;
            Reset : in STD_LOGIC;
            Enable : in STD_LOGIC;

            -- Inputs to upload instructions
            DataIn : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
            Address : in STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
            WriteEn : in STD_LOGIC
        );
    end component;

    -- Testbench Signals
    signal Clock_in : STD_LOGIC := '0';
    signal Reset_in : STD_LOGIC := '0';
    signal Enable_in : STD_LOGIC := '0';
    signal DataIn_in : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal Address_in : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal WriteEn_in : STD_LOGIC := '0';

    constant clock_period : time := 20 ns;

begin
    -- Instantiate the CPU
    CPU_Inst : cpu
    Generic map (
        DATA_WIDTH => 16,
        ADDRESS_WIDTH => 16,
        REGS_NUM => 4
    )
        Port map (
            Clock => Clock_in,
            Reset => Reset_in,
            Enable => Enable_in,
            DataIn => DataIn_in,
            Address => Address_in,
            WriteEn => WriteEn_in
        );

    -- Clock Generation
    Clock_Process : process
    begin
        Clock_in <= '0';
        wait for clock_period / 2;
        Clock_in <= '1';
        wait for clock_period / 2;
    end process;

    process
    begin

        -- Reset the CPU
        Reset_in <= '1';
        wait for 2*clock_period;
        Reset_in <= '0';
        wait for 2*clock_period;

        -- Enable the CPU
        Enable_in <= '1';

        -- Upload instructions to the instruction memory

        -- Test Case A: a = 4, b = 6, c = 0
        -- Initialization of variables to data memory
        WriteEn_in <= '1';

        Address_in <= x"0000";  -- Address 0x0000
        DataIn_in <= x"9400";   -- ADDI R0, R0, #4
        wait for clock_period;

        Address_in <= x"0002";  -- Address 0x0002
        DataIn_in <= x"E040";   -- STR  R0, [R4, #0]
        wait for clock_period;

        Address_in <= x"0004";  -- Address 0x0004
        DataIn_in <= x"9601";   -- ADDI R1, R0, #6
        wait for clock_period;

        Address_in <= x"0006";  -- Address 0x0006
        DataIn_in <= x"E241";   -- STR  R1, [R4, #2]
        wait for clock_period;

        Address_in <= x"0008";  -- Address 0x0008
        DataIn_in <= x"9002";   -- ADDI R2, R0, #0
        wait for clock_period;

        Address_in <= x"000A";  -- Address 0x000A
        DataIn_in <= x"E442";   -- STR  R2, [R4, #4]
        wait for clock_period;

        Address_in <= x"000C";  -- Address 0x000C
        DataIn_in <= x"D040";   -- LDR R0, [R4, #0]
        wait for clock_period;

        Address_in <= x"000E";  -- Address 0x000E
        DataIn_in <= x"D241";   -- LDR R1, [R4, #2]
        wait for clock_period;

        Address_in <= x"0010";  -- Address 0x0010
        DataIn_in <= x"D442";   -- LDR R2, [R4, #4]
        wait for clock_period;

        Address_in <= x"0012";  -- Address 0x0012
        DataIn_in <= x"9500";   -- ADDI R0, R0, #5
        wait for clock_period;

        Address_in <= x"0014";  -- Address 0x0014
        DataIn_in <= x"E040";   -- STR R0, [R4, #0]
        wait for clock_period;

        Address_in <= x"0016";  -- Address 0x0016
        DataIn_in <= x"AA03";   -- SUBI R3, R0, #10
        wait for clock_period;

        Address_in <= x"0018";  -- Address 0x0018
        DataIn_in <= x"8033";   -- BGT R3, true
        wait for clock_period;

        Address_in <= x"001A";  -- Address 0x001A
        DataIn_in <= x"2102";   -- SUB R2, R0, R1
        wait for clock_period;

        Address_in <= x"001C";  -- Address 0x001C
        DataIn_in <= x"F002";   -- B exit
        wait for clock_period;

        Address_in <= x"001E";  -- Address 0x001E
        DataIn_in <= x"1102";   -- ADD R2, R0, R1
        wait for clock_period;

        Address_in <= x"0020";  -- Address 0x0020
        DataIn_in <= x"E442";   -- STR R2, [R4, #4]
        wait for clock_period;

        WriteEn_in <= '0';  -- Stop writing to instruction memory

        -- Reset the CPU again to start execution
        Reset_in <= '1';
        wait for 2*clock_period;
        Reset_in <= '0';
        wait for 2*clock_period;

        -- Execution of the program will start here
        wait for 50*clock_period;

        -- Test Case B: a = 12, b = 6, c = 0
        -- Reset the CPU again to start execution
        Reset_in <= '1';
        wait for 2*clock_period;
        Reset_in <= '0';
        wait for 2*clock_period;

        WriteEn_in <= '1';

        Address_in <= x"0000";  -- Address 0x0000
        DataIn_in <= x"9C00";   -- ADDI R0, R0, #12
        wait for clock_period;

        Address_in <= x"0002";  -- Address 0x0002
        DataIn_in <= x"E040";   -- STR  R0, [R4, #0]
        wait for clock_period;

        Address_in <= x"0004";  -- Address 0x0004
        DataIn_in <= x"9601";   -- ADDI R1, R0, #6
        wait for clock_period;

        Address_in <= x"0006";  -- Address 0x0006
        DataIn_in <= x"E241";   -- STR  R1, [R4, #2]
        wait for clock_period;

        Address_in <= x"0008";  -- Address 0x0008
        DataIn_in <= x"9002";   -- ADDI R2, R0, #0
        wait for clock_period;

        Address_in <= x"000A";  -- Address 0x000A
        DataIn_in <= x"E442";   -- STR  R2, [R4, #4]
        wait for clock_period;

        WriteEn_in <= '0';

        -- Execution of the program will start here
        wait for 50*clock_period;
        
        wait;
    end process;

end Behavioral;