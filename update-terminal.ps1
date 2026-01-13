# Update Windows Terminal with Futuristic MultiSearch theme
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Read current settings
$settings = Get-Content $settingsPath -Raw | ConvertFrom-Json

# Create the Futuristic MultiSearch theme - NO WHITE, cyan/blue focus
$multiSearchScheme = @{
    "name" = "MultiSearch"
    "background" = "#0A0A0B"
    "foreground" = "#00C8FF"          # Cyan instead of white
    "cursorColor" = "#0081F2"
    "selectionBackground" = "#0081F2"
    "black" = "#0A0A0B"
    "red" = "#FF6B6B"
    "green" = "#4ADE80"
    "yellow" = "#FBBF24"
    "blue" = "#0081F2"
    "purple" = "#A78BFA"
    "cyan" = "#00C8FF"
    "white" = "#888890"               # Muted, not bright white
    "brightBlack" = "#555560"
    "brightRed" = "#FF8A8A"
    "brightGreen" = "#6EE7A0"
    "brightYellow" = "#FCD34D"
    "brightBlue" = "#38A3F8"
    "brightPurple" = "#C4B5FD"
    "brightCyan" = "#67E8F9"
    "brightWhite" = "#B0B0B8"         # Still muted
}

# Check if scheme already exists, if so remove it
$existingIndex = -1
for ($i = 0; $i -lt $settings.schemes.Count; $i++) {
    if ($settings.schemes[$i].name -eq "MultiSearch") {
        $existingIndex = $i
        break
    }
}

if ($existingIndex -ge 0) {
    $schemesList = [System.Collections.ArrayList]@($settings.schemes)
    $schemesList.RemoveAt($existingIndex)
    $settings.schemes = $schemesList.ToArray()
}

# Add new scheme
$settings.schemes += [PSCustomObject]$multiSearchScheme

# Set defaults for all profiles - futuristic style
$settings.profiles.defaults = [PSCustomObject]@{
    "colorScheme" = "MultiSearch"
    "font" = [PSCustomObject]@{
        "face" = "Cascadia Code"
        "size" = 13
        "weight" = "normal"
    }
    "opacity" = 85
    "useAcrylic" = $true
    "cursorShape" = "filledBox"
    "cursorColor" = "#0081F2"
    "padding" = "16"
    "scrollbarState" = "hidden"
    "experimental.retroTerminalEffect" = $false
    "adjustIndistinguishableColors" = "always"
}

# Set dark theme
$settings.theme = "dark"

# Backup original
Copy-Item $settingsPath "$settingsPath.backup" -Force

# Save updated settings
$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8

Write-Host ""
Write-Host "  MULTISEARCH TERMINAL THEME APPLIED" -ForegroundColor Cyan
Write-Host "  ===================================" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "  Colors:" -ForegroundColor DarkGray
Write-Host "    Background:  #0A0A0B (near black)" -ForegroundColor DarkGray
Write-Host "    Foreground:  #00C8FF (cyan - no white!)" -ForegroundColor Cyan
Write-Host "    Accent:      #0081F2 (blue glow)" -ForegroundColor Blue
Write-Host "    Cursor:      Blue filled box" -ForegroundColor Blue
Write-Host ""
Write-Host "  Style:" -ForegroundColor DarkGray
Write-Host "    Opacity:     85% (acrylic blur)" -ForegroundColor DarkGray
Write-Host "    Font:        Cascadia Code 13pt" -ForegroundColor DarkGray
Write-Host "    Scrollbar:   Hidden" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Restart Windows Terminal to see changes." -ForegroundColor Yellow
Write-Host ""
