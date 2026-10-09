# Day 10 --- MOD-10 Counter: Synchronous and Asynchronous Reset

```{=html}
<p align="center">
```
`<b>`{=html}Digital VLSI • Verilog RTL • Sequential Logic • Functional
Verification • Cadence Genus`</b>`{=html}
```{=html}
</p>
```
```{=html}
<p align="center">
```
`<code>`{=html}Specification → Architecture → RTL → Verification →
Synthesis → Technology Mapping → Area → Power → Timing →
PPA`</code>`{=html}
```{=html}
</p>
```

------------------------------------------------------------------------

## 1. Project Information

  -----------------------------------------------------------------------
  Parameter                           Details
  ----------------------------------- -----------------------------------
  **Project**                         Day 10 --- MOD-10 Counter

  **Domain**                          Digital VLSI / RTL Design

  **Design Type**                     Sequential Logic / Counter

  **HDL**                             Verilog HDL

  **Target Technology**               TSMC 180 nm (as identified by the
                                      supplied synthesis library name)

  **Library**                         `tsmc18`

  **Synthesis Tool**                  Cadence Genus 21.14-s082_1

  **Operating Condition**             `slow (balanced_tree)`

  **Wireload Mode**                   `enclosed`

  **Top Module**                      `mod10_counter_top`

  **Implementations**                 `mod10_counter_async`,
                                      `mod10_counter_sync`

  **Analysis Available**              Hierarchy, cell mapping, area,
                                      power, one setup-timing path

  **Status**                          Synthesis reports available;
                                      functional simulation evidence not
                                      supplied
  -----------------------------------------------------------------------

> **Evidence note:** This README records the reports supplied for this
> project. RTL source, testbench, waveform, complete timing summary, and
> separate per-counter power reports were not supplied in the
> conversation. Their completion is not assumed.

------------------------------------------------------------------------

## 2. Project Overview

A **MOD-10 counter** is a sequential circuit that cycles through ten
states, from decimal 0 to decimal 9, and then returns to 0.

This project contains two implementations:

-   `ASYNC_COUNTER` --- a counter with asynchronous reset.
-   `SYNC_COUNTER` --- a counter with synchronous reset.

Both implementations are instantiated under `mod10_counter_top`,
allowing their hierarchy and synthesis results to be examined in the
same top-level design.

The project focuses on the RTL-to-gate-level flow using Cadence Genus,
including standard-cell mapping, area analysis, power analysis, and
timing-report interpretation.

------------------------------------------------------------------------

## 3. Objectives

1.  Understand the operation of a MOD-10 counter.
2.  Determine the minimum state width required for ten states.
3.  Understand terminal-count detection and rollover.
4.  Compare synchronous and asynchronous reset behavior.
5.  Understand counter hierarchy and next-state logic.
6.  Review standard-cell technology mapping.
7.  Interpret synthesized area and cell-category distribution.
8.  Interpret register, logic, clock, internal, switching, and leakage
    power.
9.  Read a setup-timing path and interpret reported slack.
10. Identify which conclusions are supported by the available reports
    and which require additional evidence.

------------------------------------------------------------------------

## 4. MOD-10 Counter Concept

A MOD-10 counter has ten valid count states:

``` text
0 → 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8 → 9
↑                                         |
└──────────────── rollover ──────────────┘
```

The next state after decimal 9 is decimal 0.

### State width

The required number of state bits is:

``` text
Number of states = 10

Required bits = ceil(log2(10)) = 4
```

Four bits can represent sixteen binary values, from `0000` through
`1111`. A MOD-10 counter uses ten of these values as its intended
counting sequence.

### Terminal count

``` text
Decimal 9 = 4'b1001
```

When the present count reaches 9, the next state should be 0.

------------------------------------------------------------------------

## 5. Functional Specification

### Intended count behavior

    Present count   Next count
  --------------- ------------
                0            1
                1            2
                2            3
                3            4
                4            5
                5            6
                6            7
                7            8
                8            9
                9            0

### Reset behavior

  -----------------------------------------------------------------------
  Reset type                          Intended behavior
  ----------------------------------- -----------------------------------
  Asynchronous reset                  Reset can clear the state
                                      independently of a clock edge.

  Synchronous reset                   Reset is sampled and takes effect
                                      at the active clock edge.
  -----------------------------------------------------------------------

