@echo off
setlocal

:: Check if AutoHotkey is installed
set "AHK_PATH="

:: Check PATH
where AutoHotkey64.exe >nul 2>&1
if %errorlevel%==0 (
    for /f "delims=" %%i in ('where AutoHotkey64.exe') do set "AHK_PATH=%%i"
    goto :found
)

:: Check common install paths
if exist "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" (
    set "AHK_PATH=C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"
    goto :found
)

if exist "%LOCALAPPDATA%\Programs\AutoHotkey\v2\AutoHotkey64.exe" (
    set "AHK_PATH=%LOCALAPPDATA%\Programs\AutoHotkey\v2\AutoHotkey64.exe"
    goto :found
)

:: Not installed - try winget
echo AutoHotkey not found. Installing via winget...
echo.

winget --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: winget not available.
    echo Please install AutoHotkey v2 manually from: https://www.autohotkey.com/
    pause
    exit /b 1
)

winget install AutoHotkey.AutoHotkey --accept-package-agreements --accept-source-agreements
if %errorlevel% neq 0 (
    echo ERROR: Installation failed.
    echo Please install AutoHotkey v2 manually from: https://www.autohotkey.com/
    pause
    exit /b 1
)

echo.
echo AutoHotkey installed successfully.
echo.

:: Re-check after installation
if exist "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" (
    set "AHK_PATH=C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"
    goto :found
)

if exist "%LOCALAPPDATA%\Programs\AutoHotkey\v2\AutoHotkey64.exe" (
    set "AHK_PATH=%LOCALAPPDATA%\Programs\AutoHotkey\v2\AutoHotkey64.exe"
    goto :found
)

:: Still not found, try running directly
set "AHK_PATH=AutoHotkey64.exe"

:found
:: Get script directory
set "SCRIPT_DIR=%~dp0"
set "AHK_SCRIPT=%SCRIPT_DIR%ClipboardImageSaver.ahk"

if not exist "%AHK_SCRIPT%" (
    echo ERROR: ClipboardImageSaver.ahk not found.
    pause
    exit /b 1
)

:: Run the script
echo Starting Clipboard Image Saver...
start "" "%AHK_SCRIPT%"

echo.
echo ============================================
echo  SUCCESS!
echo.
echo  Usage:
echo    1. Take a screenshot (Snipaste, etc.)
echo    2. Press Ctrl+Shift+V
echo    3. Path is copied to clipboard
echo    4. Paste path to Claude Code
echo.
echo  Images saved to: D:\ClaudeImages\
echo ============================================
echo.

timeout /t 3 >nul
