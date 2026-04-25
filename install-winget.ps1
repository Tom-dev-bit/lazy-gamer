# ============================================================
#  install-winget.ps1 — Fresh Windows Setup Script (winget)
#  Run with: powershell -ExecutionPolicy Bypass -File install-winget.ps1
# ============================================================

# Ensure running as Administrator
$currentPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator. Please re-run using START.vbs or an elevated PowerShell session."
    exit 1
}

# Ensure winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "winget is not available. Make sure you're on Windows 10/11 with App Installer installed."
    exit 1
}

# ── Helpers ──────────────────────────────────────────────────

function Install-App {
    param (
        [string]$Name,
        [string]$Id
    )
    Write-Host "`nInstalling $Name..." -ForegroundColor Cyan
    $errFile = [System.IO.Path]::GetTempFileName()
    winget install --id $Id --silent --accept-package-agreements --accept-source-agreements 2>$errFile
    $exitCode = $LASTEXITCODE

    if ($exitCode -eq -1978335189) {
        Write-Host "  $Name is already installed, skipping." -ForegroundColor DarkYellow
    } elseif ($exitCode -ne 0) {
        Write-Host "  $Name was skipped." -ForegroundColor DarkYellow
        # Kill anything that could leave locks and corrupt subsequent winget calls
        Get-Process -Name "winget","msiexec","Battle.net","Agent","BlizzardError" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    }

    Remove-Item $errFile -ErrorAction SilentlyContinue
}

function Ask {
    param([string]$Question)
    $answer = Read-Host "`n$Question (y/n)"
    return $answer -eq 'y' -or $answer -eq 'yes'
}

# ── Basic Apps (always installed) ────────────────────────────

# 🌐 Browser
Install-App -Name "Google Chrome"  -Id "Google.Chrome"

# 💬 Communication
Install-App -Name "Discord"        -Id "Discord.Discord"

# 🎮 Gaming
Install-App -Name "Steam"          -Id "Valve.Steam"

# 🎵 Media
Install-App -Name "VLC"            -Id "VideoLAN.VLC"

# 🔧 Utilities
Install-App -Name "7-Zip"          -Id "7zip.7zip"

if (Ask "Do you torrent? (qBittorrent)") {
    Install-App -Name "qBittorrent" -Id "qBittorrent.qBittorrent"
}

# ── Optional: Blizzard 
if (Ask "Do you play Blizzard games? (Battle.net)") {
    Write-Host "`nNote: Battle.net may open a window asking you to choose an install directory." -ForegroundColor Yellow
    Install-App -Name "Battle.net" -Id "Blizzard.BattleNet"
}

# ── Optional: Developer Tools 
if (Ask "Are you a developer?") {
    Install-App -Name "VS Code"           -Id "Microsoft.VisualStudioCode"
    Install-App -Name "Node.js"           -Id "OpenJS.NodeJS.LTS"
    Install-App -Name "Windows Terminal"  -Id "Microsoft.WindowsTerminal"

    if (Ask "Do you want WSL2 (Linux shell inside Windows)?") {
        Write-Host "`nInstalling WSL2 (this may take a few minutes)..." -ForegroundColor Cyan
        wsl --install
        Write-Host "WSL2 installed. A restart will be required to complete setup." -ForegroundColor Yellow
    }
}

# ─────────────────────────────────────────────────────────────
Write-Host "`nAll done! You may need to restart for some changes to take effect." -ForegroundColor Green

$seconds = 5
for ($i = $seconds; $i -gt 0; $i--) {
    Write-Host "`r  This window will close in $i second(s)..." -NoNewline -ForegroundColor DarkGray
    Start-Sleep -Seconds 1
}
Write-Host ""
