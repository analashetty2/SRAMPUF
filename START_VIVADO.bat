@echo off
echo ========================================
echo Starting SRAM-PUF Vivado Project
echo ========================================
echo.

REM Change to project directory
cd /d "%~dp0"

echo Current directory: %CD%
echo.

REM Create a temporary TCL script with proper path handling
echo # Auto-generated TCL script > temp_create.tcl
echo set project_path [file normalize "%CD%"] >> temp_create.tcl
echo cd $project_path >> temp_create.tcl
echo source [file join $project_path vivado create_project.tcl] >> temp_create.tcl

REM Check if Vivado is in PATH
where vivado >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo [OK] Vivado found in PATH
    echo.
    echo Starting Vivado...
    echo.
    vivado -mode gui -source temp_create.tcl
) else (
    echo [INFO] Vivado not in PATH, trying common installation paths...
    echo.
    
    if exist "C:\Xilinx\Vivado\2025.1\bin\vivado.bat" (
        echo [OK] Found Vivado 2025.1
        call "C:\Xilinx\Vivado\2025.1\bin\vivado.bat" -mode gui -source temp_create.tcl
    ) else if exist "C:\Xilinx\Vivado\2024.1\bin\vivado.bat" (
        echo [OK] Found Vivado 2024.1
        call "C:\Xilinx\Vivado\2024.1\bin\vivado.bat" -mode gui -source temp_create.tcl
    ) else if exist "C:\Xilinx\Vivado\2023.1\bin\vivado.bat" (
        echo [OK] Found Vivado 2023.1
        call "C:\Xilinx\Vivado\2023.1\bin\vivado.bat" -mode gui -source temp_create.tcl
    ) else if exist "C:\Xilinx\Vivado\2022.1\bin\vivado.bat" (
        echo [OK] Found Vivado 2022.1
        call "C:\Xilinx\Vivado\2022.1\bin\vivado.bat" -mode gui -source temp_create.tcl
    ) else if exist "C:\Xilinx\Vivado\2021.1\bin\vivado.bat" (
        echo [OK] Found Vivado 2021.1
        call "C:\Xilinx\Vivado\2021.1\bin\vivado.bat" -mode gui -source temp_create.tcl
    ) else if exist "C:\Xilinx\Vivado\2020.1\bin\vivado.bat" (
        echo [OK] Found Vivado 2020.1
        call "C:\Xilinx\Vivado\2020.1\bin\vivado.bat" -mode gui -source temp_create.tcl
    ) else if exist "C:\Xilinx\Vivado\2019.1\bin\vivado.bat" (
        echo [OK] Found Vivado 2019.1
        call "C:\Xilinx\Vivado\2019.1\bin\vivado.bat" -mode gui -source temp_create.tcl
    ) else (
        echo [ERROR] Vivado not found!
        echo.
        echo Please install Vivado or add it to your PATH
        echo.
        pause
        del temp_create.tcl
        exit /b 1
    )
)

echo.
echo ========================================
echo Vivado should be starting...
echo ========================================
