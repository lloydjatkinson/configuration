function Invoke-StandardSetup {
    powershell -Command "iwr -useb https://raw.githubusercontent.com/lloydjatkinson/configuration/master/windows/standard/Set-Configuration.ps1 | iex"
}

function Invoke-DevelopmentSetup {
    Invoke-StandardSetup
}