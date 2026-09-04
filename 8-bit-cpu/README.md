# 8-bit CPU (Verilog)

A custom 8-bit CPU built from scratch in Verilog, with its own instruction set architecture (ISA). Simulated and verified with Icarus Verilog and GTKWave. This is the first CPU in a semester-long project that eventually targets a single-cycle RV32I RISC-V core.

## What it does

The CPU fetches, decodes, and executes hand-assembled 8-bit machine code, one instruction per clock cycle (single-cycle architecture). The included test program loads two values from memory, adds them, and outputs the result — verified end-to-end in simulation.

## Architecture

The CPU splits into two halves, communicating every clock cycle:

- **Datapath** — the components that hold and move data: Program Counter, Instruction Memory, Register File, ALU, Data Memory.
- **Control Unit** — a combinational decoder that reads the current instruction's opcode and drives every enable/select signal in the datapath. It contains no computation of its own — it's pure routing logic.

**Program Counter** → **Instruction Memory** (ROM, preloaded program) → **Control Unit** (decodes opcode → control signals) → drives **Register File**, **ALU**, and **Data Memory** (RAM) together each cycle.

Instruction memory and data memory are deliberately separate (a **Harvard architecture**) — the CPU never confuses "what to do" with "the numbers it's working on."

## Instruction Set Architecture

8-bit instructions: 4-bit opcode + 4-bit operand.

| Instruction | Opcode | Operand | Function |
|---|---|---|---|
| LOAD  | `0000` | `[Rd(2)][Addr(2)]` | Load memory[Addr] into Rd |
| STORE | `0001` | `[Rs(2)][Addr(2)]` | Store Rs into memory[Addr] |
| ADD   | `0010` | `[Rd(2)][Rs(2)]`   | Rd = Rd + Rs |
| SUB   | `0011` | `[Rd(2)][Rs(2)]`   | Rd = Rd - Rs |
| JUMP  | `0100` | `Addr(4)`           | PC = Addr |
| JZ    | `0101` | `Addr(4)`           | PC = Addr, if zero flag set |
| OUT   | `0110` | `[Rs(2)][unused(2)]`| Output Rs's value |
| HALT  | `1111` | unused               | Stop execution |

4 general-purpose registers (R0-R3), 16-location instruction memory, 4-location data memory.

## Repo structure

```
8-bit-cpu/
├── rtl/              # design files (the actual CPU)
│   ├── pc.v
│   ├── instr_mem.v
│   ├── data_mem.v
│   ├── register_file.v
│   ├── alu.v
│   ├── control_unit.v
│   └── cpu.v          # top-level, wires everything together
├── sim/               # testbenches, one per module in rtl/
├── exercises/          # Week 1 fundamentals practice (not part of the CPU itself)
└── docs/                # design notes and diagrams
```

## Running it

Requires [Icarus Verilog](https://bleyer.org/icarus/) and [GTKWave](https://gtkwave.sourceforge.net/).

```bash
iverilog -o sim.out rtl/pc.v rtl/instr_mem.v rtl/data_mem.v rtl/register_file.v rtl/alu.v rtl/control_unit.v rtl/cpu.v sim/tb_cpu.v
vvp sim.out
gtkwave wave.vcd
```

Expected output: the CPU runs the preloaded test program (add 5 + 7), outputs `12`, then halts.

## Design notes

See [docs/DESIGN_NOTES.md](docs/DESIGN_NOTES.md) for ISA design decisions, architectural tradeoffs, and what I'd do differently next time.
