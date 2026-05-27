# scripts/apex-export.ps1
# Export SCAFF APP (id 100) from APEX as APEXlang into apex_app/
# Usage: pwsh scripts/apex-export.ps1
[CmdletBinding()]
param(
    [int]$AppId = 100,
    [string]$Schema = "APP_DATA",
    [string]$Password = "Welkom_APEX_2026!",
    [string]$DbHost = "apex_db",
    [string]$Pdb = "FREEPDB1",
    [string]$OrdsContainer = "apex_ords",
    [string]$LocalDir = (Join-Path $PSScriptRoot "..\apex_app")
)

$ErrorActionPreference = "Stop"
$remoteDir = "/tmp/apex_app"

Write-Host "→ Cleaning container $remoteDir" -ForegroundColor Cyan
docker exec $OrdsContainer rm -rf $remoteDir
docker exec $OrdsContainer mkdir -p $remoteDir

Write-Host "→ Running apex export -applicationid $AppId -exptype APEXLANG" -ForegroundColor Cyan
$cmd = "apex export -applicationid $AppId -dir $remoteDir -exptype APEXLANG`nexit"
$cmd | docker exec -i $OrdsContainer sql -S "$Schema/$Password@${DbHost}:1521/$Pdb"

Write-Host "→ Copying back to $LocalDir" -ForegroundColor Cyan
if (Test-Path $LocalDir) { Remove-Item -Recurse -Force $LocalDir }
New-Item -ItemType Directory -Force -Path $LocalDir | Out-Null
docker cp "${OrdsContainer}:${remoteDir}/." $LocalDir

# --- Post-export normalisation patches ---------------------------------------
# APEX 26.1 export bug: writes display-label values that the APEXlang validator
# rejects. Normalise + force LF line endings on every .apx so validate passes
# round-trip without manual touch-ups.
Write-Host "→ Applying post-export patches (LF + provider normalisation)" -ForegroundColor Cyan

$patches = @(
    # provider: OLLAMA  →  provider: genericOpenaiApiCompatible
    @{ Pattern = '(?m)^(\s*provider:\s*)OLLAMA\s*$'; Replacement = '${1}genericOpenaiApiCompatible' }
)

$patchCount = 0
$lfCount    = 0
Get-ChildItem -Path $LocalDir -Recurse -Filter *.apx -File | ForEach-Object {
    $orig = [IO.File]::ReadAllText($_.FullName)
    $new  = $orig -replace "`r`n", "`n"
    if ($new -ne $orig) { $lfCount++ }
    foreach ($p in $patches) {
        $after = [regex]::Replace($new, $p.Pattern, $p.Replacement)
        if ($after -ne $new) { $patchCount++; $new = $after }
    }
    if ($new -ne $orig) {
        [IO.File]::WriteAllText($_.FullName, $new)
    }
}
Write-Host "   LF-normalised: $lfCount file(s) ; provider-patched: $patchCount file(s)" -ForegroundColor DarkGray

# Stale-export guard: detect rogue scaff-app/ created by older runs at repo root.
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$rogue    = Join-Path $repoRoot "scaff-app"
if (Test-Path $rogue) {
    Write-Host "⚠  Removing stale '$rogue' (leftover from older export)" -ForegroundColor Yellow
    Remove-Item -Recurse -Force $rogue
}

Write-Host "✅ Export done: $LocalDir" -ForegroundColor Green
Write-Host "   Next: git status apex_app/ ; git diff apex_app/" -ForegroundColor DarkGray
