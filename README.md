# RV32I Single-Cycle Processor Core

This repository documents a progressive, semester-long journey from learning basic digital logic to designing and implementing a fully functional 32-bit RISC-V processor core in Verilog.

## 📁 Project Structure

The repository is divided into the major milestones of the project:

* **[`/8-bit-cpu`](./8-bit-cpu/)** - **(Completed)** A custom 8-bit CPU built from scratch with its own minimal Instruction Set Architecture (ISA). This phase served as a practical introduction to single-cycle datapath design, control units, and Verilog simulation.
* **[`/rv32i-core`](./rv32i-core/)** - **(Completed)** A 32-bit single-cycle CPU implementing the base integer subset of the official RISC-V ISA (`RV32I`). Features a 32x32 register file, ALU, instruction/data memories, and an immediate generator capable of running real RISC-V machine code.

## 🗺️ Semester Roadmap & Progress

- [x] **Phase 0: Setup**
  - Installed Icarus Verilog, GTKWave, and established simulation environments.
- [x] **Phase 1: Learn Verilog Fundamentals**
  - Mastered combinational and sequential logic, FSMs, and testbenches.
  - Built basic components (Adders, MUXes, Flip-Flops).
- [x] **Phase 2: Design & Build an 8-bit CPU**
  - Designed a custom minimal 8-bit ISA on paper.
  - Built the datapath (Registers, ALU, PC, Memory) and Control Unit.
  - Verified execution of hand-assembled test programs via simulation.
- [x] **Phase 3: Bridge to RISC-V**
  - Transitioned from custom ISA to the industry-standard RISC-V specification.
  - Mapped the 6 core instruction formats (R, I, S, B, U, J) and 32-register architecture.
- [x] **Phase 4: Build a Single-Cycle RV32I Core**
  - Built a 32-bit datapath supporting Arithmetic, Immediates, Memory (`lw`/`sw`), and Branching/Jumps.
  - Verified end-to-end execution of a RISC-V machine code program.
- [x] **Phase 5: Toolchain Integration** *(Completed)*
  - Compile C programs using the RISC-V GNU Toolchain.
  - Load compiled C code into the core's Instruction Memory and execute it.
- [ ] **Phase 6: Pipelining (Stretch Goal)**
  - Convert the single-cycle core into a 2 or 3-stage pipeline.
  - Handle data/control hazards, forwarding, and stalling.

## 🛠️ Tools Used
* **Icarus Verilog (iverilog)** - Compilation and simulation
* **GTKWave** - Waveform viewing and debugging
