@echo off
cd /d "%~dp0"
echo Running Laptop Setup...

powershell -NoProfile -ExecutionPolicy Bypass -File "setup_phase1.ps1"

echo.
echo If nothing happened, check errors above.
pause
