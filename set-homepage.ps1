# Set Brave Homepage Script
$homepagePath = "file:///E:/brave-homepage/index.html"
$prefsPath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Preferences"

Write-Host "Checking for Brave preferences at: $prefsPath"

if (Test-Path $prefsPath) {
    Write-Host "Found Preferences file!"

    # Check if Brave is running
    $braveProcess = Get-Process -Name "brave" -ErrorAction SilentlyContinue
    if ($braveProcess) {
        Write-Host "Brave is running. Please close Brave first, then run this script again."
        Write-Host "Or set the homepage manually in Brave settings."
        Write-Host ""
        Write-Host "Manual steps:"
        Write-Host "1. Open Brave Settings (brave://settings/)"
        Write-Host "2. Go to 'Get started' section"
        Write-Host "3. Under 'On startup', select 'Open a specific page or set of pages'"
        Write-Host "4. Click 'Add a new page'"
        Write-Host "5. Enter: $homepagePath"
        exit 1
    }

    # Read and modify preferences
    $prefs = Get-Content $prefsPath -Raw | ConvertFrom-Json

    # Set homepage settings
    if (-not $prefs.session) {
        $prefs | Add-Member -NotePropertyName "session" -NotePropertyValue @{} -Force
    }
    if (-not $prefs.session.startup_urls) {
        $prefs.session | Add-Member -NotePropertyName "startup_urls" -NotePropertyValue @() -Force
    }

    $prefs.session.startup_urls = @($homepagePath)
    $prefs.session | Add-Member -NotePropertyName "restore_on_startup" -NotePropertyValue 4 -Force

    # Backup original
    Copy-Item $prefsPath "$prefsPath.backup" -Force
    Write-Host "Created backup at: $prefsPath.backup"

    # Save modified preferences
    $prefs | ConvertTo-Json -Depth 100 -Compress | Set-Content $prefsPath -Encoding UTF8
    Write-Host "Homepage set successfully to: $homepagePath"
    Write-Host ""
    Write-Host "Launch Brave to see your new homepage!"
} else {
    Write-Host "Preferences file not found. Brave may not be fully set up yet."
    Write-Host ""
    Write-Host "Please set the homepage manually:"
    Write-Host "1. Open Brave"
    Write-Host "2. Go to Settings (brave://settings/)"
    Write-Host "3. In 'Get started', select 'Open a specific page'"
    Write-Host "4. Add: $homepagePath"
}
