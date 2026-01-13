# Fix ALL Brave shortcuts to open with custom homepage
$homepageUrl = "file:///E:/brave-homepage/index.html"
$WshShell = New-Object -ComObject WScript.Shell

$shortcutLocations = @(
    # User desktop
    "$env:USERPROFILE\Desktop\Brave.lnk",
    "$env:USERPROFILE\Desktop\Brave Browser.lnk",
    # Public desktop
    "$env:PUBLIC\Desktop\Brave.lnk",
    "$env:PUBLIC\Desktop\Brave Browser.lnk",
    # Start menu (user)
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Brave.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Brave Browser.lnk",
    # Start menu (all users)
    "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Brave.lnk",
    "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Brave Browser.lnk",
    # Taskbar
    "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Brave.lnk",
    "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Brave Browser.lnk"
)

Write-Host "Searching for Brave shortcuts..."
Write-Host ""

$found = 0
foreach ($path in $shortcutLocations) {
    if (Test-Path $path) {
        Write-Host "Found: $path"
        try {
            $shortcut = $WshShell.CreateShortcut($path)
            $shortcut.Arguments = $homepageUrl
            $shortcut.Save()
            Write-Host "  -> Modified successfully"
            $found++
        } catch {
            Write-Host "  -> Failed (may need admin rights)"
        }
    }
}

# Also search recursively in Start Menu
$startMenuPaths = @(
    "$env:APPDATA\Microsoft\Windows\Start Menu",
    "$env:ProgramData\Microsoft\Windows\Start Menu"
)

foreach ($menuPath in $startMenuPaths) {
    if (Test-Path $menuPath) {
        Get-ChildItem -Path $menuPath -Filter "*Brave*.lnk" -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            Write-Host "Found: $($_.FullName)"
            try {
                $shortcut = $WshShell.CreateShortcut($_.FullName)
                $shortcut.Arguments = $homepageUrl
                $shortcut.Save()
                Write-Host "  -> Modified successfully"
                $found++
            } catch {
                Write-Host "  -> Failed"
            }
        }
    }
}

Write-Host ""
Write-Host "Modified $found shortcut(s)"
Write-Host ""
Write-Host "If you have Brave pinned to taskbar, unpin and re-pin it using the desktop shortcut."
