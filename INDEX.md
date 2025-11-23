# 📚 SRAM-PUF System - Documentation Index

## 🎯 Start Here

**New to this project?** → [HOW_TO_RUN.md](HOW_TO_RUN.md)

**Want quick setup?** → [QUICK_START.md](QUICK_START.md)

**Need full details?** → [USAGE_GUIDE.md](USAGE_GUIDE.md)

---

## 📖 Documentation Files

### Getting Started
1. **[HOW_TO_RUN.md](HOW_TO_RUN.md)** - Three ways to run the project
   - Automated scripts
   - Manual Vivado setup
   - GUI-only method

2. **[QUICK_START.md](QUICK_START.md)** - 3-minute setup guide
   - Minimal steps to get running
   - Key parameters
   - Common tasks
   - Quick fixes

3. **[README.md](README.md)** - Project overview
   - Features
   - Directory structure
   - Quick start
   - Configuration

### Detailed Guides
4. **[USAGE_GUIDE.md](USAGE_GUIDE.md)** - Complete usage documentation
   - Vivado setup (manual & automated)
   - Running simulation
   - Synthesis and implementation
   - Understanding output
   - Customization
   - Troubleshooting
   - Performance metrics

5. **[IMPLEMENTATION_COMPLETE.md](IMPLEMENTATION_COMPLETE.md)** - What's included
   - All implemented modules
   - Implementation statistics
   - File list
   - Verification checklist
   - Success criteria

### Technical Specifications
6. **[.kiro/specs/advanced-sram-puf/requirements.md](.kiro/specs/advanced-sram-puf/requirements.md)**
   - 12 major requirements
   - EARS-compliant acceptance criteria
   - Glossary of terms

7. **[.kiro/specs/advanced-sram-puf/design.md](.kiro/specs/advanced-sram-puf/design.md)**
   - Architecture overview
   - Component interfaces
   - Data models
   - 29 correctness properties
   - Error handling
   - Testing strategy

8. **[.kiro/specs/advanced-sram-puf/tasks.md](.kiro/specs/advanced-sram-puf/tasks.md)**
   - Implementation task list
   - 13 major tasks with subtasks
   - Property-based test requirements

---

## 🗂️ Source Code Files

### RTL Modules
- **[rtl/sram_puf_controller.v](rtl/sram_puf_controller.v)** - Top-level controller (USE THIS!)
- **[rtl/sram_puf_core.v](rtl/sram_puf_core.v)** - PUF core with bias/noise/metastability
- **[rtl/fuzzy_extractor.v](rtl/fuzzy_extractor.v)** - Enrollment & reconstruction
- **[rtl/hamming_codec.v](rtl/hamming_codec.v)** - Hamming(7,4) error correction
- **[rtl/bch_codec.v](rtl/bch_codec.v)** - BCH(15,7,2) error correction
- **[rtl/sha256_core.v](rtl/sha256_core.v)** - SHA-256 hash function
- **[rtl/key_gen.v](rtl/key_gen.v)** - Key generator wrapper
- **[rtl/sram_puf_params.vh](rtl/sram_puf_params.vh)** - System parameters

### Testbench
- **[tb/tb_sram_puf_top.v](tb/tb_sram_puf_top.v)** - Complete system testbench

### Vivado Files
- **[vivado/create_project.tcl](vivado/create_project.tcl)** - Project automation script
- **[vivado/constraints.xdc](vivado/constraints.xdc)** - Timing constraints

### Launch Scripts
- **[run_vivado.bat](run_vivado.bat)** - Windows quick launch
- **[run_vivado.sh](run_vivado.sh)** - Linux/Mac quick launch

---

## 🎓 Learning Path

### For Beginners
1. Read [README.md](README.md) - Understand what this is
2. Follow [HOW_TO_RUN.md](HOW_TO_RUN.md) - Get it running
3. Check [QUICK_START.md](QUICK_START.md) - Learn basic usage

