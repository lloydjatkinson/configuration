#Requires -RunAsAdministrator

function Invoke-SoftwareInstallationWithWinGet {
    Write-Host "📁 Installing software via WinGet" -ForegroundColor Green

    # Accept stupid legal terms that break automation.
    echo Y | winget list | Out-Null
    
    winget install --id Microsoft.Powershell --source winget
    
}

function Set-WindowsTerminalDefaultProfile {
    Write-Host "🖥️ Setting Windows Terminal default profile" -ForegroundColor Green
    # Despite this ID looking arbitrary and random, it is documented: https://learn.microsoft.com/en-us/windows/terminal/install#settings-json-file
    $jsonFilePath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    $jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json
    $jsonContent.defaultProfile = '{574e775e-4f2a-5b96-ac1e-a2962a402336}'
    $jsonContent | ConvertTo-Json -Depth 32 | Set-Content -Path $jsonFilePath
}

function Set-HyperVAndWsl {
    Write-Host "🖥️ Enabling Hyper-V, WSL, Sandbox, NFS" -ForegroundColor Green
    Enable-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableClientVM" -All -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName "HypervisorPlatform" -All -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform" -All -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V" -All -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName ServicesForNFS-ClientOnly, ClientForNFS-Infrastructure, NFS-Administration -NoRestart
    wsl --install
    wsl --set-default-version 2
}

function Invoke-DevelopmentSetup {
    try {
        Invoke-SoftwareInstallationWithWinGet
        Set-WindowsTerminalDefaultProfile
        Set-HyperVAndWsl

        (New-Object System.Media.SoundPlayer $(Get-ChildItem -Path "$env:windir\Media\Windows Logon.wav").FullName).Play()
        Write-Host "✅ Windows configured and software installed OK" -ForegroundColor Green
        Write-Host "⌛ Restarting in a few moments" -ForegroundColor Green

        Restart-Computer
    }
    catch {
        Write-Error "❌ Something went wrong!"
    }
}

Invoke-DevelopmentSetup