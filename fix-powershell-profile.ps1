# Create/update PowerShell profile to use blue colors
$profilePath = $PROFILE.CurrentUserAllHosts

# Create profile directory if it doesn't exist
$profileDir = Split-Path $profilePath
if (!(Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force
}

# Create profile content with blue theme
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
        InlinePrediction   = '#555560'
        Emphasis           = '#0081F2'
    }
}

# Custom prompt with blue accent
function prompt {
    $path = (Get-Location).Path
    Write-Host "PS " -NoNewline -ForegroundColor Blue
    Write-Host "$path" -NoNewline -ForegroundColor White
    Write-Host " >" -NoNewline -ForegroundColor Blue
    return " "
}

# Blue welcome message
Write-Host ""
Write-Host "  MultiSearch Terminal" -ForegroundColor Blue
Write-Host "  $(Get-Date -Format 'dddd, MMMM d, yyyy')" -ForegroundColor DarkGray
Write-Host ""
'@

# Write profile
Set-Content -Path $profilePath -Value $profileContent -Force

Write-Host "PowerShell profile updated at: $profilePath"
Write-Host "Restart terminal to see changes."