The exact reset polarity, active clock edge, and RTL implementation
should be confirmed from the project source. The timing report includes
a signal named `reset_sync`, and the mapped path ends at an `RN` pin;
those names alone are not sufficient to establish the complete RTL reset
specification.

------------------------------------------------------------------------

## 6. Hardware Architecture

The top-level hierarchy contains two separate counter implementations:

``` text
mod10_counter_top
|
+-- ASYNC_COUNTER (mod10_counter_async)
|   |
|   +-- DFF0 (dff_async_reset)
|   +-- DFF1 (dff_async_reset_23)
|   +-- DFF2 (dff_async_reset_22)
|   +-- DFF3 (dff_async_reset_21)
|   +-- NEXT_LOGIC (mod10_next_state_10)
|
+-- SYNC_COUNTER (mod10_counter_sync)
    |
    +-- DFF0 (dff_sync_reset)
    +-- DFF1 (dff_sync_reset_26)
    +-- DFF2 (dff_sync_reset_25)
    +-- DFF3 (dff_sync_reset_24)
    +-- NEXT_LOGIC (mod10_next_state)
```

### Main hardware blocks

-   **Four state bits per counter:** store the current count.
-   **Next-state logic:** determines the count value to be stored on the
    next active clock edge.
-   **Terminal-count detection:** identifies the count value 9 so the
    sequence can wrap to 0.
-   **Reset logic:** initializes the counter according to its reset
    architecture.

The exact gate-level realization must be confirmed from the synthesized
netlist and RTL.

------------------------------------------------------------------------

## 7. Synchronous and Asynchronous Reset

### Asynchronous reset

An asynchronous reset can affect the stored state without waiting for a
clock edge, subject to the reset pin's electrical and timing
requirements.

### Synchronous reset

A synchronous reset is evaluated at the active clock edge. If reset is
active at that edge, the counter state is set to its reset value.

### Comparison

  -----------------------------------------------------------------------
  Feature                 Asynchronous reset      Synchronous reset
  ----------------------- ----------------------- -----------------------
  When reset takes effect Independent of active   At the active clock
                          clock edge              edge

  Reset implementation    Often uses a dedicated  May use data-path logic
                          asynchronous control    or a synchronous-reset
                          pin on the flip-flop    cell

  Reset timing checks     Recovery/removal checks Setup/hold timing may
                          may apply               apply to the
                                                  synchronous reset path

  Design consideration    Reset release and       Reset must meet its
                          recovery/removal must   sampling timing
                          be handled              requirements
  -----------------------------------------------------------------------

Neither architecture should be described as universally better. The
trade-off depends on library cells, timing constraints, reset
distribution, area, power, and system requirements.

------------------------------------------------------------------------

## 8. RTL and Testbench

The RTL and testbench source were not included with the supplied
reports. Add the actual source files to the repository and link them
here when available.

Recommended files:

``` text
rtl/
├── mod10_counter_async.v
├── mod10_counter_sync.v
└── mod10_counter_top.v

tb/
└── mod10_counter_tb.v
```

### Verification scenarios to run

1.  Assert reset before a clock edge.
2.  Deassert reset and check that counting starts from 0.
3.  Check the complete sequence from 0 to 9.
4.  Check rollover from 9 to 0.
5.  Assert asynchronous reset between clock edges and verify its
    response.
6.  Assert synchronous reset between clock edges and verify that state
    changes only at the active edge.
7.  Check repeated counting over several complete cycles.
8.  Check reset behavior at and near clock edges in simulation, avoiding
    race-prone testbench stimulus.
9.  Use a self-checking scoreboard or assertions to compare expected and
    observed values.

> **Verification status:** These are recommended tests, not claims that
> the tests have already passed. No RTL simulation transcript or
> waveform was supplied.

------------------------------------------------------------------------

## 9. Synthesis Flow

The supplied synthesis reports were generated by **Cadence Genus
21.14-s082_1**.

