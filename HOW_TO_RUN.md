# 🎯 How to Run Your SRAM-PUF System

## 🚀 Three Ways to Get Started

---

## Method 1: Automated Script (Easiest!)

### Windows
```cmd
run_vivado.bat
```

### Linux/Mac
```bash
chmod +x run_vivado.sh
./run_vivado.sh
```

Then in Vivado:
```tcl
launch_simulation
run all
```

---

## Method 2: Manual Vivado (Recommended)

### Step 1: Open Vivado
- Windows: Start Menu → Xilinx Design Tools → Vivado 2019.1
- Linux: `vivado &`

### Step 2: In Vivado TCL Console
```tcl
cd /path/to/your/sram-puf-project
source vivado/create_project.tcl
```

### Step 3: Run Simulation
```tcl
launch_simulation
run all
```

### Step 4: Check Results
Look for in TCL Console:
```
[PASS] Enrollment completed successfully
[PASS] Reconstruction completed successfully
[PASS] Keys match! PUF system working correctly.
```

---

## Method 3: GUI Only (No Scripts)

### Step 1: Create Project
1. File → Project → New
2. Project name: `sram_puf_project`
3. Project type: RTL Project
4. Part: xc7a35tcpg236-1 (or your FPGA)

### Step 2: Add Files
1. Add Design Sources:
   - Navigate to `rtl/` folder
   - Select all `.v` and `.vh` files
   - Click OK

2. Add Simulation Sources:
   - Navigate to `tb/` folder
   - Select `tb_sram_puf_top.v`
   - Click OK

3. Add Constraints:
   - Navigate to `vivado/` folder
   - Select `constraints.xdc`
   - Click OK

### Step 3: Set Top Modules
1. In Sources window:
   - Right-click `sram_puf_controller.v`
   - Select "Set as Top"

2. In Simulation Sources:
   - Right-click `tb_sram_puf_top.v`
   - Select "Set as Top"

### Step 4: Run Simulation
1. Flow Navigator → Simulation → Run Simulation → Run Behavioral Simulation
2. In simulation window, click "Run All" button
3. Check TCL console for results

---

## 📊 What You Should See

### Console Output
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

[TEST 3] Testing multiple reconstructions...
  Reconstruction Key: 6a09e667bb67ae853c6ef372a54ff53a...
  Reconstruction Key: 6a09e667bb67ae853c6ef372a54ff53a...
  Reconstruction Key: 6a09e667bb67ae853c6ef372a54ff53a...

========================================
Testbench Complete
========================================
```

### Waveform Signals to Check
- `state` - Should transition through FSM states
- `puf_response` - Should show PUF bits
- `operation_done` - Should go high when complete
- `error_flag` - Should stay low (no errors)
- `key_out` - Should show 256-bit key

---

## 🔧 After Simulation Works

### Run Synthesis
```tcl
launch_runs synth_1
wait_on_run synth_1
```

### Check Results
```tcl
open_run synth_1
report_utilization
report_timing_summary
```

### Expected Resource Usage (Artix-7)
- LUTs: 3,000-8,000
- FFs: 1,600-3,300
- BRAM: 0-1
- Clock: 100 MHz

---

## ❌ Troubleshooting

### Problem: "Vivado not found"
**Solution:**
- Windows: Add to PATH or use full path:
  ```cmd
  C:\Xilinx\Vivado\2019.1\bin\vivado.bat
  ```
- Linux: Source settings:
  ```bash
  source /opt/Xilinx/Vivado/2019.1/settings64.sh
  ```

### Problem: "File not found" errors
**Solution:**
- Make sure you're in the project root directory
- Check that all files exist in `rtl/`, `tb/`, and `vivado/` folders
- Use absolute paths if needed

### Problem: Simulation doesn't start
**Solution:**
1. Check TCL console for errors
2. Verify all files are added to project
3. Try: `update_compile_order -fileset sources_1`
4. Restart Vivado and try again

### Problem: error_flag is high
**Solution:**
- This means insufficient stable PUF cells
- Increase PUF size: Edit `sram_puf_params.vh`, change `DEFAULT_PUF_SIZE` to 512
- Or decrease stability threshold

### Problem: Keys don't match
**Solution:**
- Too much noise or insufficient error correction
- Try using BCH: In controller instantiation, set `USE_BCH(1)`
- Or reduce noise: Edit `DEFAULT_NOISE_PROB` to `8'h05`

---

## ✅ Success Checklist

Before you start:
- [ ] Vivado installed (2019.1 or later)
- [ ] All project files downloaded
- [ ] In correct directory

After simulation:
- [ ] No errors in TCL console
- [ ] See `[PASS]` messages
- [ ] `error_flag` stays low
- [ ] Keys match between enrollment and reconstruction

After synthesis:
- [ ] Synthesis completes without errors
- [ ] Resource usage reasonable
- [ ] Timing constraints met

---

## 📚 Additional Resources

- **Quick Start**: See `QUICK_START.md` for 3-minute guide
- **Full Guide**: See `USAGE_GUIDE.md` for complete documentation
- **Implementation**: See `IMPLEMENTATION_COMPLETE.md` for what's included
- **README**: See `README.md` for project overview

---

## 🎉 You're Ready!

Choose your method above and get started!

**Recommended for first-time users: Method 2 (Manual Vivado)**

Good luck! 🚀
