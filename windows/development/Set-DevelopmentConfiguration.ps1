#Requires -RunAsAdministrator

function Invoke-SoftwareInstallationWithWinGet {
    Write-Host "📁 Installing software via WinGet" -ForegroundColor Green

    # Accept stupid legal terms that break automation.
    echo Y | winget list | Out-Null
    
    winget install --id Microsoft.Powershell --source winget -e
    winget install --id=Docker.DockerDesktop -e
    winget install --id=Microsoft.VisualStudioCode -e
    winget install --id=Git.Git -e
    winget install --id=Axosoft.GitKraken -e
    winget install --id=CoreyButler.NVMforWindows -e
    winget install --id=PuTTY.PuTTY  -e
    winget install --id=tailscale.tailscale -e

    $vsConfigFilePath = "$([Environment]::GetFolderPath('MyDocuments'))\.vsconfig"
    Invoke-WebRequest -Uri "https://github.com/lloydjatkinson/configuration/raw/master/windows/development/.vsconfig" -OutFile $vsConfigFilePath
    winget install --id Microsoft.VisualStudio.2022.Community --override "--passive --config $vsConfigFilePath"
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