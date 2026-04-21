# ============================================================
#  install.ps1 — Fresh Windows Setup Script
#  Run with: powershell -ExecutionPolicy Bypass -File install.ps1
# ============================================================

# Ensure winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "winget is not available. Make sure you're on Windows 10/11 with App Installer installed."
    exit 1
}

# ── Helper
function Install-App {
    param (
        [string]$Name,
        [string]$Id
    )
    Write-Host "`nInstalling $Name..." -ForegroundColor Cyan
    winget install --id $Id --silent --accept-package-agreements --accept-source-agreements
}

# ── Apps 

# 🌐 Browser
Install-App -Name "Google Chrome" -Id "Google.Chrome"


# ─────────────────────────────────────────────────────────────
Write-Host "`nAll done! You may need to restart for some changes to take effect." -ForegroundColor Green
