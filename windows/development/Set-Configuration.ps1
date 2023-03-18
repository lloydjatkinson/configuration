function Invoke-StandardSetup {
    Write-Host "🛠️ Applying standard setup first" -ForegroundColor Green
    Invoke-WebRequest -useb https://raw.githubusercontent.com/lloydjatkinson/configuration/master/windows/standard/Set-Configuration.ps1 | Invoke-Expression
}

function Invoke-DevelopmentSetup {
    Invoke-StandardSetup
}

Invoke-DevelopmentSetup