Windows packaging instructions for E7POTA Logger

This file explains how to build the Windows release and create a setup.exe installer.

Requirements
- Flutter SDK (on PATH) and Visual Studio with "Desktop development with C++" workload.
- NSIS (makensis.exe) on PATH. Install with Chocolatey: `choco install nsis` or from https://nsis.sourceforge.io/Download

Quick steps
1) Open "x64 Native Tools Command Prompt for VS 2022" or a PowerShell with Visual Studio build environment enabled.
2) From the repository root run (in PowerShell):
   .\scripts\build-windows.ps1

What the script does
- Enables Windows desktop support in Flutter
- Runs `flutter pub get` and `flutter build windows --release`
- Stages the build output to build\windows\installer\release
- Runs makensis to produce build\windows\installer\setup-1.0.exe

After installer is produced
- Run the generated setup-1.0.exe as Administrator to install the app to Program Files and create a Desktop shortcut.

If something fails
- Make sure Visual Studio and Flutter can build Windows apps by running `flutter doctor` and resolving any issues.
- Ensure makensis.exe is on PATH. If using Chocolatey: `choco install nsis` (run PowerShell as Administrator).
