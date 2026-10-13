# max-cpu Instruction Set Architecture

## 1. Architecture Overview

MAX-CPU is a custom 8-bit, RISC-inspired processor designed and implemented in SystemVerilog.

| Component                 | Specification                         |
| ------------------------- | ------------------------------------- |
| Data width                | 8 bits                                |
| Instruction width         | 16 bits                               |
| General-purpose registers | 8 (R0–R7)                             |
| Register width            | 8 bits                                |
| Register address width    | 3 bits                                |
| Program counter (PC)      | 8 bits                                |
| ISA opcode width          | 4 bits                                |
| Instruction memory        | 256 × 16-bit instructions             |
| Data memory               | 256 × 8-bit values                    |
| Byte ordering             | Not applicable to 8-bit data accesses |

All eight registers are general-purpose, including R0. No register is hardwired to zero.

The processor uses separate instruction and data memories.

## 2. Register Encoding

Each register is selected using a 3-bit address.

| Register | Binary address |
| -------- | -------------- |
| R0       | `000`          |
| R1       | `001`          |
| R2       | `010`          |
| R3       | `011`          |
| R4       | `100`          |
| R5       | `101`          |
| R6       | `110`          |
| R7       | `111`          |

Registers hold 8-bit values (`0–255` when interpreted as unsigned).

## 3. Instruction Set

Each instruction is 16 bits wide, with the opcode stored in bits `[15:12]`.

| Opcode | Instruction      | Operation                  |
| ------ | ---------------- | -------------------------- |
| `0000` | `ADD rD, rA, rB` | `rD = rA + rB`             |
| `0001` | `SUB rD, rA, rB` | `rD = rA - rB`             |
| `0010` | `AND rD, rA, rB` | `rD = rA & rB`             |
| `0011` | `OR rD, rA, rB`  | `rD = rA \| rB`            |
| `0100` | `XOR rD, rA, rB` | `rD = rA ^ rB`             |
| `0101` | `MOV rD, rA`     | `rD = rA`                  |
| `0110` | `LOADI rD, imm8` | `rD = imm8`                |
| `0111` | `LOAD rD, [rA]`  | `rD = MEM[rA]`             |
| `1000` | `STORE rS, [rA]` | `MEM[rA] = rS`             |
| `1001` | `JMP addr8`      | `PC = addr8`               |
| `1010` | `JZ addr8`       | Jump if zero flag is set   |
| `1011` | `HALT`           | Stop instruction execution |

Opcodes `1100–1111` are reserved for future expansion.

## 4. Instruction Formats

### 4.1 Register-Type (R-Type)

Used by `ADD`, `SUB`, `AND`, `OR`, and `XOR`.

| Bits      | Field            | Width |
| --------- | ---------------- | ----- |
| `[15:12]` | Opcode           | 4     |
| `[11:9]`  | rD (destination) | 3     |
| `[8:6]`   | rA (source A)    | 3     |
| `[5:3]`   | rB (source B)    | 3     |
| `[2:0]`   | Reserved         | 3     |

Reserved bits must be zero.

Example:

`ADD R3, R1, R2`

```text
0000 011 001 010 000
```

### 4.2 Move Instruction

Used by `MOV`.

| Bits      | Field           |
| --------- | --------------- |
| `[15:12]` | Opcode          |
| `[11:9]`  | rD              |
| `[8:6]`   | rA              |
| `[5:0]`   | Reserved (zero) |

Example:

`MOV R3, R1`

```text
0101 011 001 000000
```

### 4.3 Immediate-Type (I-Type)

Used by `LOADI`.

| Bits      | Field           |
| --------- | --------------- |
| `[15:12]` | Opcode          |
| `[11:9]`  | rD              |
| `[8]`     | Reserved (zero) |
| `[7:0]`   | Immediate value |

The immediate is an 8-bit constant stored directly in the instruction.

Example:

`LOADI R3, 42`

```text
0110 011 0 00101010
```

### 4.4 Memory-Type (M-Type)

Used by `LOAD` and `STORE`.

| Bits      | Field                        |
| --------- | ---------------------------- |
| `[15:12]` | Opcode                       |
| `[11:9]`  | rD for LOAD / rS for STORE   |
| `[8:6]`   | rA (memory address register) |
| `[5:0]`   | Reserved (zero)              |

The contents of rA specify the 8-bit data-memory address.

Examples:

- `LOAD R3, [R1]` — read memory at the address stored in R1, and put the value into R3.
- `STORE R3, [R1]` — write the value in R3 to memory at the address stored in R1.

### 4.5 Jump-Type (J-Type)

Used by `JMP` and `JZ`.

| Bits      | Field               |
| --------- | ------------------- |
| `[15:12]` | Opcode              |
| `[11:8]`  | Reserved (zero)     |
| `[7:0]`   | Instruction address |

Jump addresses are absolute 8-bit instruction addresses, not offsets.

Example:

`JMP 12`

```text
1001 0000 00001100
```

### 4.6 Halt Instruction

`HALT` has no operands.

| Bits      | Field           |
| --------- | --------------- |
| `[15:12]` | `1011`          |
| `[11:0]`  | Reserved (zero) |

Encoding:

```text
1011 0000 00000000
```

## 5. Arithmetic Behaviour

All arithmetic operates on 8-bit values.

- ADD and SUB retain only the lowest 8 bits of the result.
- Results wrap modulo 256.
- Bitwise operations operate independently on each bit.
- No signed overflow or carry flag is implemented in V1.

For example:

```text
250 + 10 = 260
8-bit result = 4
```

Registers store raw bit patterns. Signed and unsigned interpretation may be extended in future versions.

## 6. Zero Flag

The processor maintains one architectural status flag:

`Z` — Zero flag.

The flag is updated by:

- ADD
- SUB
- AND
- OR
- XOR

After each of these instructions:

```text
Z = 1 if the 8-bit result is zero
Z = 0 otherwise
```

`MOV`, `LOADI`, `LOAD`, `STORE`, `JMP`, and `JZ` do not change Z.

The zero flag retains its previous value until another ALU instruction updates it.

After reset, Z is cleared to `0`.

### Conditional Branching

`JZ addr8` checks the current zero flag.

- If `Z = 1`, load `addr8` into the PC.
- If `Z = 0`, continue to the next sequential instruction.

Example:

```asm
LOADI R1, 5
LOADI R2, 5
SUB R3, R1, R2
JZ 10
```

Since R1 and R2 are equal, subtraction produces zero and the CPU jumps to instruction address 10.

## 7. Program Counter Behaviour

The PC contains the address of the current instruction.

- Reset sets the PC to zero.
- Normal execution advances the PC by one instruction.
- JMP replaces the PC with its target address.
- A taken JZ replaces the PC with its target address.
- An untaken JZ advances the PC normally.
- PC arithmetic wraps at 8 bits.

Instruction addresses range from `0` to `255`.

## 8. Reset and Halt Behaviour

### Reset

When reset is asserted and sampled on the rising clock edge:

- PC is set to `0`.
- Zero flag is cleared.
- The processor returns to its running state.

General-purpose registers and data memory are not required to be cleared by reset. Programs must initialise values before relying on them.

### Halt

`HALT` stops the processor from executing further instructions.

The processor remains halted until reset. Register contents and memory contents are preserved.
