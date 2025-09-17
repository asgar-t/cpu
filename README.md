# Mini CPU in Verilog - In Progress

## Motivation
I built this project because I wanted to learn Verilog, get hands-on experience with Xilinx Vivado (especially simulation and synthesis tools), and deepen my understanding of computer architecture. By implementing a small CPU from scratch, I gained insight into how instructions are encoded, executed, and tested in hardware.

## Features
This CPU currently supports a rich set of operations, including arithmetic, logic, memory, and branching instructions. Each instruction is encoded as a 5-bit parameter:

### Arithmetic Instructions
- `ADD (0)` – Add  
- `SUB (1)` – Subtract  
- `ADDC (2)` – Add with carry  
- `MULS (3)` – Multiply signed  
- `MULU (4)` – Multiply unsigned  
- `DIVS (5)` – Divide signed  
- `DIVU (6)` – Divide unsigned  
- `MODS (16)` – Modulus signed  
- `MODU (17)` – Modulus unsigned  
- `INC (14)` – Increment  
- `DEC (15)` – Decrement  
- `ABS (18)` – Absolute value  

### Logical & Bitwise Instructions
- `AND (7)` – Bitwise AND  
- `OR (8)` – Bitwise OR  
- `XOR (9)` – Bitwise XOR  
- `NOT (10)` – Bitwise NOT  
- `SL (11)` – Shift left  
- `SR (12)` – Shift right (logical)  
- `ASR (13)` – Arithmetic shift right  

### Comparison Instructions
- `CMP (19)` – Compare (sets flags)  

### Immediate & Load Instructions
- `LIL (20)` – Load immediate lower  
- `LIU (21)` – Load immediate upper  
- `LAL (25)` – Load address lower  
- `LAU (26)` – Load address upper  

### Memory & Register Transfer
- `RTM (22)` – Register to memory  
- `MTR (23)` – Memory to register  
- `RTR (24)` – Register to register  

### Branch & Control Flow
- `JZ (27)` – Jump if zero  
- `JNE (28)` – Jump if not equal  
- `JE (29)` – Jump if equal  
- `JGT (30)` – Jump if greater than  
- `JLT (31)` – Jump if less than  

## Future Plans
I plan to continue extending this CPU with more features, including:
- **Keyboard input** – Add basic I/O support to interact with the CPU.  
- **Graphics output** – Simple framebuffer or VGA-like interface.  
- **RAM execution** – Move beyond ROM-only execution by implementing RAM support and a bootloader.  
- **Assembler + compiler** – Write tools to generate machine code for this CPU.  
- **Interrupt handling** – Add hardware interrupt support for I/O devices.  
- **Pipelining** – Experiment with CPU performance improvements.  

## Tools Used
- **Language:** Verilog  
- **Toolchain:** Xilinx Vivado (simulation + synthesis)  
- **Target Platform:** FPGA (future deployment)  

## Getting Started
1. Clone the repository  
2. Open the project in Vivado  
3. Run simulation to test the instruction set  
4. (Future) Synthesize and deploy to FPGA  

---

🚀 This project is an ongoing learning journey in digital design and computer architecture. Contributions and suggestions are welcome!
