# Simple LEGv8 CPU (VHDL)

## Overview
A simplified LEGv8-inspired 16-bit CPU implemented in VHDL and simulated using ModelSim.  
This project demonstrates a basic single-cycle processor design, including datapath, control logic, and instruction execution.

---

## Features
- 16-bit architecture  
- Single-cycle datapath  
- 16 general-purpose registers  
- 8 ALU operations  
- Custom instruction set (R, I, D, B formats)

---

## Architecture
The CPU is composed of the following components:

- Program Counter (PC)  
- Instruction Memory  
- Data Memory  
- Register File (16 registers)  
- Arithmetic Logic Unit (ALU)  
- Control Unit  

---

## Block Diagram
"/Diagram/Block Diagram.png"

---

## Instruction Set Architecture (ISA)

### Instruction Formats
| Format | Description |
|--------|------------|
| R      | Register-to-register operations |
| I      | Immediate operations |
| D      | Memory access |
| B      | Branch instructions |

---

### R-Format Instructions
| Instruction | Operation | Opcode |
|------------|----------|--------|
| ADD R0, R1, R2 | R0 = R1 + R2 | 0001 |
| SUB R0, R1, R2 | R0 = R1 - R2 | 0010 |
| MUL R0, R1, R2 | R0 = R1 * R2 | 0011 |
| DIV R0, R1, R2 | R0 = R1 / R2 | 0100 |
| AND R0, R1, R2 | Bitwise AND | 0101 |
| ORR R0, R1, R2 | Bitwise OR | 0110 |

---

### I-Format Instructions
| Instruction | Operation | Opcode |
|------------|----------|--------|
| ADDI R0, R1, #C | R0 = R1 + C | 1001 |
| SUBI R0, R1, #C | R0 = R1 - C | 1010 |
| LSL R0, R1, #C | Shift left | 1011 |
| LSR R0, R1, #C | Shift right | 1100 |

---

### D-Format Instructions
| Instruction | Operation | Opcode |
|------------|----------|--------|
| LDR R0, [R1, #O] | Load from memory | 1101 |
| STR R0, [R1, #O] | Store to memory | 1110 |

---

### B-Format Instructions
| Instruction | Operation | Opcode |
|------------|----------|--------|
| B Label | Unconditional branch | 1111 |
| BEQ R0, Label | Branch if zero | 0000 |
| BLT R0, Label | Branch if less than | 0111 |
| BGT R0, Label | Branch if greater than | 1000 |

---

## Simulation (ModelSim)

1. Compile all VHDL files  
2. Load the testbench  
3. Run simulation:

```tcl
vsim work.cpu_tb
run -all
