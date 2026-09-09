# UVM-Based Verification of 1×3 Router

## 📌 Project Overview

This project implements a **Universal Verification Methodology (UVM)** based verification environment for a **1×3 Packet Router** designed using Verilog/System Verilog.

The router receives packets through a single input port and routes them to one of three output ports based on the destination address present in the packet header.

The verification environment is developed using **SystemVerilog and UVM** and verifies the functionality of the router using constrained-random stimulus, functional coverage, assertions, and a scoreboard-based reference checking mechanism.

---

## 🎯 Objectives

* Verify the functional correctness of a 1×3 packet router.
* Develop a reusable **UVM-based verification environment**.
* Generate constrained-random packets for different packet sizes.
* Verify routing to all three output ports.
* Verify normal and erroneous packets.
* Implement a scoreboard for expected-vs-actual comparison.
* Measure functional coverage.
* Use System Verilog Assertions (SVA) to verify protocol and timing requirements.
* Perform regression testing using multiple test cases.

---

## 🏗️ Design Under Test

The router consists of:

* **1 input interface**
* **3 output interfaces**
* **1 router FSM**
* **3 independent FIFOs**
* **Synchronizers for output ports**
* **Packet routing logic**

### Router Architecture

```text
                         ┌─────────────────┐
                         │                 │
Input Packet ───────────►│    1×3 Router   │
                         │                 │
                         └───────┬─────────┘
                                 │
                  ┌──────────────┼──────────────┐
                  │              │              │
                  ▼              ▼              ▼
              ┌───────┐      ┌───────┐      ┌───────┐
              │ FIFO 0│      │ FIFO 1│      │ FIFO 2│
              └───┬───┘      └───┬───┘      └───┬───┘
                  │              │              │
                  ▼              ▼              ▼
               Output 0       Output 1       Output 2
```

---

## 📦 Packet Format

Each packet consists of:

```text

                ┌────────────────────────┐
                │      8-BIT HEADER      │
                ├────────────────┬───────┤
                │ Payload Length │  Addr │
                │    [7:2]       │ [1:0] │
                └────────────────┴───────┘
                            │
                            ▼
                ┌────────────────────────┐
                │        PAYLOAD         │
                │     Variable Length    │
                │     1 to 63 bytes      │
                └────────────────────────┘
                            │
                            ▼
                ┌────────────────────────┐
                │         PARITY         │
                │         8 bits         │
                └────────────────────────┘
```

The packet contains:

* Header
* Payload
* Parity

### Destination Address

| Address | Output   |
| ------: | -------- |
| `2'b00` | Output 0 |
| `2'b01` | Output 1 |
| `2'b10` | Output 2 |

---

# 🧪 Verification Environment

The testbench follows a standard UVM architecture.

```text
                         ┌──────────────────┐
                         │       TEST       │
                         └────────┬─────────┘
                                  │
                                  ▼
                    ┌──────────────────────────┐
                    │    VIRTUAL SEQUENCE      │
                    └────────────┬─────────────┘
                                 │
                                 ▼
                  ┌──────────────────────────────┐
                  │     VIRTUAL SEQUENCER        │
                  └──────────────┬───────────────┘
                                 │
                  ┌──────────────┴──────────────┐
                  │                             │
                  ▼                             ▼
        ┌──────────────────┐          ┌─────────────────────┐
        │   WRITE AGENT    │          │     READ AGENTS     │
        │                  │          │                     │
        │ ┌──────────────┐ │          │ ┌─────────────────┐ │
        │ │  Sequencer   │ │          │ │    Monitor 0    │ │
        │ └──────┬───────┘ │          │ └─────────────────┘ │
        │        │         │          │ ┌─────────────────┐ │
        │        ▼         │          │ │    Monitor 1    │ │
        │ ┌──────────────┐ │          │ └─────────────────┘ │
        │ │    Driver    │ │          │ ┌─────────────────┐ │
        │ └──────┬───────┘ │          │ │    Monitor 2    │ │
        └────────┼─────────┘          │ └─────────────────┘ │
                 │                    └──────────┬──────────┘
                 │                               │
                 ▼                               ▼
        ┌─────────────────────────────────────────────────┐
        │                  1×3 ROUTER DUT                 │
        │                                                 │
        │              Input Packet                       │
        │                   │                             │
        │                   ▼                             │
        │          ┌──────────────────┐                   │
        │          │   Router Logic   │                   │
        │          └────────┬─────────┘                   │
        │                   │                             │
        │          ┌────────┼────────┐                    │
        │          ▼        ▼        ▼                    │
        │       Output 0  Output 1  Output 2              │
        └──────────┬────────┬────────┬────────────────────┘
                   │        │        │
                   └────────┼────────┘
                            ▼
                   ┌──────────────────┐
                   │    SCOREBOARD    │
                   │                  │
                   │ Expected vs      │
                   │ Actual Compare   │
                   └──────────────────┘
```

