library ieee;
use ieee.std_logic_1164.all;

-- Program Counter (PC)
Entity pc is
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
End pc;

-- Program Counter Implementation
Architecture Behavioral of pc is
begin
    Process (Clock)
    begin
        if rising_edge(Clock) then
            if Reset = '1' then
                PC_current <= (others => '0'); -- Reset PC to 0 on reset
            elsif Enable = '1' then
                PC_current <= PC_next; -- Update PC to next value on clock edge if enabled
            end if;
        end if;
    end Process;
end Behavioral;