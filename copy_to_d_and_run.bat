@echo off
echo Copying project to D drive...
xcopy "C:\Users\Melroy Quadros\puf" "D:\puf" /E /I /H /Y

echo.
echo Project copied to D:\puf
echo.
echo Now run these commands in Vivado TCL console:
echo.
echo close_project
echo cd "D:/puf"
echo source vivado/create_project.tcl
echo launch_simulation
echo run all
echo.
pause
