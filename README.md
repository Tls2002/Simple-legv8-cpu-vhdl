# Simple-legv8-cpu-vhdl

## Overview
A simplified LEGv8-inspired 16-bit CPU implemented in VHDL and simulated using ModelSim.

## Block Diagram

## Architecture
Single-cycle datapath with 7 components:
  - PC (Program Counter).
  - Instruction Memory.
  - Data Memory.
  - Register File (16 registers).
  - ALU (8 operations).
  - Control Unit.

## ISA 
16 - bit instructions, 4 formats:
Format          Instructions
  R             ADD, SUB, MUL, DIV, AND, ORR
  I             ADDI, SUBI, LSL, LSR
  D             LDR, STR
  B             B, BEQ, BLT, BGT

## R and I-format Opcodes ##
ADD R0, R1, R2        Format: R-Format, Opcode: 0001
SUB R0, R1, R2        Format: R-Format, Opcode: 0010
MUL R0, R1, R2        Format: R-Format, Opcode: 0011
DIV R0, R1, R2        Format: R-Format, Opcode: 0100
AND R0, R1, R2        Format: R-Format, Opcode: 0101
ORR R0, R1, R2        Format: R-Format, Opcode: 0110
ADDI R0, R1, #Const;  Format: I-Format, Opcode: 1001
SUBI R0, R1, #Const;  Format: I-Format, Opcode: 1010
LSL R0, R1, #Const;   Format: I-Format, Opcode: 1011
LSR R0, R1, #Const;   Format: I-Format, Opcode: 1100

## D-Format Opcodes
LDR R0, [R1, #Offset]  Format: D-Format, Opcode: 1101
STR R0, [R1, #Offset]  Format: D-Format, Opcode: 1110

## B-Format Opcodes
B Label                Format: B-Format, Opcode: 1111
BEQ R0, Label          Format: B-Format, Opcode: 0000
BLT R0, Label          Format: B-Format, Opcode: 0111
BGT R0, Label          Format: B-Format, Opcode: 1000

