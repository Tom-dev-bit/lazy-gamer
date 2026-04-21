@echo off

:: Check if already running as Administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    powershell -ExecutionPolicy Bypass -File "%~dp0install.ps1"
    pause
) else (
    :: Re-launch this .bat as Administrator
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
)
