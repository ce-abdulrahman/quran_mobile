@echo off
title Quran Mobile Launcher
cls
echo ====================================================
echo          Quran App Launcher & Debugger
echo ====================================================
echo.
echo  [1] Run on Connected Mobile Device (Debug Mode)
echo  [2] Run on Chrome Web (HTML Renderer)
echo  [3] Clean and Refresh Project (flutter clean & pub get)
echo  [4] Exit
echo.
echo ====================================================
set /p opt="Select option (1-4): "

if "%opt%"=="1" (
    cls
    echo [INFO] Starting Flutter app in Debug mode...
    flutter run
) else if "%opt%"=="2" (
    cls
    echo [INFO] Starting Flutter app on Chrome...
    flutter run -d chrome --web-renderer html
) else if "%opt%"=="3" (
    cls
    echo [INFO] Cleaning Flutter project cache...
    call flutter clean
    echo [INFO] Fetching packages...
    call flutter pub get
    echo.
    echo Done! Press any key to return to menu.
    pause > nul
    %0
) else if "%opt%"=="4" (
    exit
) else (
    echo [ERROR] Invalid option. Returning to menu...
    timeout /t 2 > nul
    %0
)
