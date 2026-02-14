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
# 5. Eza (Fast Rust replacement for ls)
# Completely bypasses PowerShell formatting for instant, colored output
# ----------------------------------------------------------------

# First, remove PowerShell's default 'ls' and 'dir' aliases so they don't conflict
Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
Remove-Item Alias:dir -Force -ErrorAction SilentlyContinue

# Map standard commands to eza, passing through any extra flags (like -la) via $args
function ls { eza --icons $args }
function ll { eza -l --icons $args }
function la { eza -a --icons $args }
function lla { eza -la --icons $args }
# Optional: Map 'dir' to eza as well, just in case you accidentally type it
function dir { eza --icons $args }
fastfetch
