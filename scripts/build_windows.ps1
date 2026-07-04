$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$BuildDir = Join-Path $ProjectRoot "build"

Write-Host "== Monito Desktop Build ==" -ForegroundColor Cyan

if (!(Test-Path $BuildDir)) {
    New-Item -ItemType Directory $BuildDir | Out-Null
}

Write-Host "Configuring..." -ForegroundColor Yellow

cmake `
    -S $ProjectRoot `
    -B $BuildDir `
    -G Ninja

if ($LASTEXITCODE -ne 0) {
    Write-Host "Configuration Failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Building..." -ForegroundColor Yellow

$start = Get-Date

cmake --build $BuildDir -j

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build Failed!" -ForegroundColor Red
    exit 1
}

$elapsed = (Get-Date) - $start

Write-Host ("Build Success ({0:N2}s)" -f $elapsed.TotalSeconds) -ForegroundColor Green

$exe = Join-Path $BuildDir "MonitoDesktopApp.exe"

Write-Host "Launching..." -ForegroundColor Cyan

& $exe