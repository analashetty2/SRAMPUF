# 🚀 SRAM-PUF Quick Start Guide

## ⚡ 3-Minute Setup

### 1. Open Vivado
```bash
vivado &
```

### 2. Create Project
In Vivado TCL Console:
```tcl
cd /path/to/your/sram-puf-project
source vivado/create_project.tcl
```

### 3. Run Simulation
```tcl
launch_simulation
run all
```

### 4. Check Results
Look for in TCL Console:
```
[PASS] Enrollment completed successfully
[PASS] Reconstruction completed successfully
[PASS] Keys match! PUF system working correctly.
```

---

## 📁 What You Have

```
rtl/
├── sram_puf_controller.v    ← Top module (use this!)
├── sram_puf_core.v           ← PUF with bias/noise
├── hamming_codec.v           ← Error correction
├── sha256_core.v             ← Key generation
└── ... (other modules)

tb/
└── tb_sram_puf_top.v         ← Testbench

vivado/
└── create_project.tcl        ← Auto-setup script
```

---

## 🎮 How to Use

### Enrollment (First Time)
```verilog
// 1. Assert start_enroll
start_enroll = 1;
#10 start_enroll = 0;

// 2. Wait for done
wait(operation_done == 1);

// 3. Save helper data
stored_helper = helper_data_out;  // IMPORTANT: Store this!
enrollment_key = key_out;         // Your 256-bit key
```

### Reconstruction (Every Time After)
```verilog
// 1. Provide stored helper data
helper_data_in = stored_helper;

// 2. Assert start_reconstruct
start_reconstruct = 1;
#10 start_reconstruct = 0;

// 3. Wait for done
wait(operation_done == 1);

// 4. Use the key
key = key_out;  // Same 256-bit key as enrollment!
```

---

## ⚙️ Key Parameters

Edit in `rtl/sram_puf_params.vh`:

```verilog
`define DEFAULT_PUF_SIZE 256        // Number of PUF cells
`define DEFAULT_NOISE_PROB 8'h0A    // ~4% noise
`define DEFAULT_ENROLL_CYCLES 10    // Power-ups during enrollment
`define DEFAULT_STABILITY_THRESH 8  // 8/10 must match
```

---

## 🔍 Signals to Monitor

| Signal | Description | When to Check |
|--------|-------------|---------------|
| `operation_done` | High when complete | Always |
| `error_flag` | High if error | Always |
| `key_out[255:0]` | Your crypto key | When done=1 |
| `helper_data_out` | Store this! | After enrollment |
| `state[3:0]` | FSM state | For debugging |

---

## 🎯 Common Tasks

### Change PUF Size
```verilog
sram_puf_controller #(
    .N(512)  // 512 cells instead of 256
) my_puf (...);
```

### Use BCH Instead of Hamming
```verilog
sram_puf_controller #(
    .USE_BCH(1)  // Better error correction
) my_puf (...);
```

### Adjust Noise
```verilog
// In sram_puf_params.vh
`define DEFAULT_NOISE_PROB 8'h14  // ~8% noise
```

---

## ✅ Success Checklist

Simulation:
- [ ] No errors in TCL console
- [ ] `[PASS] Keys match!` message appears
- [ ] `error_flag` stays low
- [ ] Waveforms show state transitions

Synthesis:
- [ ] Synthesis completes without errors
- [ ] Resource usage < 10,000 LUTs
- [ ] Timing constraints met

---

## 🐛 Quick Fixes

**Problem: error_flag = 1 during enrollment**
```verilog
// Solution: Increase PUF size
.N(512)  // or 1024
```

**Problem: Keys don't match**
```verilog
// Solution: Use BCH or reduce noise
.USE_BCH(1)
// or
`define DEFAULT_NOISE_PROB 8'h05
```

**Problem: Simulation too slow**
```verilog
// Solution: Reduce enrollment cycles for testing
.ENROLL_CYCLES(5)
```

---

## 📊 Expected Output

### Enrollment
```
Helper Data: 7b2f...a3b7  (448 bits)
Key Output:  6a09...cd19  (256 bits)
```

### Reconstruction
```
Key Output:  6a09...cd19  (same 256 bits!)
```

---

## 🎓 Understanding the Flow

```
ENROLLMENT:
PUF → Stability Analysis → Select Stable Cells → 
Generate Secret → Encode → Helper Data → Hash → Key

RECONSTRUCTION:
PUF → Apply Helper Data → Decode → Recover Secret → 
Hash → Same Key!
```

---

## 📞 Need Help?

1. Check `USAGE_GUIDE.md` for detailed instructions
2. Look at waveforms in simulation
3. Check TCL console for error messages
4. Verify all files are in correct directories

---

## 🚀 You're Ready!

```tcl
# In Vivado:
source vivado/create_project.tcl
launch_simulation
run all
```

**That's it! Your SRAM-PUF is running! 🎉**
