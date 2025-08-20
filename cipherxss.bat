@echo off
title Cipher-XSS Toolkit
color 0a

echo ========================================
echo       Launching Cipher-XSS Toolkit
echo ========================================
echo.

:: Check if Git Bash exists
if exist "C:\Program Files\Git\bin\bash.exe" (
    "C:\Program Files\Git\bin\bash.exe" cipherxss.sh
) else if exist "C:\Program Files\Git\usr\bin\bash.exe" (
    "C:\Program Files\Git\usr\bin\bash.exe" cipherxss.sh
) else (
    echo [!] Bash not found. Please install Git Bash or run this using WSL.
    pause
    exit /b
)

pause
