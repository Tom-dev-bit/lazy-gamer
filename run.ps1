# ============================================================
#  run.ps1 - lazy-gamer Setup Menu
# ============================================================

# Ensure running as Administrator
$currentPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator."
    pause
    exit 1
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

while ($true) {
    Write-Host ""
    Write-Host "  ============================================" -ForegroundColor Cyan
    Write-Host "   lazy-gamer - Windows Setup Script" -ForegroundColor Cyan
    Write-Host "  ============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Choose your installation method:"
    Write-Host ""
    Write-Host "  [1] Chocolatey  " -NoNewline; Write-Host "(recommended)" -ForegroundColor Green
    Write-Host "  [2] winget      " -NoNewline; Write-Host "(NOTE: cancelling an installer mid-way may break subsequent installs)" -ForegroundColor Yellow
    Write-Host ""

    $choice = Read-Host "  Enter 1 or 2"

    if ($choice -eq "1") {
        & "$scriptDir\install-choco.ps1"
        break
    } elseif ($choice -eq "2") {
        & "$scriptDir\install-winget.ps1"
        break
    } else {
        Write-Host ""
        Write-Host "  Invalid choice. Please enter 1 or 2." -ForegroundColor Red
    }
}
