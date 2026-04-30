library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_controller is
    port (
        ALUOp : in STD_LOGIC_VECTOR (3 downto 0);
        alu_ctrl : out STD_LOGIC_VECTOR (3 downto 0)
    );
end alu_controller;

architecture Behavioral of alu_controller is
begin
    process (ALUOp)
    begin
        case ALUOp is
            -- ADD
            when "0001" =>
                alu_ctrl <= X"0";
            -- SUB
            when "0010" =>
                alu_ctrl <= X"1";
            -- MUL
            when "0011" =>
                alu_ctrl <= X"2";
            -- DIV
            when "0100" =>
                alu_ctrl <= X"3";
            -- AND
            when "0101" =>
                alu_ctrl <= X"4";
            -- ORR
            when "0110" =>
                alu_ctrl <= X"5";
            -- ADDI
            when "1001" =>
                alu_ctrl <= X"0";
            -- SUBI
            when "1010" =>
                alu_ctrl <= X"1";
            -- LSL
            when "1011" =>
                alu_ctrl <= X"6";
            -- LSR
            when "1100" =>
                alu_ctrl <= X"7";
            -- LDR
            when "1101" =>
                alu_ctrl <= X"0";
            -- STR
            when "1110" =>
                alu_ctrl <= X"0";
            -- BEQ
            when "0000" =>
                alu_ctrl <= X"1";
            -- BLT 
            when "0111" =>
                alu_ctrl <= X"1";
            -- BGT
            when "1000" =>
                alu_ctrl <= X"1";
            -- B
            when "1111" =>
                alu_ctrl <= X"0";
            -- Default case
            when others =>
                alu_ctrl <= X"0";
        end case;
    end process;
end Behavioral;