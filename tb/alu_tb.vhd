library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is
end alu_tb;

architecture behavioral of alu_tb is

    -- Component declaration
    component alu is
        Generic (
            DATA_WIDTH : integer := 16
        );
        Port (
            Clock : in STD_LOGIC;
            Reset : in STD_LOGIC;
            a_in : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
            b_in : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
            alu_ctrl : in STD_LOGIC_VECTOR (3 downto 0);
            Enable : in STD_LOGIC;
            Res_out : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
        );
    end component;

    signal Clock_tb     : STD_LOGIC;
    signal Reset_tb     : STD_LOGIC;
    signal a_in_tb      : STD_LOGIC_VECTOR (15 downto 0);
    signal b_in_tb      : STD_LOGIC_VECTOR (15 downto 0);
    signal alu_ctrl_in_tb : STD_LOGIC_VECTOR (3 downto 0);
    signal Enable_in_tb   : STD_LOGIC;
    signal Res_out_tb     : STD_LOGIC_VECTOR (15 downto 0);

    constant clock_period : time := 20 ns;

begin
   -- Instantiation of the ALU
    ALU_Inst : alu
        Generic map (
                DATA_WIDTH => 16
        )
        Port map (
            Clock => Clock_tb,
            Reset => Reset_tb,
            a_in => a_in_tb,
            b_in => b_in_tb,
            alu_ctrl => alu_ctrl_in_tb,
            Enable => Enable_in_tb,
            Res_out => Res_out_tb
        );

    -- Clock generation
    Clock_Process : process
    begin
        Clock_tb <= '0';
        wait for clock_period / 2;
        Clock_tb <= '1';
        wait for clock_period / 2;
    end process;

    -- Test process
    Process
    begin

        -- Initialize Inputs
        Reset_tb <= '1';
        Enable_in_tb <= '0';
        wait for clock_period;

        Reset_tb <= '0';
        Enable_in_tb <= '1';
        wait for clock_period;

        -- Test: ADD
        -- a_in = 10, b_in = 5
        -- Res_out = 15
        -- Hex: a_in=0x000A, b_in=0x0005, Res_out=0x000F
        a_in_tb <= std_logic_vector(to_signed(10, 16));
        b_in_tb <= std_logic_vector(to_signed(5, 16));
        alu_ctrl_in_tb <= x"0"; -- ADD
        wait for clock_period;

        -- Test: SUB
        -- a_in = 10, b_in = 5
        -- Res_out = 5
        -- Hex: a_in=0x000A, b_in=0x0005, Res_out=0x0005
        alu_ctrl_in_tb <= x"1"; -- SUB
        wait for clock_period;

        -- Test: MUL
        -- a_in = 10, b_in = 5
        -- Res_out = 50
        -- Hex: a_in=0x000A, b_in=0x0005, Res_out=0x0032
        alu_ctrl_in_tb <= x"2"; -- MUL
        wait for clock_period;

        -- Test: DIV
        -- a_in = 10, b_in = 5
        -- Res_out = 2
        -- Hex: a_in=0x000A, b_in=0x0005, Res_out=0x0002
        alu_ctrl_in_tb <= x"3"; -- DIV
        wait for clock_period;

        -- Test: AND
        -- a_in = 0b1010, b_in = 0b1100
        -- Res_out = 0b1000
        -- Hex: a_in=0x000A, b_in=0x000C, Res_out=0x0008
        a_in_tb <= std_logic_vector(to_signed(10, 16)); 
        b_in_tb <= std_logic_vector(to_signed(12, 16)); 
        alu_ctrl_in_tb <= x"4"; -- AND
        wait for clock_period;

        -- Test: OR
        -- a_in = 0b1010, b_in = 0b1100
        -- Res_out = 0b1110
        -- Hex: a_in=0x000A, b_in=0x000C
        -- Res_out=0x000E
        alu_ctrl_in_tb <= x"5"; -- OR
        wait for clock_period;
        

        -- Test: Shift Left Logical
        -- a_in = 0b0001, b_in = 0b0010
        -- Res_out = 0b0100
        -- Hex: a_in=0x0001, b_in=0x0002
        -- Res_out=0x0004
        a_in_tb <= std_logic_vector(to_signed(1, 16));
        b_in_tb <= std_logic_vector(to_signed(2, 16));
        alu_ctrl_in_tb <= x"6"; -- LSL
        wait for clock_period;

        -- Test: Shift Right Logical
        -- a_in = 0b0100, b_in = 0b0010
        -- Res_out = 0b0001
        -- Hex: a_in=0x0004, b_in=0x0001
        -- Res_out=0x0001
        a_in_tb <= std_logic_vector(to_signed(4, 16));
        b_in_tb <= std_logic_vector(to_signed(1, 16));
        alu_ctrl_in_tb <= x"7"; -- LSR
        wait for clock_period;

        -- Test Complete
        wait;        
    end process;   
end architecture;



