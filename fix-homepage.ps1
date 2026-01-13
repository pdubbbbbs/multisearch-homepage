# Fix Brave Homepage Script
$homepageUrl = "file:///E:/brave-homepage/index.html"
$prefsPath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Preferences"

Write-Host "Reading preferences..."

$json = Get-Content $prefsPath -Raw | ConvertFrom-Json

# Method 1: Set startup URLs (restore_on_startup = 4 means open specific pages)
if (-not $json.PSObject.Properties['session']) {
    $json | Add-Member -NotePropertyName 'session' -NotePropertyValue ([PSCustomObject]@{}) -Force
}
$json.session | Add-Member -NotePropertyName 'restore_on_startup' -NotePropertyValue 4 -Force
$json.session | Add-Member -NotePropertyName 'startup_urls' -NotePropertyValue @($homepageUrl) -Force

# Method 2: Also set homepage properties
if (-not $json.PSObject.Properties['homepage']) {
    $json | Add-Member -NotePropertyName 'homepage' -NotePropertyValue $homepageUrl -Force
} else {
    $json.homepage = $homepageUrl
}
$json | Add-Member -NotePropertyName 'homepage_is_newtabpage' -NotePropertyValue $false -Force

# Method 3: Set browser startup settings
if (-not $json.PSObject.Properties['browser']) {
    $json | Add-Member -NotePropertyName 'browser' -NotePropertyValue ([PSCustomObject]@{}) -Force
}
$json.browser | Add-Member -NotePropertyName 'show_home_button' -NotePropertyValue $true -Force

# Save with proper formatting
$jsonString = $json | ConvertTo-Json -Depth 100 -Compress
[System.IO.File]::WriteAllText($prefsPath, $jsonString)

Write-Host "Preferences updated!"
Write-Host "Homepage URL: $homepageUrl"
Write-Host "restore_on_startup: 4 (open specific pages)"
