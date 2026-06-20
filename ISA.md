<table>
<tr>
<td width="120">

<img src="Images/8-bit-icon.png" width="100"/>

</td>

<td>

# <p align="center">8-BIT COMPUTER ARCHITECTURE</p>

</td>
</tr>
</table>

---

<p align="center">
<img src="Images/8BIT.gif" width="1000" height="400"/>
</p>

[![FPGA](https://img.shields.io/badge/FPGA-Boolean_Board-blue.svg)](#)
[![Device](https://img.shields.io/badge/Device-XC7S50--CSGA324--1-orange.svg)](#)
[![Language](https://img.shields.io/badge/HDL-Verilog-brightgreen.svg)](#)
[![Toolchain](https://img.shields.io/badge/Synthesis-Xilinx_Vivado-red.svg)](#)

---
## 📑 Table of Contents
1. [Project Overview](#-project-overview)
2. [Hardware Specifications](#-hardware-specifications)
3. [Architectural Design & Data Path](#-architectural-design--data-path)
4. [Hardware Modules Deep-Dive](#-hardware-modules-deep-dive)
5. [Instruction Set Architecture (ISA)](#-instruction-set-architecture-isa)
6. [✨ Novelty: Variable T-Cycle Execution](#-novelty-variable-t-cycle-execution)
7. [Implementation & Demo](#-implementation--demo)
8. [Contributors](#-contributors)

---

## 🚀 Project Overview

The goal of this project is to bridge the gap between abstract computer organization concepts and physical FPGA implementation. By writing custom Verilog for every register, memory module, and control unit, this processor is capable of executing a customized 16-instruction ISA.   

---
For simulation : [Click here](#-http://127.0.0.1:5501/index.html)

---
### Key Objectives:
* Design a modular, bus-driven 8-bit architecture.
* Implement a robust ALU capable of arithmetic, logical, and shift operations.
* **Optimize Performance:** Introduce dynamic execution phases to ensure instructions only consume the exact number of clock cycles required, drastically improving instruction throughput.
* Interface with physical hardware (Slide switches for inputs, multiplexed 7-segment displays for output).

---

## 🧰 Hardware Specifications
* **Target Development Board:** Real Digital Boolean Board
* **FPGA Silicon:** Xilinx Spartan-7 `XC7S50-CSGA324-1`
* **Clocking:** 100 MHz onboard oscillator (custom clock dividers implemented for 1Hz CPU execution and 381Hz display multiplexing).
* **Inputs:** 8x Slide Switches (Mapped to `input_register`)
* **Outputs:** 8-Digit 7-Segment Display array and onboard LEDs (Mapped to `output_display` and `output_register`).

---

## 🏗️ Architectural Design & Data Path

The processor relies on an 8-bit central data bus topology. Data flow is entirely governed by the `control_unit`, which systematically enables tri-state buffers to move data between specific registers during discrete timing phases (T-Cycles).

![8-Bit Architecture Block Diagram](./images/8BIT-ARCHITECTURE.png)
*(Fig 1. Visual representation of the central data bus, hardware modules, and active control signal routing).*

---

## 🛠️ Hardware Modules Deep-Dive

The architecture is built using strict modular Verilog blocks connected via an 8-bit central data bus. 

### 🧠 Processing & Control Logic
| Module | Description | Key Inputs | Key Outputs |
| :--- | :--- | :--- | :--- |
| **`alu`** | The mathematical core for arithmetic & logic. | `a_reg`, `b_reg`, `alu_op`, `alu_out` | `result_out`, `carry_out`, `zero_out` |
| **`control_unit`** | The state machine driving all data routing. | `clk`, `rst`, `opcode` | Control lines (e.g., `mar_in`, `ram_out`, `alu_op`) |

### 📦 Registers & State
| Module | Description | Key Inputs | Key Outputs |
| :--- | :--- | :--- | :--- |
| **`a_reg` & `b_reg`** | 8-bit holding registers for ALU operations. | `clk`, `rst`, `reg_in`, `reg_out` | Data out to central bus |
| **`flag_reg`** | Stores conditional states for branching. | `clk`, `flag_en`, `carry_out`, `zero_out`| `zero_f`, `carry_f` |
| **`prgm_counter`** | 4-bit PC pointing to the next instruction. | `clk`, `pc_l` (Load), `pc_e` (Count) | `pc_out` (To Bus) |

### 💾 Memory & Addressing
| Module | Description | Key Inputs | Key Outputs |
| :--- | :--- | :--- | :--- |
| **`ram`** | Memory block storing instructions and data. | `addr`, `din`, `ram_in`, `ram_out` | `mem_r` (Data to Bus) |
| **`mem_addr_reg`** | Latches the 4-bit RAM address (MAR). | `clk`, `rst`, `mar_in` | 4-bit Address to RAM |
| **`instruction_reg`** | Latches the 8-bit instruction (IR). | `clk`, `ir_in`, `ir_out` | `opcode` (To CU), Operand (To Bus) |

### 🔌 Input / Output Interfaces
| Module | Description | Physical Interface |
| :--- | :--- | :--- |
| **`input_register`** | Captures 8-bit data from the user. | 8x Slide Switches |
| **`output_register`** | Latches data from the bus for display. | Internal routing |
| **`output_display`** | Multiplexed BCD-to-7-Segment decoder. | 8-Digit 7-Segment Display |
---

## 📖 Instruction Set Architecture (ISA)

The architecture uses an 8-bit instruction format. The **4 Most Significant Bits (MSB)** represent the Opcode, and the **4 Least Significant Bits (LSB)** represent the Operand (address or immediate value).

| Hex | Opcode (Bin) | Mnemonic | Operation Description |
| :---: | :---: | :--- | :--- |
| `0x0` | `0000` | **INP** | Load Accumulator (A-Reg) from physical switch inputs. |
| `0x1` | `0001` | **OUT** | Dispatch Accumulator data to Output Register/Display. |
| `0x2` | `0010` | **LDA** | Load data from RAM address into Accumulator. |
| `0x3` | `0011` | **STA** | Store Accumulator data into RAM address. |
| `0x4` | `0100` | **LDAI** | Load immediate 4-bit operand directly into Accumulator. |
| `0x5` | `0101` | **HLT** | Halt clock. Program terminated. |
| `0x6` | `0110` | **JMPA** | Unconditional jump to target PC address. |
| `0x7` | `0111` | **JMPZ** | Conditional Jump: Executes if ALU `ZERO_FLAG` == 1. |
| `0x8` | `1000` | **JMPC** | Conditional Jump: Executes if ALU `CARRY_FLAG` == 1. |
| `0x9` | `1001` | **ADD** | Mathematical: `A_Reg` = `A_Reg` + `B_Reg` |
| `0xA` | `1010` | **SUB** | Mathematical: `A_Reg` = `A_Reg` - `B_Reg` |
| `0xB` | `1011` | **SRA** | Bitwise: Shift Right Arithmetic (A-Reg) |
| `0xC` | `1100` | **SLL** | Bitwise: Shift Left Logical (A-Reg) |
| `0xD` | `1101` | **AND** | Logical: `A_Reg` AND `B_Reg` |
| `0xE` | `1110` | **OR** | Logical: `A_Reg` OR `B_Reg` |
| `0xF` | `1111` | **XOR** | Logical: `A_Reg` XOR `B_Reg` |

---

## ✨ Novelty: Variable T-Cycle Execution

### The Problem with Legacy Architectures
Standard architectures (like the foundational SAP-1) utilize a fixed T-State pipeline. If the most complex instruction (like `ADD`) requires 5 clock cycles, *every* instruction is forced to take 5 clock cycles, padding simpler instructions with `NOP` (No Operation) dead time. This wastes power and severely bottlenecks instruction throughput.

### The Solution: Dynamic Execution States
This architecture introduces a **Variable T-Cycle Control Unit**. The state machine monitors the active `opcode` and intentionally short-circuits the ring counter, terminating the execution phase the exact microsecond the data path completes.
#### 1. Universal Fetch Phase (2 Cycles)
This phase runs identically at the beginning of every instruction to retrieve the opcode from memory.

| T-Cycle | Source | Destination | Action |
| :---: | :--- | :--- | :--- |
| **T0** | Program Counter (`PC`) | Memory Address Reg (`MAR`) | Load instruction address |
| **T1** | Memory (`RAM`) | Instruction Reg (`IR`) | Fetch 8-bit instruction |

#### 2. Dynamic Execution Phase (1 to 3 Cycles)
Instead of padded `NOP` cycles, the control unit terminates the execution immediately after the final required data movement.

| Instruction Category | Total Cycles | Instructions | Execution Path Example |
| :--- | :---: | :--- | :--- |
| **High-Speed** | **3** | `INP`, `OUT`, `HLT`, `LDAI`, `JMPA`, `JMPZ`, `JMPC` | **T2:** `IR` → `PC` *(Execution Terminates)* |
| **Memory Access** | **4** | `LDA`, `STA` | **T2:** `IR` → `MAR`<br>**T3:** `RAM` → `A-Reg` *(Execution Terminates)* |
| **Computation** | **5** | `ADD`, `SUB`, `SRA`, `SLL`, `AND`, `OR`, `XOR` | **T2:** `IR` → `MAR`<br>**T3:** `RAM` → `B-Reg`<br>**T4:** `ALU` → `A-Reg` *(Execution Terminates)* |


**Result:** A highly responsive CPU core that maximizes logic fabric utilization and processes compiled code significantly faster than fixed-cycle equivalents.

---

## 💻 Implementation & Demo

To run this project:
1. Clone the repository and open the `.xpr` project file in **Xilinx Vivado**.
2. Run Synthesis and Implementation. Note: Ensure the Boolean board `.xdc` constraints file accurately maps the 100MHz clock to the `clk` input, and the slide switches to `binary_in`.
3. Generate the Bitstream and program the device. 

---
## Contributors

Thaaroone S A : [Linkedin](#-https://www.linkedin.com/in/thaaroone-sarvajit-9b9b09329/) , [Github](#-)        
Janadini S K : [Linkedin](#-https://www.linkedin.com/in/janadini-s-k-508910338/) , [Github](#-)
