# ===== PHASE 3 - REGISTRY ONLY =====

# Log file
$log = "C:\setup_log_registry.txt"

function Write-Log {
    param ([string]$msg)
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$time - $msg" | Out-File -FilePath $log -Append
}

Write-Log "===== Phase 3 (Registry) Started ====="

# -------- 1. Modify ProfileList --------
$profilePath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"

Write-Log "Modifying ProfileList registry values..."

try {
    Set-ItemProperty -Path $profilePath -Name "Default" -Value "D:\Users\Default"
    Set-ItemProperty -Path $profilePath -Name "ProfilesDirectory" -Value "D:\Users"
    Set-ItemProperty -Path $profilePath -Name "Public" -Value "D:\Users\Public"

    Write-Log "ProfileList registry modified successfully"
}
catch {
    Write-Log "Error modifying ProfileList: $($_.Exception.Message)"
    Write-Host "Error modifying ProfileList registry." -ForegroundColor Red
    pause
    exit
}

# -------- 2. Modify GCPW Domain --------
$gcpwPath = "HKLM:\SOFTWARE\Google\GCPW"

Write-Log "Modifying GCPW registry..."

try {
    New-Item -Path $gcpwPath -Force | Out-Null
    Set-ItemProperty -Path $gcpwPath -Name "domains_allowed_to_login" -Value "navi.com"

    Write-Log "GCPW registry modified successfully"
}
catch {
    Write-Log "Error modifying GCPW registry: $($_.Exception.Message)"
    Write-Host "Error modifying GCPW registry." -ForegroundColor Red
    pause
    exit
}

Write-Log "===== Phase 3 Completed Successfully ====="

Write-Host ""
Write-Host "Registry modifications completed successfully!"
pause
