# ----------------------------------------------------------------
# 1. Yazi Shell Wrapper (The "y" command)
# ----------------------------------------------------------------
function y {
    $tmp = (New-TemporaryFile).FullName
    yazi.exe $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
    }
    Remove-Item -Path $tmp
}

# ----------------------------------------------------------------
# 2. Automated Initialization Caching
# Automatically creates a 'Cache' folder next to your $PROFILE
# ----------------------------------------------------------------
$cacheDir = Join-Path (Split-Path $PROFILE) "Cache"
if (-not (Test-Path $cacheDir)) { 
    New-Item -ItemType Directory -Path $cacheDir | Out-Null 
}

# ----------------------------------------------------------------
# 3. Zoxide Initialization (Cached)
# ----------------------------------------------------------------
$zoxideCache = Join-Path $cacheDir "zoxide.ps1"
if (-not (Test-Path $zoxideCache)) {
    # Generates the script and saves it to a file on first run
    zoxide init powershell --cmd cd | Out-File -FilePath $zoxideCache -Encoding utf8
}
# Quickly loads the saved script
. $zoxideCache

# ----------------------------------------------------------------
# 4. Starship Prompt Initialization (Cached)
# ----------------------------------------------------------------
$starshipCache = Join-Path $cacheDir "starship.ps1"
if (-not (Test-Path $starshipCache)) {
    # Generates the script and saves it to a file on first run
    starship init powershell | Out-File -FilePath $starshipCache -Encoding utf8
}
# Quickly loads the saved script
. $starshipCache

# ----------------------------------------------------------------
# 5. Terminal Icons
# Loaded last so the prompt and navigation tools are ready first
# ----------------------------------------------------------------
# ----------------------------------------------------------------
# 5. Lazy-Load Terminal Icons
# Delays loading the heavy icon module until you actually use 'ls' or 'dir'
# This makes the terminal startup instant.
# ----------------------------------------------------------------
function Load-Icons-And-List {
    param($Args)
    
    # Check if the module is already loaded to avoid reloading
    if (-not (Get-Module -Name Terminal-Icons)) {
        Write-Host " ...Loading Icons..." -ForegroundColor DarkGray -NoNewline
        Import-Module -Name Terminal-Icons
        Write-Host " Done." -ForegroundColor DarkGray
    }

    # Run the actual directory listing
    Get-ChildItem @Args
}

# Overwrite the standard 'ls' and 'dir' aliases to use our lazy loader
Set-Alias -Name ls -Value Load-Icons-And-List -Scope Global -Option AllScope
Set-Alias -Name dir -Value Load-Icons-And-List -Scope Global -Option AllScope
