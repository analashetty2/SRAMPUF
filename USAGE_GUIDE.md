# SRAM-PUF System - Complete Usage Guide

## 📋 Table of Contents
1. [Quick Start](#quick-start)
2. [Vivado Setup](#vivado-setup)
3. [Running Simulation](#running-simulation)
4. [Synthesis and Implementation](#synthesis-and-implementation)
5. [Understanding the Output](#understanding-the-output)
6. [Customization](#customization)
7. [Troubleshooting](#troubleshooting)

---

## 🚀 Quick Start

### Prerequisites
- Xilinx Vivado (2019.1 or later)
- Windows/Linux system
- Basic knowledge of Verilog and FPGAs

### File Structure
```
.
├── rtl/                          # RTL source files
│   ├── sram_puf_params.vh        # System parameters
│   ├── sram_puf_core.v           # PUF core with bias/noise
│   ├── hamming_codec.v           # Hamming(7,4) codec
│   ├── bch_codec.v               # BCH codec
│   ├── sha256_core.v             # SHA-256 hash
│   ├── key_gen.v                 # Key generator wrapper
│   ├── fuzzy_extractor.v         # Fuzzy extractor
│   └── sram_puf_controller.v     # Top-level controller
├── tb/                           # Testbenches
│   └── tb_sram_puf_top.v         # Main testbench
├── vivado/                       # Vivado scripts
│   └── create_project.tcl        # Project creation script
├── README.md                     # Project overview
└── USAGE_GUIDE.md               # This file
```

---

## 🔧 Vivado Setup

### Method 1: Using TCL Script (Recommended)

1. **Open Vivado**
   - Launch Vivado from Start Menu or command line

2. **Navigate to Project Directory**
   ```tcl
   cd /path/to/your/project
   ```

3. **Run Project Creation Script**
   ```tcl
   source vivado/create_project.tcl
   ```

4. **Project Created!**
   - The script will create a new Vivado project
   - All source files will be added automatically
   - Testbench will be configured

### Method 2: Manual Setup

1. **Create New Project**
   - File → Project → New
   - Project name: `sram_puf_project`
   - Project location: Choose your directory
   - Project type: RTL Project
   - Don't specify sources yet

2. **Select FPGA Part**
   - Part: `xc7a35tcpg236-1` (Artix-7)
   - Or choose your target FPGA

3. **Add Source Files**
   - Add Design Sources → Add Files
   - Navigate to `rtl/` folder
   - Select all `.v` and `.vh` files
   - Click OK

4. **Add Simulation Files**
   - Add Simulation Sources → Add Files
   - Navigate to `tb/` folder
   - Select `tb_sram_puf_top.v`
   - Click OK

5. **Set Top Module**
   - Right-click `sram_puf_controller.v` → Set as Top
   - In Simulation Sources, right-click `tb_sram_puf_top.v` → Set as Top

---

## 🎮 Running Simulation

### Step 1: Launch Simulation

**In Vivado GUI:**
- Flow Navigator → Simulation → Run Simulation → Run Behavioral Simulation

**In TCL Console:**
```tcl
launch_simulation
```

### Step 2: Run Simulation

**In Simulation Window:**
```tcl
run all
```

Or click the "Run All" button in the toolbar.

### Step 3: View Results

The testbench will output:
```
========================================
SRAM-PUF System Testbench
========================================

[TEST 1] Starting Enrollment...
[PASS] Enrollment completed successfully
  Helper Data: <hex_value>
  Key Output:  <hex_value>

[TEST 2] Starting Reconstruction...
[PASS] Reconstruction completed successfully
  Key Output: <hex_value>
[PASS] Keys match! PUF system working correctly.

[TEST 3] Testing multiple reconstructions...
  Reconstruction Key: <hex_value>
  Reconstruction Key: <hex_value>
  Reconstruction Key: <hex_value>

========================================
Testbench Complete
========================================
```

### Step 4: View Waveforms

1. Click on "Zoom Fit" to see entire simulation
2. Key signals to observe:
   - `state` - FSM state transitions
   - `puf_response` - PUF output bits
   - `key_out` - Final cryptographic key
   - `operation_done` - Completion signal
   - `error_flag` - Error indicator

---

## 🔨 Synthesis and Implementation

### Step 1: Run Synthesis

**In Vivado GUI:**
- Flow Navigator → Synthesis → Run Synthesis

**In TCL Console:**
```tcl
launch_runs synth_1
wait_on_run synth_1
```

### Step 2: View Synthesis Results

After synthesis completes:
```tcl
open_run synth_1
```

Check:
- **Utilization Report**: Flow Navigator → Synthesis → Open Synthesized Design → Report Utilization
- **Timing Report**: Report Timing Summary

Expected resource usage (Artix-7):
- LUTs: ~3000-8000 (depending on Hamming vs BCH)
- FFs: ~1600-3300
- BRAM: 0-1

### Step 3: Run Implementation

**In Vivado GUI:**
- Flow Navigator → Implementation → Run Implementation

**In TCL Console:**
```tcl
launch_runs impl_1
wait_on_run impl_1
```

### Step 4: Generate Bitstream

**In Vivado GUI:**
- Flow Navigator → Program and Debug → Generate Bitstream

**In TCL Console:**
```tcl
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
```

---

## 📊 Understanding the Output

### Enrollment Phase

**What happens:**
1. PUF powers up 10 times
2. System analyzes which cells are stable
3. Generates random secret from stable PUF bits
4. Encodes secret with error correction
5. Computes helper data = codeword ⊕ PUF_response
6. Hashes secret to produce 256-bit key

**Outputs:**
- `helper_data_out` - Store this! (448 bits for Hamming)
- `key_out` - Your cryptographic key (256 bits)
- `operation_done` - High when complete
- `error_flag` - High if insufficient stable cells

### Reconstruction Phase

**What happens:**
1. PUF powers up once (noisy response)
2. Computes noisy_codeword = noisy_response ⊕ helper_data
3. Decodes noisy_codeword to recover secret
4. Hashes secret to produce key

**Outputs:**
- `key_out` - Should match enrollment key! (256 bits)
- `operation_done` - High when complete
- `error_flag` - High if too many errors to correct

### Key Consistency

The same key should be produced across multiple reconstructions:
- ✅ **Perfect match** - System working correctly
- ⚠️ **Slight differences** - May need to adjust noise/stability parameters
- ❌ **Completely different** - Check error_flag, may need more stable cells

---

## ⚙️ Customization

### Changing PUF Size

Edit `rtl/sram_puf_params.vh`:
```verilog
`define DEFAULT_PUF_SIZE 512  // Change from 256 to 512
```

Or in controller instantiation:
```verilog
sram_puf_controller #(
    .N(512),  // 512 PUF cells
    ...
) dut (...);
```

### Changing Error Correction

**Use BCH instead of Hamming:**
```verilog
sram_puf_controller #(
    .USE_BCH(1),  // 1=BCH, 0=Hamming
    ...
) dut (...);
```

### Adjusting Noise Level

Edit `rtl/sram_puf_params.vh`:
```verilog
`define DEFAULT_NOISE_PROB 8'h14  // ~8% noise (20/256)
```

### Changing Stability Threshold

```verilog
sram_puf_controller #(
    .STABILITY_THRESHOLD(9),  // Require 9/10 consistent
    ...
) dut (...);
```

### Changing Secret Length

```verilog
sram_puf_controller #(
    .SECRET_BITS(256),  // 256-bit secret instead of 128
    .HELPER_BITS(896),  // Adjust helper data size accordingly
    ...
) dut (...);
```

---

## 🐛 Troubleshooting

### Issue: Simulation doesn't start

**Solution:**
1. Check that all files are added to project
2. Verify `sram_puf_params.vh` is included
3. Check TCL console for error messages
4. Try: `update_compile_order -fileset sources_1`

### Issue: "error_flag" is high during enrollment

**Cause:** Insufficient stable cells

**Solutions:**
1. Increase PUF size: `N=512` or `N=1024`
2. Decrease stability threshold: `STABILITY_THRESHOLD=7`
3. Increase enrollment cycles: `ENROLL_CYCLES=15`

### Issue: Keys don't match between enrollment and reconstruction

**Cause:** Too much noise or insufficient error correction

**Solutions:**
1. Reduce noise: `DEFAULT_NOISE_PROB=8'h05`
2. Use BCH instead of Hamming: `USE_BCH=1`
3. Increase stability threshold: `STABILITY_THRESHOLD=9`

### Issue: Synthesis fails

**Common causes:**
1. **Unsupported constructs**: Check for `$urandom` in synthesizable code
2. **Missing files**: Ensure all `.v` files are added
3. **Include path**: Make sure `.vh` files are found

**Solutions:**
```tcl
# Add include directory
set_property include_dirs {../rtl} [current_fileset]
```

### Issue: Timing violations

**Solutions:**
1. Add clock constraint:
   ```tcl
   create_clock -period 10.0 [get_ports clk]
   ```
2. Reduce clock frequency
3. Add pipeline stages in SHA-256 (advanced)

### Issue: Simulation takes too long

**Cause:** SHA-256 has 64 rounds

**Solutions:**
1. Reduce `ENROLL_CYCLES` to 5 for testing
2. Use smaller PUF size during development
3. Run shorter test sequences

---

## 📈 Performance Metrics

### Timing
- **Enrollment**: ~4000-5000 clock cycles
- **Reconstruction**: ~900-1000 clock cycles
- **Target Clock**: 100 MHz
- **Enrollment Time**: ~40-50 μs
- **Reconstruction Time**: ~9-10 μs

### Resource Usage (Xilinx Artix-7)

| Configuration | LUTs | FFs | BRAM | DSP |
|--------------|------|-----|------|-----|
| Hamming(7,4) | 3000 | 1600 | 0-1 | 0 |
| BCH(15,7,2)  | 8000 | 3300 | 0-1 | 0 |

### Security
- **Key Length**: 256 bits (SHA-256 output)
- **Secret Entropy**: 128 bits (configurable)
- **Error Correction**: 1-bit (Hamming) or 2-bit (BCH) per block

---

## 🎯 Next Steps

1. **Run the simulation** to verify functionality
2. **Synthesize** for your target FPGA
3. **Customize parameters** for your application
4. **Integrate** into your larger system
5. **Test on hardware** (if you have an FPGA board)

---

## 📞 Support

If you encounter issues:
1. Check the error messages in TCL console
2. Review the waveforms in simulation
3. Verify all parameters are consistent
4. Check that your Vivado version is compatible

---

## ✅ Checklist

Before running:
- [ ] Vivado installed and licensed
- [ ] All files present in correct directories
- [ ] Project created successfully
- [ ] Top modules set correctly

For simulation:
- [ ] Testbench runs without errors
- [ ] Keys match between enrollment and reconstruction
- [ ] No error_flag assertions
- [ ] Waveforms look reasonable

For synthesis:
- [ ] No synthesis errors or critical warnings
- [ ] Resource usage within FPGA limits
- [ ] Timing constraints met
- [ ] Bitstream generated successfully

---

**You're all set! Start with simulation and work your way up to hardware implementation. Good luck! 🚀**
