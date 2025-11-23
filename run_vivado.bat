@echo off
REM ============================================================================
REM Quick Launch Script for SRAM-PUF Vivado Project (Windows)
REM ============================================================================

echo ========================================
echo SRAM-PUF Vivado Quick Launch
echo ========================================
echo.

REM Check if Vivado is in PATH
where vivado >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Vivado not found in PATH!
    echo.
    echo Please add Vivado to your PATH or run:
    echo   C:\Xilinx\Vivado\2019.1\bin\vivado.bat
    echo.
    pause
    exit /b 1
)

echo [INFO] Launching Vivado...
echo.

REM Launch Vivado with TCL script
vivado -mode tcl -source vivado/create_project.tcl

echo.
echo ========================================
echo Project created!
echo.
echo Next steps:
echo 1. In Vivado TCL console, type: launch_simulation
echo 2. Then type: run all
echo 3. Check for [PASS] messages
echo ========================================
pause
