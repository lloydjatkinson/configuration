#Requires -RunAsAdministrator

function Invoke-SoftwareInstallationWithWinGet {
    Write-Host "📁 Installing software via WinGet" -ForegroundColor Green

    # Accept stupid legal terms that break automation.
    echo Y | winget list | Out-Null
    
    winget install --id Microsoft.Powershell --source winget
    winget install --id=Google.Chrome -e
    winget install --id=Spotify.Spotify -e
    winget install --id=WhatsApp.WhatsApp -e
    winget install --id=VideoLAN.VLC  -e
    winget install --id=Valve.Steam -e 
    winget install --id=dotPDNLLC.paintdotnet -e
    winget install --id=Nota.Gyazo  -e
    winget install --id=OBSProject.OBSStudio -e
    winget install --id=qBittorrent.qBittorrent -e
    winget install --id=Obsidian.Obsidian -e
    winget install --id=Microsoft.PowerToys --source winget
    winget install --id=emoacht.Monitorian -e 
}

function Set-Taskbar {
    Write-Host "🛠️ Setting taskbar layout and items" -ForegroundColor Green

    $registryKeys = @(
        @{
            Path = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name = "TaskbarDa"
            Value = 0
        },
        @{
            Path = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name = "TaskbarMn"
            Value = 0
        },
        @{
            Path = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name = "TaskbarAl"
            Value = 0
        },
        @{
            Path = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search"
            Name = "SearchboxTaskbarMode"
            Value = 0
        }
    )

    foreach ($key in $registryKeys) {
        [Microsoft.Win32.Registry]::SetValue($key.Path, $key.Name, $key.Value)
    }

    Stop-Process -Name "explorer"
}

function Show-FileExtensions {
    Write-Host "🛠️ Showing file extensions" -ForegroundColor Green
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt' -Value 0
}

function Hide-OneDriveExplorerIcon {
    Write-Host "🛠️ Hiding OneDrive icon in Explorer navigation pane" -ForegroundColor Green
    [Microsoft.Win32.Registry]::SetValue("HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}", "System.IsPinnedToNameSpaceTree", 0)
}

function Hide-DesktopIcons {
    Write-Host "🛠️ Hiding desktop icons" -ForegroundColor Green
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideIcons' -Value 1
}

function Set-WindowsTerminalDefaultProfile {
    Write-Host "🖥️ Setting Windows Terminal default profile" -ForegroundColor Green
    # Despite this ID looking arbitrary and random, it is documented: https://learn.microsoft.com/en-us/windows/terminal/install#settings-json-file
    $jsonFilePath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    $jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json
    $jsonContent.defaultProfile = '{574e775e-4f2a-5b96-ac1e-a2962a402336}'
    $jsonContent | ConvertTo-Json -Depth 32 | Set-Content -Path $jsonFilePath
}

function Get-WindowsUpdates {
    Install-PackageProvider -Name NuGet -Force
    Install-Module PSWindowsUpdate -Force
    Import-Module PSWindowsUpdate
    Get-WindowsUpdate -AcceptAll -Install
}

function Invoke-Setup {
    try {
        Invoke-SoftwareInstallationWithWinGet
        Show-FileExtensions
        Hide-OneDriveExplorerIcon
        Set-Taskbar
        Set-WindowsTerminalDefaultProfile
        Get-WindowsUpdates

        (New-Object System.Media.SoundPlayer $(Get-ChildItem -Path "$env:windir\Media\Windows Logon.wav").FullName).Play()
        Write-Host "✅ Windows configured and software installed OK" -ForegroundColor Green
        Write-Host "⌛ Restarting in a few moments" -ForegroundColor Green

        Restart-Computer
    }
    catch {
        Write-Error "❌ Something went wrong!"
    }
}

Invoke-Setup