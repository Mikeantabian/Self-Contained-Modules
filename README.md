# Modules Overview

## 1. Binary_To_7Segment

- **Description:** Converts a binary input to control a 7-segment display for numeric output.
- **Features:** Uses lookup tables or combinational logic to map binary inputs to 7-segment display outputs.
- **Usage:** Suitable for displaying numeric values on a 7-segment display in digital systems.

## 2. Count_And_Toggle

- **Description:** Implements a counter that toggles an output signal when it reaches a specified limit.
- **Features:** Parameterized for flexibility in setting the count limit. Uses clock for synchronous counting.
- **Parameters:** `COUNT_LIMIT` specifies the maximum count before toggling the output.

## 3. Debounce_Filter

- **Description:** Implements a debounce filter for multiple input signals (e.g., buttons or switches).
- **Features:** Uses clock for synchronous debounce logic to filter out mechanical bounce.
- **Parameters:** `DEBOUNCE_LIMIT` sets the debounce period.

## 4. Demux

- **Description:** Implements a 4-to-1 multiplexer (Mux) that selects one of four inputs based on selection signals.
- **Features:** Uses combinational logic to select and output one of four input signals based on selection lines.

## 5. FIFO

- **Description:** Implements a First-In-First-Out (FIFO) memory using dual-port RAM for concurrent read and write operations.
- **Features:** Provides flags for full, empty, almost full, and almost empty conditions. Parameterized for width and depth.

## 6. LFSR

- **Description:** Implements a Linear Feedback Shift Register (LFSR) with configurable length.
- **Features:** Generates pseudo-random sequences using clocked feedback logic.

## 7. Mux

- **Description:** Implements a 4-to-1 multiplexer (Mux) that selects one of four inputs based on selection signals.
- **Features:** Uses case statements for selecting the appropriate input based on selection lines.

## 8. RAM

- **Description:** Implements a dual-port RAM module for synchronous read and write operations.
- **Features:** Parameterized for data width and depth. Provides separate clock domains for read and write operations.

## 9. ShiftRegister

- **Description:** Implements a shift register with configurable length.
- **Features:** Shifts input data on each clock cycle. Uses clocked sequential logic for shifting operations.
