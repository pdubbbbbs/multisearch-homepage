# Force Brave Homepage - Check all possible settings
$prefsPath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Preferences"
$homepageUrl = "file:///E:/brave-homepage/index.html"

$content = Get-Content $prefsPath -Raw
$json = $content | ConvertFrom-Json

Write-Host "Current restore_on_startup value: $($json.session.restore_on_startup)"
Write-Host "Possible values:"
Write-Host "  1 = Open the New Tab page"
Write-Host "  4 = Open a specific page or set of pages"
Write-Host "  5 = Continue where you left off"
Write-Host ""

# Force restore_on_startup to 4 (specific pages)
if (-not $json.session) {
    $json | Add-Member -NotePropertyName 'session' -NotePropertyValue ([PSCustomObject]@{}) -Force
}

# Remove and recreate to ensure clean state
$json.PSObject.Properties.Remove('session')
$json | Add-Member -NotePropertyName 'session' -NotePropertyValue ([PSCustomObject]@{
    restore_on_startup = 4
    startup_urls = @($homepageUrl)
}) -Force

# Also check for brave-specific settings
if ($json.brave) {
    Write-Host "Found brave-specific settings..."
}

# Check for sync that might override
if ($json.sync) {
    Write-Host "Sync is enabled - this might override local settings"
}

# Save
$jsonString = $json | ConvertTo-Json -Depth 100 -Compress
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($prefsPath, $jsonString, $utf8NoBom)

Write-Host ""
Write-Host "Settings forced. New values:"
$verify = Get-Content $prefsPath -Raw | ConvertFrom-Json
Write-Host "  restore_on_startup: $($verify.session.restore_on_startup)"
Write-Host "  startup_urls: $($verify.session.startup_urls -join ', ')"
