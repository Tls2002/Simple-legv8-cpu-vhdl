library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regs_tb is
end regs_tb;

Architecture behavioral of regs_tb is
    component regs
        Generic (
            DATA_WIDTH : integer := 16;
            REGS_NUM : integer := 4
            );
        Port (
            Clock       : in std_logic;
            Reset       : in std_logic;
            DataIn      : in std_logic_vector (DATA_WIDTH - 1 downto 0);
            Reg_num_1   : in std_logic_vector (REGS_NUM - 1 downto 0);
            Reg_num_2   : in std_logic_vector (REGS_NUM - 1 downto 0);
            Write_reg   : in std_logic_vector (REGS_NUM - 1 downto 0);
            RegWrite    : in std_logic;
            Enable      : in std_logic;
            DataOut_1   : out std_logic_vector (DATA_WIDTH - 1 downto 0);
            DataOut_2   : out std_logic_vector (DATA_WIDTH - 1 downto 0)
        );
    End Component;

    Signal clock, reset, regwrite, enable : std_logic;
    Signal Datain, Dataout_1, Dataout_2 : std_logic_vector (15 downto 0);
    Signal Reg_num_1, Reg_num_2,Write_reg : std_logic_vector (3 downto 0);
    Constant clock_period : time := 10 ns;

Begin
    UUT: regs
        Generic Map (
            DATA_WIDTH => 16,
            REGS_NUM => 4
            )
        Port Map( 
            Clock => Clock,
            Reset => Reset,
            DataIn => Datain,
            Reg_num_1 => Reg_num_1,
            Reg_num_2 => Reg_num_2,
            Write_reg => Write_reg,
            RegWrite => RegWrite,
            Enable => Enable,
            DataOut_1 => Dataout_1,
            DataOut_2 => Dataout_2
            );

    clk:Process -- Clock Process
    Begin
        Clock <= '1';
        wait for clock_period/2;
        Clock <= '0';
        wait for clock_period/2;
    End Process;

    -- Test Case Process
    tb:Process
    Begin

    -- Clear signals
    Enable <= '0';
    DataIn <= (others => '0');
    Reg_num_1 <= (others => '0');
    Reg_num_2 <= (others => '0');
    Write_reg <= (others => '0');
    RegWrite <= '0'; -- Disable Write
    wait for clock_period;

    -- Reset the register file
    Reset <= '1';
    wait for clock_period;
    Reset <= '0';
    wait for clock_period;

    Enable <= '1'; -- Enable the register file

    -- Test Case 1: Write to registers
    RegWrite <= '1'; -- Enable Write

    Write_reg <= "0011"; -- Write to register 3
    Datain <= x"ABCD"; -- Write 
    wait for clock_period;

    Write_reg <= "0101"; -- Write to register 5
    Datain <= x"BCDE"; -- Data to write
    wait for clock_period;

    RegWrite <= '0'; -- Disable Write to read from registers
    wait for clock_period;

    -- Test Case 2: Read from registers
    Reg_num_1 <= "0011"; -- Read from register 3
    Reg_num_2 <= "0101"; -- Read from register 5
    wait for 2*clock_period;
    Enable <= '0'; -- Disable the register file
    wait for clock_period;

    wait; --wait forever
    End Process;
End;
