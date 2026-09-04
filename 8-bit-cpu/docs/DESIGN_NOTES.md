# Design Notes

## Why this ISA

Kept deliberately minimal: 8 instructions, 8-bit instructions (4-bit opcode + 4-bit operand), 4 registers. The goal wasn't a *useful* CPU — it was learning the actual shape of CPU architecture (fetch/decode/execute, datapath vs. control unit, register files, memory-mapped I/O style thinking) without the complexity of a real spec getting in the way on the first attempt.

## Single-cycle instead of multi-cycle FSM

The original plan was a 3-state FSM (Fetch → Decode → Execute), spread across multiple clock cycles per instruction. Partway through, I realized this wasn't necessary: instruction memory, data memory reads, and register file reads are all combinational (no clock needed) in this design — only writes (register file, data memory, PC) need a clock edge. That means an entire instruction can fetch, decode, and execute within a single clock cycle, with only the final state changes waiting for the clock.

This ended up being a useful accident — a single-cycle datapath is exactly what the RV32I core (Phase 4) needs, so building this way now means the *shape* of the next CPU is already familiar, not something to learn from scratch later.

## The halt-freeze trick

`pc.v` only knows how to increment or jump — it has no "stay still" instruction. Rather than adding a third mode to an already-tested module, the top-level `cpu.v` handles halting by forcing the PC to "jump" to its own current address whenever `halted` is asserted. Simple, and it meant not touching a module that was already verified working in isolation.

## Two known limitations

- **No real comparison instructions.** JZ only branches on a zero flag from the *previous* ALU operation — there's no dedicated "compare A and B" instruction. This makes writing loops with arbitrary termination conditions (e.g. "count until 10") awkward without extra ADD/SUB gymnastics. Real ISAs (including RISC-V's `beq`/`bne`/`blt`) solve this properly with dedicated compare-and-branch instructions — something to appreciate once I get to Phase 4.
- **Separate, small address spaces.** Instruction memory (16 slots) and data memory (4 slots) are sized just large enough for the test program, not for general use. Fine for a learning project; a real design would size these based on actual requirements or make them configurable.