``` text
Verilog RTL
    ↓
Elaboration
    ↓
Logic synthesis and optimization
    ↓
Technology mapping to tsmc18 cells
    ↓
Hierarchy / cell / area reports
    ↓
Power and timing analysis reports
```

Reported setup information:

  Parameter                      Value
  ------------------------------ ---------------------------
  Top module                     `mod10_counter_top`
  Tool                           Genus 21.14-s082_1
  Report timestamp               Sep 30, 2026, 12:56:21 PM
  Operating condition            `slow (balanced_tree)`
  Wireload mode                  `enclosed`
  Area mode                      `timing library`
  Library shown in cell report   `tsmc18`

------------------------------------------------------------------------

## 10. Hierarchy Analysis

The hierarchy report shows:

-   One top-level module: `mod10_counter_top`.
-   One asynchronous counter instance: `ASYNC_COUNTER`.
-   One synchronous counter instance: `SYNC_COUNTER`.
-   Four DFF hierarchy instances under each counter.
-   One `NEXT_LOGIC` hierarchy instance under each counter.

This is consistent with two four-bit counter implementations in the same
top-level design.

The hierarchy report does not itself prove functional correctness or
timing closure.

------------------------------------------------------------------------

## 11. Standard-Cell Mapping

The supplied Genus cell report contains the following mapped instances:

  Standard cell     Instances   Reported area
  --------------- ----------- ---------------
  `AOI2BB2X1`               2          46.570
  `DFFRHQX1`                4         279.418
  `DFFTRX1`                 4         226.195
  `INVXL`                  12          79.834
  `NAND2X1`                 2          19.958
  `NAND3BX1`                2          33.264
  `NOR2BXL`                 2          26.611
  `NOR2X1`                  1           9.979
  `NOR2XL`                  1           9.979
  `NOR3XL`                  2          26.611
  `OAI21XL`                 2          26.611
  `OAI2BB1XL`               2          33.264
  `XOR2X1`                  2          53.222
  **Total**            **38**     **871.517**

The inventory shows eight flip-flop instances across the top-level
design. The exact assignment of each flip-flop cell type to the
synchronous or asynchronous counter should be confirmed from the mapped
netlist or cell-level hierarchy report.

------------------------------------------------------------------------

## 12. Area Analysis

### Reported results

``` text
Top module       = mod10_counter_top
Total instances  = 38
Total cell area  = 871.517
```

### Area by cell category

  Category           Instances          Area   Area percentage
  ---------------- ----------- ------------- -----------------
  Sequential                 8       505.613             58.0%
  Inverter                  12        79.834              9.2%
  Logic                     18       286.070             32.8%
  Physical cells             0         0.000              0.0%
  **Total**             **38**   **871.517**        **100.0%**

### Interpretation

-   Sequential cells account for 58.0% of the reported area.
-   Inverters account for 9.2%.
-   Other logic cells account for 32.8%.
-   The report lists no physical-cell instances.

The area unit is the library/report's area unit; do not label it as
square micrometres unless the library or tool setup confirms that unit.

### Comparison of the two counter hierarchies

The supplied hierarchy-area report gives:

  Module                     Instances      Area
  ------------------------ ----------- ---------
  `mod10_counter_top`               38   871.517
  `mod10_counter_async`             19   462.370
  `mod10_counter_sync`              19   409.147
  Async next-state logic            11   156.341
  Sync next-state logic             11   156.341

The asynchronous counter's reported area exceeds the synchronous
counter's reported area by:

``` text
462.370 − 409.147 = 53.223 area units
```

Relative to the synchronous implementation, this is approximately 13.0%
more area.

The next-state logic areas are reported as equal. The reported
difference is therefore associated with other parts of the mapped
hierarchy, but the precise cause should be confirmed by comparing the
cell-level mappings.

------------------------------------------------------------------------

## 13. Power Analysis

The supplied power report identifies:

``` text
Instance: /mod10_counter_top
Power Unit: W
PDB Frames: /stim#0/frame#0
```

### Total power

``` text
Total power = 6.91872e-05 W
            = 69.1872 µW
```