### For Intermediate Users
1. Read [USAGE_GUIDE.md](USAGE_GUIDE.md) - Full documentation
2. Review [requirements.md](.kiro/specs/advanced-sram-puf/requirements.md) - Understand requirements
3. Study [design.md](.kiro/specs/advanced-sram-puf/design.md) - Understand architecture

### For Advanced Users
1. Review all RTL source code
2. Study correctness properties in design.md
3. Modify parameters for your application
4. Extend functionality as needed

---

## 🔍 Quick Reference

### I want to...

**...run the simulation**
→ [HOW_TO_RUN.md](HOW_TO_RUN.md) or [QUICK_START.md](QUICK_START.md)

**...understand how it works**
→ [design.md](.kiro/specs/advanced-sram-puf/design.md)

**...change parameters**
→ [USAGE_GUIDE.md](USAGE_GUIDE.md) → Customization section

**...fix an error**
→ [USAGE_GUIDE.md](USAGE_GUIDE.md) → Troubleshooting section

**...synthesize for FPGA**
→ [USAGE_GUIDE.md](USAGE_GUIDE.md) → Synthesis section

**...see what's implemented**
→ [IMPLEMENTATION_COMPLETE.md](IMPLEMENTATION_COMPLETE.md)

**...understand the requirements**
→ [requirements.md](.kiro/specs/advanced-sram-puf/requirements.md)

**...modify the code**
→ Start with [design.md](.kiro/specs/advanced-sram-puf/design.md), then RTL files

---

## 📊 File Organization

```
Documentation (You are here!)
├── INDEX.md                    ← Master index (this file)
├── HOW_TO_RUN.md              ← How to run (start here!)
├── QUICK_START.md             ← 3-minute guide
├── USAGE_GUIDE.md             ← Complete guide
├── IMPLEMENTATION_COMPLETE.md  ← What's included
└── README.md                  ← Project overview

Source Code
├── rtl/                       ← Verilog modules
├── tb/                        ← Testbenches
└── vivado/                    ← Vivado scripts

Specifications
└── .kiro/specs/advanced-sram-puf/
    ├── requirements.md        ← Requirements
    ├── design.md             ← Design document
    └── tasks.md              ← Task list
```

---

## ✅ Quick Checklist

### To Run Simulation
- [ ] Read [HOW_TO_RUN.md](HOW_TO_RUN.md)
- [ ] Open Vivado
- [ ] Run `source vivado/create_project.tcl`
- [ ] Run `launch_simulation`
- [ ] Run `run all`
- [ ] Check for `[PASS]` messages

### To Understand System
- [ ] Read [README.md](README.md)
- [ ] Read [design.md](.kiro/specs/advanced-sram-puf/design.md)
- [ ] Review RTL code
- [ ] Run simulation and view waveforms

### To Customize
- [ ] Read [USAGE_GUIDE.md](USAGE_GUIDE.md) Customization section
- [ ] Edit `rtl/sram_puf_params.vh`
- [ ] Modify module parameters
- [ ] Re-run simulation to verify

---

## 🎯 Recommended Reading Order

1. **[README.md](README.md)** - 5 minutes
2. **[HOW_TO_RUN.md](HOW_TO_RUN.md)** - 10 minutes
3. **Run the simulation** - 5 minutes
4. **[USAGE_GUIDE.md](USAGE_GUIDE.md)** - 30 minutes
5. **[design.md](.kiro/specs/advanced-sram-puf/design.md)** - 1 hour
6. **Review source code** - 2-3 hours

**Total time to full understanding: ~4-5 hours**

---

## 🆘 Need Help?

1. Check [USAGE_GUIDE.md](USAGE_GUIDE.md) Troubleshooting section
2. Review error messages in Vivado TCL console
3. Check waveforms in simulation
4. Verify all files are present
5. Make sure parameters are consistent

---

## 🎉 You're All Set!

**Everything you need is documented and ready to use!**

Start with [HOW_TO_RUN.md](HOW_TO_RUN.md) and you'll be running in minutes! 🚀
