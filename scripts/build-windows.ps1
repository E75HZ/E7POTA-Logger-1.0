# PowerShell build and installer script for Windows

<#
Usage: run from PowerShell (run as Administrator for installation steps):
  cd <repo-root>
  .\scripts\build-windows.ps1

What this does:
- Ensures Flutter desktop for Windows is enabled
- Runs `flutter pub get` and builds a release binary
- Stages the release output into build\windows\installer\release
- Calls NSIS (makensis) to build setup-1.0.exe using the NSIS script in installer\

Requirements:
- Flutter (on PATH)
- NSIS (makensis.exe on PATH). Install via Chocolatey: `choco install nsis` or from https://nsis.sourceforge.io/Download
- Visual Studio with "Desktop development with C++" workload (for building Flutter Windows apps)
#>

param()

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
Write-Host "Repository root: $repoRoot"

Push-Location $repoRoot

Write-Host "Running flutter pub get..."
flutter pub get

Write-Host "Enabling Windows desktop support (if not already)..."
flutter config --enable-windows-desktop

Write-Host "Running flutter doctor (brief)..."
flutter doctor --no-pub

Write-Host "Building release for Windows..."
flutter build windows --release

$releaseDir = Join-Path $repoRoot "build\windows\runner\Release"
if (-not (Test-Path $releaseDir)) {
    Write-Error "Release folder not found: $releaseDir. Build failed?"
}

$installerStaging = Join-Path $repoRoot "build\windows\installer"
$stagingRelease = Join-Path $installerStaging "release"

if (Test-Path $installerStaging) {
    Write-Host "Cleaning existing staging folder: $installerStaging"
    Remove-Item -Recurse -Force $installerStaging
}

Write-Host "Creating staging folder: $stagingRelease"
New-Item -ItemType Directory -Force -Path $stagingRelease | Out-Null

Write-Host "Copying release files to staging..."
Copy-Item -Path (Join-Path $releaseDir "*") -Destination $stagingRelease -Recurse -Force

# Copy an icon if available (look for assets/icon icon.ico in repo) - optional
$possibleIcon = Join-Path $repoRoot "windows\runner\resources\app_icon.ico"
if (Test-Path $possibleIcon) {
    Copy-Item $possibleIcon -Destination $stagingRelease -Force
}

# Ensure NSIS is available
$makensis = Get-Command makensis.exe -ErrorAction SilentlyContinue
if (-not $makensis) {
    Write-Host "makensis.exe not found on PATH. Install NSIS (e.g., via Chocolatey: choco install nsis) and re-run this script."
    Pop-Location
    exit 1
}

# Build installer
$nsisScript = Join-Path $repoRoot "installer\e7pota_installer.nsi"
if (-not (Test-Path $nsisScript)) {
    Write-Error "NSIS script not found: $nsisScript"
}

Write-Host "Running makensis to build installer..."
# Run makensis with workdir set to installer staging so relative paths to 'release' work
Push-Location $installerStaging
& $makensis.Path $nsisScript
$makensisExit = $LASTEXITCODE
Pop-Location

if ($makensisExit -ne 0) {
    Write-Error "makensis failed with exit code $makensisExit"
}

$builtInstaller = Join-Path $installerStaging "setup-1.0.exe"
if (Test-Path $builtInstaller) {
    Write-Host "Installer created: $builtInstaller"
} else {
    Write-Error "Installer not found at expected path: $builtInstaller"
}

Pop-Location
