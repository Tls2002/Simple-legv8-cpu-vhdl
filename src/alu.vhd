library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ALU
Entity alu is
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
End alu;

-- ALU Implementation
Architecture Behavioral of alu is
begin
    Process (Clock)
    begin
        if rising_edge(Clock) then
            if Reset = '1' then -- Clear DataOut on Reset
                Res_out <= (others => '0');

            -- Perform ALU operation based on alu_ctrl when enabled
            elsif Enable = '1' then

                case alu_ctrl is

                    -- ADD
                    when x"0" =>
                        Res_out <= std_logic_vector(
                            signed(a_in) + signed(b_in)
                            );

                    -- SUB
                    when x"1" =>
                        Res_out <= std_logic_vector(
                            signed(a_in) - signed(b_in)
                            );

                    -- MUL
                    when x"2" =>
                        Res_out <= std_logic_vector( resize(
                            signed(a_in) * signed(b_in), DATA_WIDTH)
                            );

                    -- DIV
                    when x"3" =>
                        Res_out <= std_logic_vector( 
                            signed(a_in) / signed(b_in)
                            );
                        
                    -- AND
                    when x"4" =>
                        Res_out <= a_in AND b_in;
                    -- OR
                    when x"5" =>
                        Res_out <= a_in OR b_in;

                    -- SHIFT LEFT
                    when x"6" =>
                        Res_out <= std_logic_vector(
                            shift_left(unsigned(a_in),to_integer(unsigned(b_in)))
                            );
                    
                    --SHIFT RIGHT
                    when x"7" =>                    
                        Res_out <= std_logic_vector(
                            shift_right(unsigned(a_in),to_integer(unsigned(b_in)))
                            );                    
                    when others => null;
                end case;
            end if;
        end if;
    end process;
End Architecture;