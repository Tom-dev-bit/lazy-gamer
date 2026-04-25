# ============================================================
#  install-choco.ps1 — Fresh Windows Setup Script (Chocolatey)
#  Run with: powershell -ExecutionPolicy Bypass -File install-choco.ps1
# ============================================================

# Ensure running as Administrator
$currentPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator. Please re-run using START.vbs or an elevated PowerShell session."
    exit 1
}

# ── Bootstrap Chocolatey ─────────────────────────────────────

if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "`nInstalling Chocolatey..." -ForegroundColor Cyan
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    # Reload PATH so choco is available in the current session
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Error "Chocolatey installation failed. Please install it manually from https://chocolatey.org and re-run this script."
        exit 1
    }

    Write-Host "Chocolatey installed successfully." -ForegroundColor Green
} else {
    Write-Host "`nChocolatey is already installed, skipping bootstrap." -ForegroundColor DarkYellow
}

# ── Helpers ──────────────────────────────────────────────────

function Install-App {
    param (
        [string]$Name,
        [string]$Id
    )
    Write-Host "`nInstalling $Name..." -ForegroundColor Cyan
    choco install $Id -y --skip-if-already-installed
    $exitCode = $LASTEXITCODE

    if ($exitCode -eq 0) {
        # Success — choco already printed its own output
    } else {
        Write-Host "  $Name was skipped or failed (exit code $exitCode)." -ForegroundColor DarkYellow
        # Clean up any leftover processes from a cancelled installer
        Get-Process -Name "winget","msiexec","Battle.net","Agent","BlizzardError" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    }
}

function Ask {
    param([string]$Question)
    $answer = Read-Host "`n$Question (y/n)"
    return $answer -eq 'y' -or $answer -eq 'yes'
}

# ── Basic Apps (always installed) ────────────────────────────

# 🌐 Browser
Install-App -Name "Google Chrome"  -Id "googlechrome"

# 💬 Communication
Install-App -Name "Discord"        -Id "discord"

# 🎮 Gaming
Install-App -Name "Steam"          -Id "steam"

# 🎵 Media
Install-App -Name "VLC"            -Id "vlc"

# 🔧 Utilities
Install-App -Name "7-Zip"          -Id "7zip"

if (Ask "Do you torrent? (qBittorrent)") {
    Install-App -Name "qBittorrent" -Id "qbittorrent"
}

# ── Optional: Blizzard 
if (Ask "Do you play Blizzard games? (Battle.net)") {
    $bnetInstalled = Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Battle.net" -ErrorAction SilentlyContinue
    if ($bnetInstalled) {
        Write-Host "`n  Battle.net is already installed, skipping." -ForegroundColor DarkYellow
    } else {
        Write-Host "`nNote: Battle.net may open a window asking you to choose an install directory." -ForegroundColor Yellow
        Write-Host "`nDownloading Battle.net installer..." -ForegroundColor Cyan
        $bnetInstaller = "$env:TEMP\BattleNetSetup.exe"
        try {
            Invoke-WebRequest -Uri "https://www.battle.net/download/getInstallerForGame?os=win&locale=enUS&version=LIVE&gameProgram=BATTLENET_APP" -OutFile $bnetInstaller -UseBasicParsing
            Write-Host "Running Battle.net installer..." -ForegroundColor Cyan
            Start-Process -FilePath $bnetInstaller -Wait
        } catch {
            Write-Host "  Failed to download Battle.net installer. Please install it manually from https://www.battle.net" -ForegroundColor Red
        } finally {
            Remove-Item $bnetInstaller -ErrorAction SilentlyContinue
        }
    }
}

# ── Optional: Developer Tools 
if (Ask "Are you a developer?") {
    Install-App -Name "VS Code"           -Id "vscode"
    Install-App -Name "Node.js LTS"       -Id "nodejs-lts"
    Install-App -Name "Windows Terminal"  -Id "microsoft-windows-terminal"

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
