#!/bin/bash
# ============================================================================
# Quick Launch Script for SRAM-PUF Vivado Project (Linux/Mac)
# ============================================================================

echo "========================================"
echo "SRAM-PUF Vivado Quick Launch"
echo "========================================"
echo ""

# Check if Vivado is in PATH
if ! command -v vivado &> /dev/null; then
    echo "[ERROR] Vivado not found in PATH!"
    echo ""
    echo "Please add Vivado to your PATH or run:"
    echo "  source /opt/Xilinx/Vivado/2019.1/settings64.sh"
    echo ""
    exit 1
fi

echo "[INFO] Launching Vivado..."
echo ""

# Launch Vivado with TCL script
vivado -mode tcl -source vivado/create_project.tcl

echo ""
echo "========================================"
echo "Project created!"
echo ""
echo "Next steps:"
echo "1. In Vivado TCL console, type: launch_simulation"
echo "2. Then type: run all"
echo "3. Check for [PASS] messages"
echo "========================================"
