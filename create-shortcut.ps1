# Create Brave shortcut that opens with custom homepage
$WshShell = New-Object -ComObject WScript.Shell

# Desktop shortcut
$desktopPath = [Environment]::GetFolderPath('Desktop')
$shortcutPath = Join-Path $desktopPath "Brave (Custom Home).lnk"

$shortcut = $WshShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
$shortcut.Arguments = "file:///E:/brave-homepage/index.html"
$shortcut.WorkingDirectory = "C:\Program Files\BraveSoftware\Brave-Browser\Application"
$shortcut.IconLocation = "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe,0"
$shortcut.Description = "Brave Browser with Custom Homepage"
$shortcut.Save()

Write-Host "Created shortcut on Desktop: Brave (Custom Home)"

# Also try to modify the taskbar/Start menu shortcut
$startMenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Brave.lnk"
if (Test-Path $startMenuPath) {
    $shortcut2 = $WshShell.CreateShortcut($startMenuPath)
    $shortcut2.Arguments = "file:///E:/brave-homepage/index.html"
    $shortcut2.Save()
    Write-Host "Modified Start Menu shortcut"
}

# Check common Brave shortcut locations
$commonPaths = @(
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Brave.lnk",
    "$env:PUBLIC\Desktop\Brave.lnk",
    "$desktopPath\Brave.lnk"
)

foreach ($path in $commonPaths) {
    if (Test-Path $path) {
        Write-Host "Found shortcut at: $path"
        $sc = $WshShell.CreateShortcut($path)
        $sc.Arguments = "file:///E:/brave-homepage/index.html"
        $sc.Save()
        Write-Host "  -> Modified to open homepage"
    }
}

Write-Host ""
Write-Host "Done! Use the 'Brave (Custom Home)' shortcut on your desktop."