### Power by category

  ---------------------------------------------------------------------------------------------------
  Category             Leakage (W)      Internal (W)     Switching (W)         Total (W)        Row %
  -------------- ----------------- ----------------- ----------------- ----------------- ------------
  Register             1.50041e-08       5.30168e-05       2.58386e-06       5.56157e-05       80.38%

  Logic                1.13704e-08       5.23771e-06       2.02383e-06       7.27290e-06       10.51%

  Clock                          0                 0       6.29856e-06       6.29856e-06        9.10%

  Memory                         0                 0                 0                 0        0.00%

  Latch                          0                 0                 0                 0        0.00%

  Bbox                           0                 0                 0                 0        0.00%

  Pad                            0                 0                 0                 0        0.00%

  PM                             0                 0                 0                 0        0.00%

  **Subtotal**     **2.63745e-08**   **5.82545e-05**   **1.09062e-05**   **6.91872e-05**   **99.99%**
  ---------------------------------------------------------------------------------------------------

The category percentage totals differ from 100% by 0.01 percentage point
because of rounding.

### Power component percentages

  Component     Reported percentage
  ----------- ---------------------
  Leakage                     0.04%
  Internal                   84.20%
  Switching                  15.76%
  **Total**             **100.00%**

### Interpretation

-   Register power is the largest reported category at 80.38%.
-   Internal power is the largest power component at 84.20%.
-   Switching power is 15.76%.
-   Leakage power is 0.04%.

These values are for the reported top-level instance and PDB frame. They
do not provide a separate power comparison for the synchronous and
asynchronous counters. A meaningful architecture comparison requires
separate reports under equivalent constraints and activity assumptions.

------------------------------------------------------------------------

## 14. Timing Analysis

The supplied Genus report contains one setup check:

  Parameter           Reported value
  ------------------- ------------------------------
  Path status         `MET`
  Path type           Setup check
  Path group          `clk`
  Startpoint          `reset_sync`
  Endpoint            `SYNC_COUNTER/DFF3/q_reg/RN`
  Capture edge        10,000 ps
  Input delay         1,000 ps
  Setup value         413 ps
  Clock uncertainty   1,000 ps
  Data path delay     32 ps
  Required time       8,587 ps
  Reported slack      7,556 ps = 7.556 ns

### Reported path

``` text
reset_sync
    ↓
INVXL
    ↓
SYNC_COUNTER/DFF3/q_reg/RN  (DFFTRX1)
```

The report shows a reset-related path through an `INVXL` inverter to the
`RN` pin of a `DFFTRX1` cell.

### Interpretation

`MET` means the particular reported timing check meets its timing
requirement. The reported slack is positive.

Using the displayed rounded values:

``` text
Required time = 10,000 − 413 − 1,000 = 8,587 ps
Arrival time  = 1,000 + 32 = 1,032 ps
Calculated slack = 8,587 − 1,032 = 7,555 ps
```

Genus reports 7,556 ps. The 1 ps difference may result from internal
precision or rounding in the report.

### Timing limitation

This is a reset-related setup path, not an established
register-to-register critical path through the counter's next-state
logic. The supplied report does not establish:

-   Worst negative slack (WNS).
-   Total negative slack (TNS).
-   Maximum functional clock frequency.
-   Complete setup and hold closure.
-   Reset recovery/removal closure.
-   Post-route timing.

The clock period shown by the capture edge is 10 ns, but that alone does
not prove the design's maximum operating frequency.

------------------------------------------------------------------------

## 15. PPA Summary

  ------------------------------------------------------------------------
  Metric                                      Result Evidence limitation
  --------------------- ---------------------------- ---------------------
  Total cell instances                            38 Top-level synthesis
                                                     report

  Total cell area                            871.517 Area unit not
                                                     explicitly identified
                                                     in the supplied
                                                     report

  Sequential area                    505.613 (58.0%) Top-level
                                                     cell-category report

  Total reported power                    69.1872 µW Top-level PDB frame

  Reported setup slack                     +7.556 ns One reset-related
                                                     setup path

  Functional critical                Not established Overall timing
  path                                               summary not supplied

  Post-route PPA                        Not supplied No post-route report
                                                     supplied
  ------------------------------------------------------------------------

**Conclusion:** Synthesis area and top-level power are available. The
timing evidence is limited to one setup check, so complete timing
closure and overall PPA closure have not been established.

