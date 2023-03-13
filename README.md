# configuration
Scripts for automation, machine setup, environment configuration, etc.

## Windows
The standard configuration acts as the base for any further configuration, this is for a generic general purpose Windows machine. The development setup is based on the standard configuration, but adds additional setup for development.

The setup has some goals and non-goals (which I may work on in the future):

* ✋ Does **not** create Windows images, deploy Windows images, answer files, make use of MDT or SCCM or other standard IT tools. These require more work and investment and are great tools but not what I'm aiming to use for my personal machines (or family and friends machines).
* ✋ Does **not** automate the very initial install of Windows OOBE (the setup process where the serial number is entered, the language is selected, etc).
* ✋ Does **not** sign in to various accounts for applications or sites
* ✋ Does **not** install drivers (different machines are going to have different drivers, and hopefully Windows Update can install most if not all of them - for now this will be a manual step unless I see the same set of drivers and machines in which case another step could be created)
* ✋ Does **not** setup network connections and WiFi

---

* ✔️ Run immediately after the initial install of Windows
* ✔️ Run solely from Windows Terminal (Elevated as Administrator)
* ✔️ The setup should be initiated from a **single command** such as `Invoke-WebRequest <url here>/setup.ps1 | Invoke-Expression`
`
* ✔️ Have little or no user interaction (no prompts, no questions, no input)
* ✔️ Should be idempotent (can be run multiple times without breaking anything)
* ✔️ Uses PowerShell as much as possible (no `.bat`, `.cmd` files)
* ✔️ Uses PowerShell DSC (Desired State Configuration) as much as possible (but only if this does not break the "single command" requirement), for:
* ✔️ Installs and enables Windows Features, Windows Update, etc
* ✔️ Automates and installs all software by using WinGet (Windows Package Manager)
* ✔️ Restarts the machine once the entire process is completed

---

* ❓ If possible, automate any required restarts **and user logins** and continue the process after the restart, possibly by using SysInternals AutoLogon and a temporary scheduled task to continue the script, all of which would be cleaned up after the process is completed. This would require the script to be able to track it's progress and continue from where it left off.


### /windows/standard
Scripts and configuration for setting up a new Windows machine

* Chrome
* VLC
* Spotify
* Discord
* WhatsApp
* Steam
* Paint.NET
* Microsoft Office
* Microsoft PowerToys
* Gyazo
* OBS Studio
* Monitorian for monitor brightness control (Windows on desktop generally doesn't have this even if the monitor supports it)
* Ensure file extensions are shown in Explorer
* Enable inbound Remote Desktop connections

### /windows-development-setup
Scripts and configuration for setting up a new Windows machine for development (based on standard, but with additional setup)

* Latest Powershell (not the version that comes with Windows)
* Hyper-V and related virtualisation Windows Features
* WSL2
* Docker
* Visual Studio (use WinGet's --override to provide selected workloads)
* .NET 7 and .NET 7 SDKs (installed via Visual Studio)
* Visual Studio Code
* NVM for Windows (latest non-LTS version of Node and NPM)
* Tailscale mesh VPN

