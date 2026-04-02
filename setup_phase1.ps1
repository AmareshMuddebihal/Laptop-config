# ===== PHASE 1 =====

# Get current folder
$basePath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$phase2 = "$basePath\setup_phase2.ps1"

# Ask for laptop number (1–9999)
do {
    $num = Read-Host "Enter Laptop Number (1–9999)"
} while (-not ($num -match "^\d{1,4}$" -and [int]$num -ge 1 -and [int]$num -le 9999))

# Format name
$formatted = "{0:D4}" -f [int]$num
$newName = "NT-IT-LT-$formatted"

Write-Host "Laptop Name: $newName"

$confirm = Read-Host "Proceed? (Y/N)"
if ($confirm -ne "Y") { exit }

# Save path for phase 2
New-Item -Path "HKLM:\SOFTWARE\NaviSetup" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\NaviSetup" -Name "BasePath" -Value $basePath

# Schedule Phase 2 after restart
$action = New-ScheduledTaskAction -Execute "powershell.exe" `
 -Argument "-ExecutionPolicy Bypass -File `"$phase2`""

$trigger = New-ScheduledTaskTrigger -AtLogOn

Register-ScheduledTask -TaskName "NaviSetup" `
 -Action $action `
 -Trigger $trigger `
 -RunLevel Highest `
 -Force

# Rename + Restart
Rename-Computer -NewName $newName -Force
Restart-Computer -Force
