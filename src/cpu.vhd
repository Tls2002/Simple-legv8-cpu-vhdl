library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
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
end cpu;

architecture Behavioral of cpu is
    -- Component Declarations

    -- PC Register
    component pc is
        Generic (
            ADDRESS_WIDTH : integer := 16
        );
        Port (
            Clock : in STD_LOGIC;
            Reset : in STD_LOGIC;
            Enable : in STD_LOGIC;
            PC_next : in STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
            PC_current : out STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0)
        );
    End component;

    -- Control Unit
    Component control_unit is
        Generic (
            DATA_WIDTH : integer := 16;
            ADDRESS_WIDTH : integer := 16;
            REGS_NUM : integer := 4
        );
        Port (
            Clock : in STD_LOGIC;
            Reset : in STD_LOGIC;
            Enable : in STD_LOGIC;

            -- Instruction Fetch Control
            Instr : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0); 

            -- ALU Result for Branching
            ALU_result : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);

            -- Program Counter Control
            PC_current : in STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
            PC_next : out STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);

            -- Register File Control
            Reg_num_1   : out std_logic_vector (REGS_NUM - 1 downto 0);
            Reg_num_2   : out std_logic_vector (REGS_NUM - 1 downto 0);
            RegWrite : out STD_LOGIC;
            Write_reg : out STD_LOGIC_VECTOR (REGS_NUM - 1 downto 0);

            -- Data memory Control
            MemWrite : out STD_LOGIC;
            MemRead : out STD_LOGIC;

            -- ALU Control
            ALU_Op : out STD_LOGIC_VECTOR (3 downto 0);

            -- TO MUXES
            ALUSrc : out STD_LOGIC; -- 0 for Register, 1 for Immediate  
            MemtoReg : out STD_LOGIC; -- 0 for ALU Result, 1 for Memory Data

            Immediate : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
        );
    End component;

    -- ALU controller
    component alu_controller is
        port (
            ALUOp : in STD_LOGIC_VECTOR (3 downto 0);
            alu_ctrl : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    -- ALU
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
    End Component;

    -- Data Memory
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
    End component;

    -- Instruction Memory
    component instruction_mem is
        Generic (
            DATA_WIDTH : integer := 16;     -- Width of data bus
            ADDRESS_WIDTH : integer := 16   -- Width of address bus
            );
        Port (
            Clock : in std_logic;                               
            Reset : in std_logic;                                       -- Active High Synchronous reset signal
            DataIn : in std_logic_vector (DATA_WIDTH - 1 downto 0);
            Address : in std_logic_vector (ADDRESS_WIDTH - 1 downto 0);
            WriteEn : in std_logic;
            Enable : in std_logic;
            DataOut : out std_logic_vector (DATA_WIDTH - 1 downto 0)
            );
    End component;

    -- Register File
    component regs is
        Generic (
            DATA_WIDTH : integer := 16;
            REGS_NUM : integer := 4 -- Number of bits to address the registers
            );
        Port (
            Clock       : in std_logic;
            Reset       : in std_logic; -- Active High Synchronous Reset
            DataIn      : in std_logic_vector (DATA_WIDTH - 1 downto 0);
            Reg_num_1   : in std_logic_vector (REGS_NUM - 1 downto 0);
            Reg_num_2   : in std_logic_vector (REGS_NUM - 1 downto 0);
            Write_reg   : in std_logic_vector (REGS_NUM - 1 downto 0);
            RegWrite    : in std_logic;
            Enable      : in std_logic;
            DataOut_1   : out std_logic_vector (DATA_WIDTH - 1 downto 0);
            DataOut_2   : out std_logic_vector (DATA_WIDTH - 1 downto 0)
        );
    End component;

    -- Internal Signals

    -- PC Signals
    signal PC_current_wire : STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
    signal PC_next_wire : STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);

    -- Instruction Memory Signals
    signal Instr_wire : STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
    signal Instr_Address_wire : STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);

    -- Register File Signals
    signal Reg_num_1_wire : std_logic_vector (REGS_NUM - 1 downto 0);
    signal Reg_num_2_wire : std_logic_vector (REGS_NUM - 1 downto 0);
    signal Write_reg_wire : std_logic_vector (REGS_NUM - 1 downto 0);
    signal RegWrite_wire : std_logic;
    signal RegDataOut_1_wire : std_logic_vector (DATA_WIDTH - 1 downto 0);
    signal RegDataOut_2_wire : std_logic_vector (DATA_WIDTH - 1 downto 0);
    signal RegDataIn_wire : std_logic_vector (DATA_WIDTH - 1 downto 0);

    -- ALU Control Signals
    signal ALU_Op_wire : STD_LOGIC_VECTOR (3 downto 0);
    signal ALU_ctrl_wire : STD_LOGIC_VECTOR (3 downto 0);

    -- ALU Signals
    signal ALU_result_wire : STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
    signal ALU_b_in_wire : STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);

    -- Mux Control Signals
    signal ALUSrc_wire : STD_LOGIC;
    signal MemtoReg_wire : STD_LOGIC;
    signal Immediate_wire : STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
    
    -- Data Memory Signals
    signal MemWrite_wire : STD_LOGIC;
    signal MemRead_wire : STD_LOGIC;
    signal MemData_wire : STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
    
