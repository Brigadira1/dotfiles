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
# 2. Zoxide Initialization
# This ensures every 'cd' is recorded in the Zoxide database.
# ----------------------------------------------------------------
# NEW LINE
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })
$Env:KOMOREBI_CONFIG_HOME = 'C:\Users\iavor\.config\komorebi'
$env:WHKD_CONFIG_HOME = 'C:\Users\iavor\.config\komorebi'
Invoke-Expression (&starship init powershell)
Import-Module Terminal-Icons
