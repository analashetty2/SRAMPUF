@echo off
REM ============================================================================
REM Automated SRAM-PUF Simulation Script (Windows)
REM ============================================================================

echo ========================================
echo SRAM-PUF Automated Simulation
echo ========================================
echo.

REM Check if Vivado is in PATH
where vivado >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Vivado not found in PATH!
    echo.
    echo Please add Vivado to your PATH or modify this script
    echo to point to your Vivado installation.
    echo.
    pause
    exit /b 1
)

echo [INFO] Creating simulation TCL script...
echo.

REM Create TCL script for automated simulation
echo # Automated simulation script > run_sim.tcl
echo puts "========================================" >> run_sim.tcl
echo puts "Opening SRAM-PUF Project..." >> run_sim.tcl
echo puts "========================================" >> run_sim.tcl
echo open_project vivado_project/sram_puf_project.xpr >> run_sim.tcl
echo puts "" >> run_sim.tcl
echo puts "========================================" >> run_sim.tcl
echo puts "Launching Simulation..." >> run_sim.tcl
echo puts "========================================" >> run_sim.tcl
echo launch_simulation >> run_sim.tcl
echo puts "" >> run_sim.tcl
echo puts "========================================" >> run_sim.tcl
echo puts "Running Simulation..." >> run_sim.tcl
echo puts "========================================" >> run_sim.tcl
echo run all >> run_sim.tcl
echo puts "" >> run_sim.tcl
echo puts "========================================" >> run_sim.tcl
echo puts "Simulation Complete!" >> run_sim.tcl
echo puts "========================================" >> run_sim.tcl
echo exit >> run_sim.tcl

echo [INFO] Running Vivado simulation in batch mode...
echo.

REM Run Vivado in batch mode
vivado -mode batch -source run_sim.tcl

echo.
echo ========================================
echo Simulation Complete!
echo Check the output above for test results
echo ========================================
echo.
pause