---

## 🔹 UVM Components

### 1. Sequence Item

Two transaction classes are used:

* `write_xtn`
* `read_xtn`

They represent packets transmitted to and received from the router.

---

### 2. Sequences

Different sequences are used to generate various packet types:

* Small packet sequence
* Medium packet sequence
* Large packet sequence
* Small Bad packet sequence
* Medium Bad packet sequence
* Large Bad packet sequence
* Soft-reset sequence
* Normal packet sequence

---

### 3. Sequencers

The verification environment contains:

* Write sequencer
* Multiple read sequencers
* Virtual sequencer

The virtual sequencer coordinates transactions between the write and read sides.

---

### 4. Driver

The write driver drives packet transactions from the UVM testbench into the DUT.

```text
Sequence
   ↓
Sequencer
   ↓
Driver
   ↓
  DUT
```

---

### 5. Monitor

The monitors observe DUT activity without driving signals.

The read monitor collects:

```text
Header
  ↓
Payload
  ↓
Parity
```

and converts the observed data into a `read_xtn` transaction.

---

### 6. Scoreboard

The scoreboard compares:

```text
Expected Transaction
        ↓
   Write Monitor
        ↓
   Source FIFO
        ↓
     Compare
        ↑
   Destination FIFO
        ↑
   Read Monitor
        ↑
Actual Transaction
```

The source and destination transactions are collected concurrently using `fork...join`.

After both transactions are available, the scoreboard performs:

```systemverilog
compare(w_xtn, r_xtn);
```

This verifies whether the packet was correctly routed.

---

# 📊 Functional Coverage

Functional coverage is implemented to measure the verification completeness.

### Address Coverage

```text
00 → Output 0
01 → Output 1
10 → Output 2
```

### Packet Length Coverage

| Packet Type | Length |
| ----------- | ------ |
| Small       | 1–20   |
| Medium      | 21–40  |
| Large       | 41–63  |

### Error Coverage

Both valid and erroneous packets are covered.

```text
ERROR = 0 → Valid packet
ERROR = 1 → Error packet
```

### Cross Coverage

The following combinations are covered:

```text
Address × Packet Length × Error
```

and:

```text
Address × Packet Length
```

This helps ensure that different packet sizes, destinations, and error conditions are exercised.

---

# 🔍 System Verilog Assertions

SystemVerilog Assertions are used to verify protocol and timing behavior.

Examples include:

### Data Stability

The input data should remain stable when the router is busy.

```systemverilog
property stable_data;
  @(posedge clock)
    in.busy |=> $stable(in.din);
endproperty
```

### Busy Check

When a packet becomes valid, the router should enter the required busy condition.

```systemverilog
property busy_check;
  @(posedge clock)
    $rose(in.pkt_valid) |=> in.busy;
endproperty
```

### Read Enable Check

The read enable signal should occur within the specified clock-cycle window after valid output.

```systemverilog
property rd_en0;
  @(posedge clock)
    in0.valid_out |-> ##[1:29] in0.read_enb;
endproperty
```

---

# 🧪 Test Cases

The project contains multiple test scenarios.

| Test              | Purpose                         |
| ----------------- | ------------------------------- |
| `small_test`      | Verify small packets            |
| `medium_test`     | Verify medium-sized packets     |
| `large_test`      | Verify large packets            |
| `small_bad_test`  | Verify erroneous small packets  |
| `medium_bad_test` | Verify erroneous medium packets |
| `large_bad_test`  | Verify erroneous large packets  |

