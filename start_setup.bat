@echo off
cd /d %~dp0
powershell -ExecutionPolicy Bypass -File setup_phase1.ps1
pause
