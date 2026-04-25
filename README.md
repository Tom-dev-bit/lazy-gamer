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
3. Navigate to the **lazy-gamer** folder (should be at `C:\Users\yourusername\lazy-gamer`)
4. Double-click **`START.vbs`** and choose your installation method:
   - **[1] Chocolatey** — recommended, more reliable
   - **[2] winget** — built into Windows, no extra installs needed
5. Follow the prompts.

That's it.

---

## What is this?

A PowerShell script that installs all your essential Windows applications in one shot — no hunting down 20 websites, no clicking download buttons.

After a fresh Windows install, you clone this repo, run one file, answer a few yes/no questions, and everything is set up.

---

## Installation methods

### Chocolatey (recommended)
Uses [Chocolatey](https://chocolatey.org/) as the package manager. Bootstrapped automatically — no manual install needed. More reliable cancel handling: if you cancel an installer mid-way, the script skips cleanly and continues with the next app.

### winget
Uses the built-in Windows Package Manager. No extra software needed.
> ⚠️ **Note:** Cancelling an application's own installer window mid-way (e.g. Battle.net) may corrupt winget's process state and cause subsequent installs to fail with a "process has no package identity" error. If this happens, close the terminal and re-run `run.bat`.

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
- VS Code, Node.js, Windows Terminal, WSL2 — only if you're a developer
