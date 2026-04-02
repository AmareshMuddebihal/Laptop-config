# ===== PHASE 2 =====

# LOG
$log = "C:\setup_log.txt"
function Write-Log {
    param ([string]$msg)
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$time - $msg" | Out-File -FilePath $log -Append
}

Write-Log "===== Phase 2 Started ====="

# Get base path
$basePath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\NaviSetup").BasePath
$appPath = "$basePath\apps"

# -------- 1. CREATE D DRIVE --------
Write-Log "Creating D drive"

if (!(Get-PSDrive -Name D -ErrorAction SilentlyContinue)) {
    $disk = Get-Disk | Where-Object PartitionStyle -Eq 'GPT' | Select-Object -First 1
    $partition = New-Partition -DiskNumber $disk.Number -Size 322GB -DriveLetter D
    Format-Volume -Partition $partition -FileSystem NTFS -Confirm:$false
}

# -------- 2. CREATE REQUIRED FOLDERS --------
Write-Log "Creating user folders"

New-Item -ItemType Directory -Path "D:\Users" -Force
New-Item -ItemType Directory -Path "D:\Users\Default" -Force
New-Item -ItemType Directory -Path "D:\Users\Public" -Force

# Copy default + public
robocopy "C:\Users\Default" "D:\Users\Default" /E /COPYALL
robocopy "C:\Users\Public" "D:\Users\Public" /E /COPYALL

# -------- 3. COPY CURRENT USER DATA --------
$currentUser = $env:USERNAME
Write-Log "Copying user data"

robocopy "C:\Users\$currentUser" "D:\Users_Backup\$currentUser" /E /COPYALL /R:2 /W:2

# -------- 4. INSTALL APPLICATIONS --------

# Zoho (manual step)
Write-Log "Installing Zoho Agent"
Start-Process "$appPath\DefaultRemoteOffice_Agent.exe"
Read-Host "Complete Zoho setup (enter 4-digit code), then press ENTER"

# GCPW
Write-Log "Installing GCPW"
Start-Process "$appPath\gcpwstandaloneenterprise64 [ NEW ].exe" -ArgumentList "/silent /install" -Wait

# SentinelOne
Write-Log "Installing SentinelOne"
$token = Read-Host "Enter SentinelOne Token"

Start-Process "$appPath\SentinelOneInstaller_windows_64bit_v25_1_3_334.exe" `
 -ArgumentList "/SITE_TOKEN=$token /quiet" `
 -Wait

# -------- 5. REGISTRY (ONLY 3 VALUES) --------
Write-Log "Applying registry changes"

$profilePath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"

Set-ItemProperty -Path $profilePath -Name "Default" -Value "D:\Users\Default"
Set-ItemProperty -Path $profilePath -Name "ProfilesDirectory" -Value "D:\Users"
Set-ItemProperty -Path $profilePath -Name "Public" -Value "D:\Users\Public"

# GCPW domain restriction
New-Item -Path "HKLM:\SOFTWARE\Google\GCPW" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Google\GCPW" `
 -Name "domains_allowed_to_login" `
 -Value "navi.com"

Write-Log "Setup Completed"

# Cleanup
Unregister-ScheduledTask -TaskName "NaviSetup" -Confirm:$false
Remove-ItemProperty -Path "HKLM:\SOFTWARE\NaviSetup" -Name "BasePath" -ErrorAction SilentlyContinue

Write-Log "===== DONE ====="
