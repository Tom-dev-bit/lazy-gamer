# ============================================================
#  install.ps1 — Fresh Windows Setup Script
#  Run with: powershell -ExecutionPolicy Bypass -File install.ps1
# ============================================================

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
    winget install --id $Id --silent --accept-package-agreements --accept-source-agreements 2>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "  Skipped $Name (canceled or already installed)." -ForegroundColor DarkYellow
        # Kill any stuck winget or msiexec processes left by a canceled install
        Get-Process -Name "winget","msiexec" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    }
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
if (Ask "Do you torrent? (qBittorrent)") {
    Install-App -Name "qBittorrent" -Id "qBittorrent.qBittorrent"
}

# ── Optional: Blizzard 
if (Ask "Do you play Blizzard games? (Battle.net)") {
    Write-Host "`nNote: Battle.net may open a window asking you to choose an install directory." -ForegroundColor Yellow
    Install-App -Name "Battle.net" -Id "Blizzard.BattleNet"

    if (Ask "Do you play World of Warcraft? (CurseForge)") {
        Install-App -Name "CurseForge" -Id "Overwolf.CurseForge"
    }
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
