# Set Brave Default Zoom to 125%
$prefsPath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Preferences"

Write-Host "Setting default zoom to 125%..."

$json = Get-Content $prefsPath -Raw | ConvertFrom-Json

# Set default zoom level (125% = 0.223 in Chrome's logarithmic scale)
# Formula: zoom_level = log(zoom_factor) / log(1.2)
# For 125% (1.25): log(1.25) / log(1.2) ≈ 1.224

if (-not $json.PSObject.Properties['browser']) {
    $json | Add-Member -NotePropertyName 'browser' -NotePropertyValue ([PSCustomObject]@{}) -Force
}

# Default zoom factor as percentage (1.25 = 125%)
$json.browser | Add-Member -NotePropertyName 'default_zoom_level' -NotePropertyValue 1.2239010857415449 -Force

# Also set partition default zoom level
if (-not $json.PSObject.Properties['partition']) {
    $json | Add-Member -NotePropertyName 'partition' -NotePropertyValue ([PSCustomObject]@{}) -Force
}
if (-not $json.partition.PSObject.Properties['default_zoom_level']) {
    $json.partition | Add-Member -NotePropertyName 'default_zoom_level' -NotePropertyValue ([PSCustomObject]@{}) -Force
}
$json.partition.default_zoom_level | Add-Member -NotePropertyName 'x' -NotePropertyValue 1.2239010857415449 -Force

# Profile default zoom
if (-not $json.PSObject.Properties['profile']) {
    $json | Add-Member -NotePropertyName 'profile' -NotePropertyValue ([PSCustomObject]@{}) -Force
}
$json.profile | Add-Member -NotePropertyName 'default_zoom_level' -NotePropertyValue 1.2239010857415449 -Force

# Save
$jsonString = $json | ConvertTo-Json -Depth 100 -Compress
[System.IO.File]::WriteAllText($prefsPath, $jsonString)

Write-Host "Default zoom set to 125%!"
