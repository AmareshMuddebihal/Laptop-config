@echo off
cd /d "%~dp0"
echo Running Laptop Setup...

powershell -NoProfile -ExecutionPolicy Bypass -File "Registry-edit.ps1"

echo.
echo Setup completed.

:: Self-delete this BAT file
start "" cmd /c "timeout /t 2 /nobreak >nul & del /f /q "%~f0""

exit