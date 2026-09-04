# RV32I Single-Cycle Core

This directory contains the implementation of a 32-bit single-cycle processor based on the official **RISC-V (RV32I)** Instruction Set Architecture. 

## 🏗️ Architecture Overview
Unlike the custom 8-bit CPU from Phase 2, this processor strictly adheres to the industry-standard RISC-V specification:
* **32-bit Datapath:** All registers, ALUs, and memory buses are 32 bits wide.
* **Register File:** 32 general-purpose registers (`x0` to `x31`), where `x0` is strictly hardwired to zero.
* **Byte-Addressable Memory:** While instructions are 32-bits wide, memory is addressed at the byte level (meaning the Program Counter increments by 4 instead of 1).
* **Immediate Generation:** Complex combinatorial logic to un-scramble the aggressively optimized split-immediates of the RISC-V ISA (S-Type, B-Type, J-Type, etc.).

## 📜 Supported Instruction Subset
This core currently supports the fundamental instructions needed to run basic C programs:
* **R-Type:** `add`, `sub`, `and`, `or`, `xor`, `slt`
* **I-Type:** `addi`, `lw`
* **S-Type:** `sw`
* **B-Type:** `beq`
* **J-Type:** `jal`
*(Note: U-Type extraction is supported by the hardware, but not yet wired to a specific instruction like `lui` in the Control Unit).*

## 📁 Directory Structure
* `/rtl` - Contains the Verilog hardware modules (`cpu.v`, `alu.v`, `control_unit.v`, etc.)
* `/sim` - Contains the testbenches for individual modules and the end-to-end CPU testbench.

## 🚀 Simulation
To run the end-to-end CPU simulation (which currently executes a hardcoded RISC-V machine-code program):
```bash
iverilog -o sim_cpu.out rtl/*.v sim/tb_cpu.v
vvp sim_cpu.out
```
