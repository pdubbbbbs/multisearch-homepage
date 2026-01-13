# Update PowerShell 7 profile with blue theme
$ps7ProfileDir = "$env:USERPROFILE\Documents\PowerShell"
$ps7ProfilePath = Join-Path $ps7ProfileDir 'profile.ps1'

if (!(Test-Path $ps7ProfileDir)) {
    New-Item -ItemType Directory -Path $ps7ProfileDir -Force | Out-Null
}

$profileContent = @'
# MultiSearch Blue Theme for PowerShell
$Host.UI.RawUI.ForegroundColor = 'White'
$Host.UI.RawUI.BackgroundColor = 'Black'

# Set PSReadLine colors to blue theme
if (Get-Module -ListAvailable -Name PSReadLine) {
    Set-PSReadLineOption -Colors @{
        Command            = '#0081F2'
        Parameter          = '#FFFFFF'
        Operator           = '#0081F2'
        Variable           = '#38A3F8'
        String             = '#FFFFFF'
        Number             = '#38A3F8'
        Member             = '#FFFFFF'
        Default            = '#FFFFFF'
        Comment            = '#555560'
        Keyword            = '#0081F2'
        Type               = '#38A3F8'
        Error              = '#FF5555'
        Selection          = '#0081F2'
        Emphasis           = '#0081F2'
    }
}

# Custom prompt with blue accent
function prompt {
    Write-Host 'PS ' -NoNewline -ForegroundColor Blue
    Write-Host (Get-Location).Path -NoNewline -ForegroundColor White
    Write-Host ' >' -NoNewline -ForegroundColor Blue
    return ' '
}

# Blue welcome message
Write-Host ''
Write-Host '  MultiSearch Terminal' -ForegroundColor Blue
Write-Host ('  ' + (Get-Date -Format 'dddd, MMMM d, yyyy')) -ForegroundColor DarkGray
Write-Host ''
'@

Set-Content -Path $ps7ProfilePath -Value $profileContent -Force
Write-Host "PowerShell 7 profile updated at: $ps7ProfilePath"