------------------------------------------------------------------------

## 16. Verification Plan and Coverage

Recommended checks before marking functional verification complete:

-   [ ] Reset initializes each counter to the intended state.
-   [ ] The count sequence advances from 0 through 9.
-   [ ] Count 9 rolls over to 0.
-   [ ] The asynchronous reset responds independently of a clock edge.
-   [ ] The synchronous reset responds at the active clock edge.
-   [ ] The two counters are checked independently.
-   [ ] Multiple complete count cycles are tested.
-   [ ] A self-checking testbench reports pass/fail.
-   [ ] Waveforms or simulation logs are committed to the repository.

No simulation evidence was included in the supplied reports; these
checks remain to be documented after execution.

------------------------------------------------------------------------

## 17. Optimization Opportunities

Potential areas to investigate after correctness and timing are
established:

1.  Compare the mapped flip-flop types and reset implementation in the
    two counters.
2.  Review whether reset polarity conversion introduces inverter cells.
3.  Inspect the mapped next-state logic and terminal-count detection.
4.  Compare separate area and power reports for each counter.
5.  Review the worst register-to-register path before making timing
    optimizations.
6.  Re-run synthesis after any RTL or constraint changes and compare
    results under identical conditions.

Every optimization should state the metric being improved and the
trade-off. The current reports do not prove that any optimization has
been performed.

------------------------------------------------------------------------

## 18. Limitations

-   RTL and testbench source were not included with the supplied report
    data.
-   No simulation waveform or self-checking test result was supplied.
-   The power report is top-level and frame-specific.
-   Only one reset-related setup-timing path was supplied.
-   No overall timing summary or register-to-register critical path was
    supplied.
-   No post-placement or post-route report was supplied.
-   No optimization results were supplied.
-   The precise area unit was not explicitly stated in the report.

------------------------------------------------------------------------

## 19. Repository Structure

Recommended GitHub layout:

``` text
day10-mod10-counter/
│
├── README.md
│
├── rtl/
│   ├── mod10_counter_async.v
│   ├── mod10_counter_sync.v
│   └── mod10_counter_top.v
│
├── tb/
│   └── mod10_counter_tb.v
│
├── sim/
│   ├── waveform/
│   └── simulation_results/
│
├── synthesis/
│   ├── reports/
│   │   ├── area.rpt
│   │   ├── hierarchy.rpt
│   │   ├── cell_mapping.rpt
│   │   ├── power.rpt
│   │   └── timing.rpt
│   └── netlist/
│
├── constraints/
│   └── constraints_top.sdc
│
├── images/
│   ├── counter_architecture.png
│   ├── simulation_waveform.png
│   ├── area_report.png
│   ├── power_report.png
│   └── timing_report.png
│
└── docs/
    └── Day10_MOD10_Counter_Report.pdf
```

Only add files that actually exist. Do not commit placeholder reports or
screenshots as if they were generated evidence.

------------------------------------------------------------------------

## 20. Industry Relevance

Counters are common building blocks in digital hardware. They are used
in:

-   Timers and event counters.
-   Clock dividers and control logic.
-   Digital control systems.
-   Address and sequence generation.
-   Protocol timing and baud-rate logic.
-   Finite-state control and datapath sequencing.
-   ASIC and FPGA designs.

Understanding reset architecture, counter rollover, standard-cell
mapping, and timing constraints is useful for RTL design and design
verification roles.

------------------------------------------------------------------------

## 21. GATE Relevance

Relevant Digital Logic topics include:

-   Sequential circuits and flip-flops.
-   Modulus and counter design.
-   Number of states and minimum state bits.
-   State-transition tables.
-   Synchronous versus asynchronous reset.
-   Setup time, clock period, and timing slack.
-   Combinational next-state logic.

Important relation:

``` text
Minimum number of state bits = ceil(log2(number of states))
```

For ten states:

``` text
ceil(log2(10)) = 4 bits
```

------------------------------------------------------------------------

## 22. Interview Questions

### Basic

1.  What does MOD-10 mean?
2.  Why does a MOD-10 counter require four bits?
3.  What is terminal-count detection?
4.  What happens after the counter reaches decimal 9?

### RTL and reset

