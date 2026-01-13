# Fix Brave startup - disable session restore, force homepage
$prefsPath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Preferences"
$homepageUrl = "file:///E:/brave-homepage/index.html"

$content = Get-Content $prefsPath -Raw
$json = $content | ConvertFrom-Json

# Force session settings - value 4 = open specific pages
$json.PSObject.Properties.Remove('session')
$json | Add-Member -NotePropertyName 'session' -NotePropertyValue ([PSCustomObject]@{
    restore_on_startup = 4
    startup_urls = @($homepageUrl)
}) -Force

# Set homepage
$json | Add-Member -NotePropertyName 'homepage' -NotePropertyValue $homepageUrl -Force
$json | Add-Member -NotePropertyName 'homepage_is_newtabpage' -NotePropertyValue $false -Force

# Disable session buddy / tab restore features if present
if ($json.browser) {
    $json.browser | Add-Member -NotePropertyName 'has_seen_welcome_page' -NotePropertyValue $true -Force
}

# Save
$jsonString = $json | ConvertTo-Json -Depth 100 -Compress
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($prefsPath, $jsonString, $utf8NoBom)

# Also clear session storage to prevent old tabs from restoring
$sessionPaths = @(
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Sessions",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Session Storage",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Current Session",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Current Tabs",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Last Session",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Last Tabs"
)

foreach ($path in $sessionPaths) {
    if (Test-Path $path) {
        Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Cleared: $path"
    }
}

Write-Host ""
Write-Host "Settings applied:"
Write-Host "  restore_on_startup: 4 (open specific pages)"
Write-Host "  startup_urls: $homepageUrl"
Write-Host "  Cleared session data to prevent old tabs"
