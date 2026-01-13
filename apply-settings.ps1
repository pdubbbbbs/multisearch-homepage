# Apply Brave Settings Properly
$homepageUrl = "file:///E:/brave-homepage/index.html"
$prefsPath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Preferences"

# Read as text and parse
$content = Get-Content $prefsPath -Raw
$json = $content | ConvertFrom-Json

# Create a proper hashtable for session
$sessionObj = @{
    "restore_on_startup" = 4
    "startup_urls" = @($homepageUrl)
}

# Remove existing session and add new one
$json.PSObject.Properties.Remove('session')
$json | Add-Member -NotePropertyName 'session' -NotePropertyValue ([PSCustomObject]$sessionObj) -Force

# Set homepage
$json | Add-Member -NotePropertyName 'homepage' -NotePropertyValue $homepageUrl -Force
$json | Add-Member -NotePropertyName 'homepage_is_newtabpage' -NotePropertyValue $false -Force

# Create browser object with zoom
$browserObj = @{
    "show_home_button" = $true
    "default_zoom_level" = 1.2239010857415449
}

if ($json.browser) {
    $json.browser | Add-Member -NotePropertyName 'show_home_button' -NotePropertyValue $true -Force
    $json.browser | Add-Member -NotePropertyName 'default_zoom_level' -NotePropertyValue 1.2239010857415449 -Force
} else {
    $json | Add-Member -NotePropertyName 'browser' -NotePropertyValue ([PSCustomObject]$browserObj) -Force
}

# Write back - use UTF8 without BOM
$jsonString = $json | ConvertTo-Json -Depth 100 -Compress
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($prefsPath, $jsonString, $utf8NoBom)

Write-Host "Settings applied!"
Write-Host ""

# Verify
$verify = Get-Content $prefsPath -Raw | ConvertFrom-Json
Write-Host "Verification:"
Write-Host "  restore_on_startup: $($verify.session.restore_on_startup)"
Write-Host "  startup_urls: $($verify.session.startup_urls)"
Write-Host "  homepage: $($verify.homepage)"
Write-Host "  default_zoom_level: $($verify.browser.default_zoom_level)"
