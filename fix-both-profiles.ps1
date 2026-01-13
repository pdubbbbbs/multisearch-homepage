# Update both PowerShell profiles with blue theme

# Profile content (compatible with both PS 5.x and 7.x)
$profileContent = @'
# MultiSearch Blue Theme for PowerShell
$Host.UI.RawUI.ForegroundColor = 'White'
$Host.UI.RawUI.BackgroundColor = 'Black'

# Set PSReadLine colors to blue theme
if (Get-Module -ListAvailable -Name PSReadLine) {
    $colors = @{
        Command   = '#0081F2'
        Parameter = '#FFFFFF'
        Operator  = '#0081F2'
        Variable  = '#38A3F8'
        String    = '#FFFFFF'
        Number    = '#38A3F8'
        Member    = '#FFFFFF'
        Default   = '#FFFFFF'
        Comment   = '#555560'
        Keyword   = '#0081F2'
        Type      = '#38A3F8'
        Error     = '#FF5555'
        Selection = '#0081F2'
        Emphasis  = '#0081F2'
    }

    # Add InlinePrediction only if supported (PSReadLine 2.2+)
    $psrlVersion = (Get-Module PSReadLine -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1).Version
    if ($psrlVersion -ge [Version]'2.2.0') {
        $colors['InlinePrediction'] = '#555560'
    }

    Set-PSReadLineOption -Colors $colors
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

# Update Windows PowerShell profile (5.x)
$ps5ProfileDir = "$env:USERPROFILE\Documents\WindowsPowerShell"
$ps5ProfilePath = Join-Path $ps5ProfileDir 'profile.ps1'

if (!(Test-Path $ps5ProfileDir)) {
    New-Item -ItemType Directory -Path $ps5ProfileDir -Force | Out-Null
}
Set-Content -Path $ps5ProfilePath -Value $profileContent -Force
Write-Host "Windows PowerShell profile updated: $ps5ProfilePath"

# Update PowerShell 7 profile
$ps7ProfileDir = "$env:USERPROFILE\Documents\PowerShell"
$ps7ProfilePath = Join-Path $ps7ProfileDir 'profile.ps1'

if (!(Test-Path $ps7ProfileDir)) {
    New-Item -ItemType Directory -Path $ps7ProfileDir -Force | Out-Null
}
Set-Content -Path $ps7ProfilePath -Value $profileContent -Force
Write-Host "PowerShell 7 profile updated: $ps7ProfilePath"

Write-Host ""
Write-Host "Restart your terminal to see the blue theme!" -ForegroundColor Blue
