# Set Windows Terminal transparency (80% opacity = 20% transparency)
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

$settings = Get-Content $settingsPath -Raw | ConvertFrom-Json

# Update only opacity, preserve other settings
$settings.profiles.defaults.opacity = 80

$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8

Write-Host "Terminal opacity set to 80% (20% transparency)" -ForegroundColor Green
