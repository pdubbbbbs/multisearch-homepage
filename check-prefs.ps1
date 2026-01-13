# Check Brave preferences
$prefsPath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Preferences"
$json = Get-Content $prefsPath -Raw | ConvertFrom-Json

Write-Host "=== Session Settings ==="
$json.session | ConvertTo-Json -Depth 5

Write-Host "`n=== Browser Settings ==="
if ($json.browser) {
    $json.browser | Select-Object show_home_button, default_zoom_level | ConvertTo-Json
}

Write-Host "`n=== Homepage ==="
Write-Host "homepage: $($json.homepage)"
Write-Host "homepage_is_newtabpage: $($json.homepage_is_newtabpage)"
