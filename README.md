# lazy-gamer

## How to Use

> **First time only:** Install Git manually, then clone this repo.

1. Open the **Start menu**, search for **Terminal** and open it
2. Run these commands:

```powershell
winget install Git.Git --silent --accept-package-agreements --accept-source-agreements
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
git clone https://github.com/Tom-dev-bit/lazy-gamer.git
You can close the terminal window.
```
3. Navigate to the "lazy-gamer" folder it should be at /Users/yourusername
4. Then double-click **`run.bat`** and follow the prompts.

That's it.

---

## What is this?

A PowerShell script that installs all your essential Windows applications in one shot — no hunting down 20 websites, no clicking download buttons.

After a fresh Windows install, you clone this repo, run one file, answer a few yes/no questions, and everything is set up.

---

## What gets installed

**Always installed:**
- Google Chrome
- Discord
- Steam
- VLC
- 7-Zip

**Asked during setup:**
- qBittorrent — only if you torrent
- Battle.net — only if you play Blizzard games ⚠️ may prompt you to choose an install directory manually
  - CurseForge — only if you play World of Warcraft
- VS Code, Node.js, Windows Terminal, WSL2 — only if you're a developer
