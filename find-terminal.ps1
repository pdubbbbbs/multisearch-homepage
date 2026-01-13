# Find Windows Terminal settings
$packages = Get-ChildItem "$env:LOCALAPPDATA\Packages" -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like '*Terminal*' }

foreach ($pkg in $packages) {
    Write-Host "Found: $($pkg.Name)"
    $settingsPath = Join-Path $pkg.FullName "LocalState\settings.json"
    if (Test-Path $settingsPath) {
        Write-Host "Settings at: $settingsPath"
    }
}

# Also check for portable/scoop install
$altPaths = @(
    "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json",
    "$env:APPDATA\Microsoft\Windows Terminal\settings.json"
)

foreach ($path in $altPaths) {
    if (Test-Path $path) {
        Write-Host "Alt settings: $path"
    }
}
