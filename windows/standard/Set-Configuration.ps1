function Set-Taskbar {
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
}

function Set-ShowFileExtensions {
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt' -Value 0
}