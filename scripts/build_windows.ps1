# ============================================================
# Monito Desktop
# Build Script for Windows
#
# Developed by Droidand
# ============================================================

$ScriptDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Resolve-Path (Join-Path $ScriptDir "..")
$BuildDir    = Join-Path $ProjectRoot "build"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "     Monito Desktop Build (Windows)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Project : $ProjectRoot"
Write-Host "Build   : $BuildDir"
Write-Host ""

# ------------------------------------------------------------
# Check dependencies
# ------------------------------------------------------------

if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
    Write-Host "CMake is not installed." -ForegroundColor Red
    exit 1
}

$Generator = ""

if (Get-Command ninja -ErrorAction SilentlyContinue) {
    $Generator = "-G Ninja"
}
else {
    Write-Host "Ninja not found. Using default generator." -ForegroundColor Yellow
}

if (!(Test-Path $BuildDir)) {
    New-Item -ItemType Directory -Force -Path $BuildDir | Out-Null
}

Write-Host ""
Write-Host "[1/3] Configuring..." -ForegroundColor Yellow

cmake `
    -S $ProjectRoot `
    -B $BuildDir `
    $Generator `
    -DCMAKE_BUILD_TYPE=Release

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Configuration Failed!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[2/3] Building..." -ForegroundColor Yellow

$Start = Get-Date

cmake --build $BuildDir --parallel

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Build Failed!" -ForegroundColor Red
    exit 1
}

$Elapsed = (Get-Date) - $Start

Write-Host ""
Write-Host ("[3/3] Build completed in {0:N2}s" -f $Elapsed.TotalSeconds) -ForegroundColor Green

$Exe = Join-Path $BuildDir "MonitoDesktopApp.exe"

if (Test-Path $Exe) {
    Write-Host ""
    Write-Host "Launching..." -ForegroundColor Cyan
    & $Exe
}
else {
    Write-Host ""
    Write-Host "Executable not found:" -ForegroundColor Yellow
    Write-Host $Exe
}