Random destination addresses are also generated during testing.

---

# 🔄 Virtual Sequence Flow

The virtual sequence coordinates write and read operations.

```text
              Virtual Sequence
                     │
              ┌──────┴──────┐
              │             │
              ▼             ▼
       Write Sequence   Read Sequence
              │             │
              ▼             ▼
        Write Agent     Read Agent
              │             │
              └──────┬──────┘
                     ▼
                    DUT
```

Write and read sequences are started concurrently using:

```systemverilog
fork
  write_seq.start(wr_seqrh[0]);
  read_seq.start(rd_seqrh[addr]);
join
```

---

# 🛠️ Tools and Technologies

### Hardware Description / Verification

* Verilog
* System Verilog
* UVM

### Simulator

* QuestaSim

### Verification Techniques

* Constrained Random Verification
* Functional Coverage
* System Verilog Assertions
* Scoreboard-based checking
* UVM Factory
* UVM Configuration Database
* Virtual Sequences
* Regression Testing

---

# ▶️ Running the Project

## 1. Compile

Open QuestaSim and compile the project using the Makefile.

```bash
make sv_cmp
```

---

## 2. Run Small Packet Test

```bash
make small_test
```

---

## 3. Run Medium Packet Test

```bash
make medium_test
```

---

## 4. Run Large Packet Test

```bash
make large_test
```

---

## 5. Run Bad Packet Tests

```bash
make small_bad_test
make medium_bad_test
make large_bad_test
```

---

# 📈 Coverage

Coverage databases are generated for individual tests.

Example:

```text
mem_cov1
mem_cov2
mem_cov3
mem_cov4
mem_cov5
mem_cov6
```

The individual coverage databases can be merged into a single regression coverage database.

```bash
vcover merge mem_cov \
    mem_cov1 \
    mem_cov2 \
    mem_cov3 \
    mem_cov4 \
    mem_cov5 \
    mem_cov6
```

A coverage report can then be generated using:

```bash
vcover report -html mem_cov
```

---

# 🔁 Regression

The complete regression runs multiple test cases and combines their coverage results.

```text
small_test
     ↓
medium_test
     ↓
large_test
     ↓
small_bad_test
     ↓
medium_bad_test
     ↓
large_bad_test
     ↓
Coverage Merge
     ↓
Final Coverage Report
```

---

# 📋 Verification Features

The project demonstrates the following UVM concepts:

* ✅ UVM Test
* ✅ UVM Environment
* ✅ UVM Agents
* ✅ UVM Driver
* ✅ UVM Monitor
* ✅ UVM Sequencer
* ✅ UVM Sequence
* ✅ Virtual Sequencer
* ✅ Virtual Sequence
* ✅ UVM Configuration Database
* ✅ UVM Factory
* ✅ Analysis Ports
* ✅ Analysis FIFOs
* ✅ Scoreboard
* ✅ Constrained Randomization
* ✅ Functional Coverage
* ✅ Cross Coverage
* ✅ System Verilog Assertions
* ✅ Multiple Test Cases
* ✅ Regression Testing
* ✅ QuestaSim Coverage

---

# 🎓 Learning Outcomes

Through this project, the following verification concepts were practiced:

1. Building a complete UVM testbench from scratch.
2. Creating reusable UVM components.
3. Generating constrained-random transactions.
4. Coordinating multiple agents using a virtual sequencer.
5. Comparing expected and actual transactions using a scoreboard.
6. Measuring functional and cross coverage.
7. Writing temporal assertions using SystemVerilog Assertions.
8. Debugging UVM factory and configuration issues.
9. Running multiple tests through a Makefile.
10. Generating and merging QuestaSim coverage databases.

---

# 👨‍💻 Author

**Mohana Manikandan R**

B.E. Electronics and Communication Engineering
Chennai Institute of Technology

### Areas of Interest

* VLSI Design
* Digital Verification
* SystemVerilog
* UVM
* FPGA
* Embedded Systems
* Low-Power VLSI

---
