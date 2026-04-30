library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

-- Entity declaration for instruction memory
Entity instruction_mem is
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
End instruction_mem;

Architecture Behavioral of instruction_mem is

    -- Memory array to hold instructions, each instruction is 16 bits (2 bytes)
    type Memory_Array is array ((2 **ADDRESS_WIDTH) - 1 downto 0) of std_logic_vector (7 downto 0); 
    signal I_Mem : Memory_Array; -- Instruction memory array

begin

    -- Read process
    Process (Clock)
        begin
        if rising_edge(Clock) then
            if Reset = '1' then -- Clear DataOut on Reset
                DataOut <= (others => '0');
                elsif Enable = '1' then

                if WriteEn = '1' then -- If WriteEn then pass through DIn

                    I_Mem(to_integer(unsigned(Address))) <= DataIn(7 downto 0);
                    I_Mem(to_integer(unsigned(Address)) + 1) <= DataIn(15 downto 8);
                else -- Otherwise Read Memory
                    DataOut(7 downto 0) <= I_Mem(to_integer(unsigned(Address)));
                    DataOut(15 downto 8) <= I_Mem(to_integer(unsigned(Address)) + 1);

                end if;
            end if;
        end if;
    end process;
End Architecture Behavioral;