5.  What is the difference between synchronous and asynchronous reset?
6.  How would you verify rollover from 9 to 0?
7.  Why are nonblocking assignments normally used for sequential RTL?
8.  What can happen if reset behavior is incorrectly coded?

### Synthesis and PPA

9.  What does technology mapping do?
10. Why can flip-flops account for a large fraction of counter area?
11. What are internal, switching, and leakage power?
12. What does a positive setup slack mean?
13. Why is a reset-pin timing path not necessarily the functional data
    critical path?
14. Why should two implementations be compared under the same
    constraints and activity assumptions?

### Hardware question

**What hardware does this RTL create?**

Explain the state register, next-state combinational logic,
terminal-count detection, and reset circuitry. Relate the explanation to
the actual RTL and mapped netlist rather than relying on module names
alone.

------------------------------------------------------------------------

## 23. Tiny Memory

-   A MOD-10 counter has ten intended states: 0 through 9.
-   Ten states require four state bits.
-   The terminal count is decimal 9 (`4'b1001`).
-   Asynchronous reset can act independently of a clock edge;
    synchronous reset acts at the active clock edge.
-   Positive slack means the specific analyzed timing check passed.
-   A single passing path does not prove full timing closure.
-   Simulation success, synthesis success, and timing closure are
    separate checks.

------------------------------------------------------------------------

## 24. Project Status

``` text
┌────────────────────────────────────────────────────┐
│                DAY 10 PROJECT STATUS               │
├────────────────────────────────────────────────────┤
│ Project specification       : DOCUMENTED           │
│ Hierarchy report             : AVAILABLE            │
│ Standard-cell mapping        : AVAILABLE            │
│ Area analysis                : AVAILABLE            │
│ Power analysis               : AVAILABLE            │
│ One setup-timing path        : AVAILABLE            │
│ Functional simulation        : EVIDENCE NOT SUPPLIED│
│ Self-checking verification   : EVIDENCE NOT SUPPLIED│
│ Overall timing closure       : NOT ESTABLISHED      │
│ Post-route PPA               : NOT SUPPLIED         │
│ Optimization                 : NOT DOCUMENTED       │
│ README documentation         : PREPARED             │
└────────────────────────────────────────────────────┘
```

------------------------------------------------------------------------

## 25. Final Day-10 Results

### Area

``` text
Total Instances = 38
Total Cell Area = 871.517
Sequential Area = 505.613
Sequential Area = 58.0%
```

### Power

``` text
Total Power = 69.1872 µW

Register = 55.6157 µW
Logic    =  7.27290 µW
Clock    =  6.29856 µW
```

### Timing

``` text
Reported Setup Slack = +7.556 ns
Status               = MET
Path                  = reset_sync → INVXL → DFFTRX1/RN
```

> **Timing qualification:** This result belongs to the supplied
> reset-related setup check. It does not establish the counter's
> functional register-to-register critical path, maximum functional
> frequency, or full timing closure.

### Hierarchy comparison

``` text
Asynchronous counter area = 462.370
Synchronous counter area  = 409.147
Reported area difference  =  53.223
```

The supplied hierarchy report shows approximately 13.0% more area for
the asynchronous implementation relative to the synchronous
implementation. Separate power and complete timing reports are required
before drawing an overall PPA conclusion.


---------------------------------------------------------------------------
# 46. Author

**Omkar Kalmesh Hadapad**

B.E. Electronics & Communication Engineering
SDM Institute of Technology, Ujire, Karnataka

**Focus Areas:**

```text
Digital VLSI
RTL Design
Verilog HDL
ASIC Design
Design Verification
Cadence Genus
Cadence Innovus
PPA Optimization
```

------------------------------------------------------------------------

## 26. Next Project --- Day 11

### Day 11 --- 4-bit Up/Down Counter

The next project extends counter design by adding a direction control.

``` text
Direction control
       ↓
Up-count / Down-count next-state logic
       ↓
4-bit register
       ↓
Reset behavior
       ↓
Verification of rollover and underflow
       ↓
Synthesis and PPA analysis
```

The Day-11 focus is to understand up-counting, down-counting, rollover,
underflow, reset behavior, and verification of both operating
directions.
