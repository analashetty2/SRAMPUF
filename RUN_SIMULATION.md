# SRAM-PUF Simulation Commands

## Quick Start - Run Simulation

### Option 1: Using Batch Script (Windows)
```cmd
cd D:\puf
run_vivado.bat
```

### Option 2: Using Vivado GUI
```cmd
cd D:\puf
vivado -source vivado/create_project.tcl
```

Then in Vivado TCL Console:
```tcl
launch_simulation
run all
```

### Option 3: Manual Vivado Commands
```cmd
cd D:\puf
vivado
```

Then in Vivado TCL Console:
```tcl
# Open the project
open_project D:/puf/vivado_project/sram_puf_project.xpr

# Launch simulation
launch_simulation

# Run the simulation
run all
```

---

## Complete Step-by-Step Commands

### Step 1: Navigate to Project Directory
```cmd
cd D:\puf
```

### Step 2: Start Vivado
```cmd
vivado
```

### Step 3: In Vivado TCL Console
```tcl
# Open project
open_project D:/puf/vivado_project/sram_puf_project.xpr

# Launch simulation
launch_simulation

# Run simulation to completion
run all
```

---

## Expected Output

When you run the simulation, you should see:

```
========================================
SRAM-PUF System Testbench
========================================
[INFO] Reset complete, starting tests...

[TEST 1] Starting Enrollment...
[INFO] Enrollment operation_done asserted after 2738 cycles
[PASS] Enrollment completed successfully
Helper Data: 000000000000000000000000000000000000000000000000000000000000000000000000000000001eba01a776c5a7e1fd2f15f3c80ff555
Key Output:  41128e238cf40ed4ed9a4a3f6ed13a725c8281b8e1c22b6e9323e6e0f2a2aca8

[TEST 2] Starting Reconstruction...
[INFO] Reconstruction operation_done asserted after 271 cycles
[PASS] Reconstruction completed successfully
Key Output: 41128e238cf40ed4ed9a4a3f6ed13a725c8281b8e1c22b6e9323e6e0f2a2aca8

[TEST 3] Testing multiple reconstructions...
Reconstruction Key: 41128e238cf40ed4ed9a4a3f6ed13a725c8281b8e1c22b6e9323e6e0f2a2aca8
Reconstruction Key: 41128e238cf40ed4ed9a4a3f6ed13a725c8281b8e1c22b6e9323e6e0f2a2aca8
Reconstruction Key: 41128e238cf40ed4ed9a4a3f6ed13a725c8281b8e1c22b6e9323e6e0f2a2aca8

========================================
Testbench Complete
========================================

[PASS] Keys match! PUF system working correctly.

$finish called at time : 39060 ns : File "D:/puf/tb/tb_sram_puf_top.v" Line 194
```

---

## Alternative: Command Line Simulation (No GUI)

### Using xsim directly
```cmd
cd D:\puf\vivado_project\sram_puf_project.sim\sim_1\behav\xsim

# Compile
xvlog --incr --relax -prj tb_sram_puf_top_vlog.prj

# Elaborate
xelab --incr --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_sram_puf_top_behav xil_defaultlib.tb_sram_puf_top xil_defaultlib.glbl

# Run simulation
xsim tb_sram_puf_top_behav -tclbatch tb_sram_puf_top.tcl
```

---

## Troubleshooting

### If project doesn't exist:
```tcl
# Create new project
cd D:/puf
source vivado/create_project.tcl
```

### If simulation fails to launch:
```tcl
# Reset simulation
reset_run sim_1
launch_simulation
run all
```

### To view waveforms:
```tcl
# After launching simulation
add_wave /*
run all
```

---

## Project Structure

```
D:/puf/
├── rtl/                          # RTL source files
│   ├── sram_puf_controller.v     # Top-level controller
│   ├── sram_puf_core.v           # PUF core
│   ├── fuzzy_extractor.v         # Error correction
│   ├── key_gen.v                 # Key generation
│   ├── sha256_core.v             # SHA-256 hash
│   ├── hamming_codec.v           # Hamming codec
│   ├── bch_codec.v               # BCH codec
│   └── sram_puf_params.vh        # Parameters
├── tb/                           # Testbench
│   └── tb_sram_puf_top.v         # Main testbench
├── vivado/                       # Vivado scripts
│   ├── create_project.tcl        # Project creation
│   └── constraints.xdc           # Constraints
└── vivado_project/               # Generated project files
    └── sram_puf_project.xpr      # Vivado project
```

---

## System Status

✅ **All RTL files cleaned** - Debug statements removed  
✅ **Simulation verified** - All tests passing  
✅ **Production ready** - System fully functional  

**Last Verified:** November 23, 2025  
**Vivado Version:** 2025.1.0
