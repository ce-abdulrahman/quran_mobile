@REM run_flutte.bat

@echo off
echo Starting Flutter on Windows Desktop...

@REM Run flutter app on Windows (supports dart:ffi / SQLite)
@REM To run on Android, connect your device and use: flutter run -d android
start /b cmd /c "flutter run -d edge"

echo Done.