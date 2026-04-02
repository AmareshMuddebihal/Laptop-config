
# ===== PHASE 2 - APPLICATION INSTALL =====

Write-Host "===== Application Installation Started ====="

$basePath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$appPath = Join-Path $basePath "apps"

# -------- CHECK FILES EXIST --------
$zohoPath = Join-Path $appPath "DefaultRemoteOffice_Agent.exe"
$gcpwPath = Join-Path $appPath "gcpwstandaloneenterprise64 [ NEW ].exe"
$sentinelPath = Join-Path $appPath "SentinelOneInstaller_windows_64bit_v25_1_3_334.exe"

if (!(Test-Path $zohoPath)) { Write-Host "Zoho installer not found!" -ForegroundColor Red; pause; exit }
if (!(Test-Path $gcpwPath)) { Write-Host "GCPW installer not found!" -ForegroundColor Red; pause; exit }
if (!(Test-Path $sentinelPath)) { Write-Host "SentinelOne installer not found!" -ForegroundColor Red; pause; exit }

# -------- 1. ZOHO (MANUAL) --------
Write-Host ""
Write-Host "Installing Zoho Agent (Manual Step)"
Start-Process -FilePath $zohoPath

Read-Host "Complete Zoho setup (enter 4-digit code), then press ENTER"

# -------- 2. GCPW (AUTO) --------
Write-Host "Installing GCPW..."

Start-Process -FilePath $gcpwPath -ArgumentList "/silent /install" -Wait

Write-Host "GCPW Installed Successfully"

# -------- 3. SENTINELONE --------
$token = Read-Host "Enter SentinelOne Token"

if ([string]::IsNullOrWhiteSpace($token)) {
    Write-Host "Token cannot be empty!" -ForegroundColor Red
    pause
    exit
}

Write-Host "Installing SentinelOne..."

Start-Process -FilePath $sentinelPath `
    -ArgumentList "/SITE_TOKEN=$token /quiet" `
    -Wait

Write-Host "SentinelOne Installed Successfully"

# -------- DONE --------
Write-Host ""
Write-Host "All Applications Installed Successfully"
pause
