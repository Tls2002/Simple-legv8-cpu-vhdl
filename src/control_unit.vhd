library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity control_unit is
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
End control_unit;

Architecture Behavioral of control_unit is
begin
    process (Clock)
    begin
        if rising_edge(Clock) then
            
            if Reset = '1' then
                PC_next <= (others => '0');
                RegWrite <= '0';
                Write_reg <= (others => '0');

                Immediate <= (others => '0');
                Reg_num_1   <= (others => '0');
                Reg_num_2   <= (others => '0');

                MemtoReg <= '0';
                MemWrite <= '0';
                MemRead <= '0';

                ALU_Op <= (others => '0');
                ALUSrc <= '0';                

            elsif Enable = '1' then

                -- Default all signals
                RegWrite    <= '0';
                MemtoReg    <= '0';
                MemWrite    <= '0';
                MemRead     <= '0';
                ALUSrc      <= '0';   
                Write_reg   <= (others => '0');
                Immediate   <= (others => '0');
                Reg_num_1   <= (others => '0');
                Reg_num_2   <= (others => '0');
                ALU_Op      <= (others => '0');
                PC_next     <= std_logic_vector(unsigned(PC_current) + 2); 

                case Instr(15 downto 12) is
                    
                    -- R Format Instructions
                    when "0001" | "0010" | "0011" | 
                         "0100" | "0101" | "0110" =>

                        RegWrite <= '1';
                        Reg_num_1 <= Instr(7 downto 4);
                        Reg_num_2 <= Instr(11 downto 8);
                        Write_reg <= Instr(3 downto 0);
                        ALU_Op <= Instr(15 downto 12);                     
                        
                    -- I Format Instructions
                    when "1001" | "1010" | "1011" | "1100" =>
                      RegWrite <= '1';
                      write_reg <= Instr(3 downto 0);
                      reg_num_1 <= Instr(7 downto 4);
                      Immediate <= std_logic_vector(resize(signed(Instr(11 downto 8)), DATA_WIDTH));
                      ALU_Op <= Instr(15 downto 12);
                      ALUSrc <= '1';

                      -- D Format Instructions
                    when "1101" | "1110" =>
                        Reg_num_1 <= Instr(7 downto 4);
                        Immediate <= std_logic_vector(resize(signed(Instr(11 downto 8)), DATA_WIDTH));
                        ALUSrc <= '1';
                        ALU_Op <= Instr(15 downto 12);
                        
                        case Instr(15 downto 12) is
                            when "1101" => -- LDR
                                RegWrite <= '1';
                                Write_reg <= Instr(3 downto 0);
                                MemtoReg <= '1';
                                MemRead <= '1';
                            when "1110" => -- STR
                                Reg_num_2 <= Instr(3 downto 0);
                                MemWrite <= '1';
                            when others => null;
                        end case;

                        -- Conditional B Format Instructions 
                    when "0000" | "0111" | "1000" =>
                        Reg_num_1 <= Instr(3 downto 0);
                        ALU_Op <= Instr(15 downto 12);

                        case Instr(15 downto 12) is
                            when "0000" => -- BEQ
                                if ALU_result = x"0000" then
                                    PC_next <= std_logic_vector(resize(unsigned(PC_current) + unsigned(Instr(11 downto 4)) * 2, ADDRESS_WIDTH));
                                end if;
                            when "0111" => -- BLT
                                if signed(ALU_result) < 0 then
                                    PC_next <= std_logic_vector(resize(unsigned(PC_current) + unsigned(Instr(11 downto 4)) * 2, ADDRESS_WIDTH));
                                end if;
                            when "1000" => -- BGT
                                if signed(ALU_result) > 0 then
                                    PC_next <= std_logic_vector(resize(unsigned(PC_current) + unsigned(Instr(11 downto 4)) * 2, ADDRESS_WIDTH));
                                end if;
                            when others => null;
                        end case;

                    -- Unconditional B Format Instruction
                    when "1111" =>
                        ALU_Op <= Instr(15 downto 12);
                        PC_next <= std_logic_vector(resize(unsigned(PC_current) + unsigned(Instr(11 downto 0)) * 2, ADDRESS_WIDTH));

                    when others => null;
                end case;
            end if;              
        end if;
    end process;
end Behavioral;