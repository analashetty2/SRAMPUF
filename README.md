# Advanced SRAM-PUF System

A comprehensive, synthesizable Verilog implementation of an SRAM-based Physically Unclonable Function (PUF) with realistic physical modeling and robust key extraction.

## Features

- **Realistic PUF Modeling**
  - Per-cell bias (manufacturing variation)
  - Per-read noise injection
  - Metastability detection
  - Temperature and voltage variation effects

- **Robust Key Extraction**
  - Fuzzy extractor with helper data
  - Hamming(7,4) error correction
  - BCH error correction (configurable)
  - SHA-256 key generation

- **FPGA Ready**
  - Synthesizable Verilog for Xilinx FPGAs
  - Vivado-compatible project structure
  - Configurable parameters
  - Comprehensive testbenches

## Directory Structure

```
.
├── rtl/                    # RTL source files
│   ├── sram_puf_params.vh  # Common parameters
│   ├── sram_puf_core.v     # SRAM PUF core
│   ├── hamming_codec.v     # Hamming(7,4) codec
│   ├── bch_codec.v         # BCH codec
│   ├── sha256_core.v       # SHA-256 hash
│   ├── key_gen.v           # Key generator
│   ├── fuzzy_extractor.v   # Fuzzy extractor
│   └── sram_puf_controller.v # Top-level controller
├── tb/                     # Testbenches
├── vivado/                 # Vivado project files
└── docs/                   # Documentation
```

## Quick Start

### Option 1: Automated Setup (Recommended)

1. **Open Vivado** (2019.1 or later)

2. **In Vivado TCL Console:**
   ```tcl
   cd /path/to/your/project
   source vivado/create_project.tcl
   ```

3. **Run Simulation:**
   ```tcl
   launch_simulation
   run all
   ```

4. **Check Output:**
   - Look for `[PASS] Keys match!` in console
   - Verify `error_flag` stays low
   - View waveforms for state transitions

### Option 2: Manual Vivado Setup

1. Create new RTL project in Vivado
2. Add all files from `rtl/` directory
3. Add testbench from `tb/` directory
4. Set `sram_puf_controller.v` as top module
5. Set `tb_sram_puf_top.v` as simulation top
6. Run behavioral simulation

### What You'll See

```
========================================
SRAM-PUF System Testbench
========================================

[TEST 1] Starting Enrollment...
[PASS] Enrollment completed successfully
  Helper Data: 7b2f007cc97fce72c19074e87e2b57e...
  Key Output:  6a09e667bb67ae853c6ef372a54ff53a...

[TEST 2] Starting Reconstruction...
[PASS] Reconstruction completed successfully
  Key Output: 6a09e667bb67ae853c6ef372a54ff53a...
[PASS] Keys match! PUF system working correctly.

========================================
Testbench Complete
========================================
```

### Next Steps

- ✅ **Simulation works?** → Proceed to synthesis
- ✅ **Synthesis works?** → Generate bitstream
- ✅ **Have FPGA board?** → Program and test on hardware

See **[QUICK_START.md](QUICK_START.md)** for 3-minute setup guide.
See **[USAGE_GUIDE.md](USAGE_GUIDE.md)** for complete documentation.

## Configuration

Key parameters can be configured in `rtl/sram_puf_params.vh`:

- `DEFAULT_PUF_SIZE` - Number of SRAM cells (128-4096)
- `DEFAULT_NOISE_PROB` - Noise probability (0-128 for 0-50%)
- `DEFAULT_ENROLL_CYCLES` - Power-up cycles during enrollment
- Error correction codec selection (Hamming or BCH)

## Usage

### Enrollment Phase

1. Assert `start_enroll`
2. Wait for `operation_done`
3. Read `helper_data_out` and store externally

### Reconstruction Phase

1. Provide stored `helper_data_in`
2. Assert `start_reconstruct`
3. Wait for `operation_done`
4. Read `key_out` (256-bit cryptographic key)

## Testing

Comprehensive test suite includes:
- Unit tests for each module
- Property-based tests for correctness properties
- Integration tests for full enrollment/reconstruction flow

Run all tests:
```bash
cd tb
./run_all_tests.sh
```

## Resource Usage

Estimated resource usage on Xilinx 7-Series FPGA:

| Configuration | LUTs | FFs | BRAM |
|--------------|------|-----|------|
| Hamming      | 3000 | 1600 | 0-1 |
| BCH          | 8000 | 3300 | 0-1 |

## License

See LICENSE file for details.

## References

- Fuzzy Extractor Theory: Dodis et al., "Fuzzy Extractors"
- SRAM PUF: Guajardo et al., "FPGA Intrinsic PUFs and Their Use for IP Protection"
- Error Correction: Lin & Costello, "Error Control Coding"