begin

    -- PC Instantiation
    PC_Inst : pc
        Generic map (
            ADDRESS_WIDTH => ADDRESS_WIDTH
        )
        Port map (
            Clock => Clock,
            Reset => Reset,
            Enable => Enable,
            PC_next => PC_next_wire,
            PC_current => PC_current_wire
        );

    -- ALU Control Instantiation
    ALU_Control_Inst : alu_controller
        Port map (
            ALUOp => ALU_Op_wire,
            alu_ctrl => ALU_ctrl_wire
        );

    -- ALU Instantiation
    ALU_Inst : alu
        Generic map (
            DATA_WIDTH => DATA_WIDTH
        )
        Port map (
            Clock => Clock,
            Reset => Reset,
            a_in => RegDataOut_1_wire,
            b_in => ALU_b_in_wire, 
            alu_ctrl => ALU_ctrl_wire,
            Enable => Enable,
            Res_out => ALU_result_wire
        );

    -- Data Memory Instantiation
    Data_Mem_Inst : data_mem
        Generic map (
            DATA_WIDTH => DATA_WIDTH,
            ADDRESS_WIDTH => ADDRESS_WIDTH
        )
        Port map (
            Clock => Clock,
            Reset => Reset,
            Enable => Enable,
            DataIn => RegDataOut_2_wire,
            Address => ALU_result_wire,
            MemWrite => MemWrite_wire,
            MemRead => MemRead_wire,
            DataOut => MemData_wire
        );

    -- Instruction Memory Instantiation
    Instr_Mem_Inst : instruction_mem
        Generic map (
            DATA_WIDTH => DATA_WIDTH,
            ADDRESS_WIDTH => ADDRESS_WIDTH
        )
        Port map (
            Clock => Clock,
            Reset => Reset,
            DataIn => DataIn,
            Address => Instr_Address_wire,
            WriteEn => WriteEn,
            Enable => Enable,
            DataOut => Instr_wire
        );

    -- Register File Instantiation
    Regs_Inst : regs
        Generic map (
            DATA_WIDTH => DATA_WIDTH,
            REGS_NUM => REGS_NUM
        )
        Port map (
            Clock => Clock,
            Reset => Reset,
            DataIn => RegDataIn_wire,
            Reg_num_1 => Reg_num_1_wire,
            Reg_num_2 => Reg_num_2_wire,
            Write_reg => Write_reg_wire,
            RegWrite => RegWrite_wire,
            Enable => Enable,
            DataOut_1 => RegDataOut_1_wire,
            DataOut_2 => RegDataOut_2_wire
        );
    
    -- Control Unit Instantiation
    Control_Unit_Inst : control_unit
        Generic map (
            DATA_WIDTH => DATA_WIDTH,
            ADDRESS_WIDTH => ADDRESS_WIDTH,
            REGS_NUM => REGS_NUM
        )
        Port map (
            Clock => Clock,
            Reset => Reset,
            Enable => Enable,
            Instr => Instr_wire,
            ALU_result => ALU_result_wire,
            PC_current => PC_current_wire,
            PC_next => PC_next_wire,
            Reg_num_1 => Reg_num_1_wire,
            Reg_num_2 => Reg_num_2_wire,
            RegWrite => RegWrite_wire,
            Write_reg => Write_reg_wire,
            MemWrite => MemWrite_wire,
            MemRead => MemRead_wire,
            ALU_Op => ALU_Op_wire,
            ALUSrc => ALUSrc_wire,
            MemtoReg => MemtoReg_wire,
            Immediate => Immediate_wire
        );

    -- MUX for assignments
    ALU_b_in_wire <= Immediate_wire when ALUSrc_wire = '1' else RegDataOut_2_wire;
    RegDataIn_wire <= MemData_wire when MemtoReg_wire = '1' else ALU_result_wire; 
    Instr_Address_wire <= Address when WriteEn = '1' else PC_current_wire;
    
end Behavioral;