# scripts/apex-import.ps1
# Import the APEXlang files under apex_app/scaff-app/ back into the APEX workspace.
# Usage: pwsh scripts/apex-import.ps1
[CmdletBinding()]
param(
    [string]$Alias = "scaff-app",
    [string]$Schema = "APP_DATA",
    [string]$Password = "Welkom_APEX_2026!",
    [string]$DbHost = "apex_db",
    [string]$Pdb = "FREEPDB1",
    [string]$OrdsContainer = "apex_ords",
    [string]$LocalDir = (Join-Path $PSScriptRoot "..\apex_app\$Alias"),
    [switch]$SkipValidate
)

$ErrorActionPreference = "Stop"
$remoteDir = "/tmp/apex_app_import"

if (-not (Test-Path $LocalDir)) {
    Write-Error "Local dir not found: $LocalDir."
    exit 1
}

if (-not $SkipValidate) {
    Write-Host "→ Validating first…" -ForegroundColor Cyan
    & (Join-Path $PSScriptRoot "apex-validate.ps1") -Alias $Alias
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

Write-Host "→ Syncing $LocalDir → ${OrdsContainer}:$remoteDir" -ForegroundColor Cyan
docker exec $OrdsContainer rm -rf $remoteDir
docker exec $OrdsContainer mkdir -p $remoteDir
docker cp "$LocalDir/." "${OrdsContainer}:${remoteDir}"

Write-Host "→ Running apex import -input $remoteDir" -ForegroundColor Cyan
$cmd = "apex import -input $remoteDir`nexit"
$cmd | docker exec -i $OrdsContainer sql -S "$Schema/$Password@${DbHost}:1521/$Pdb"

Write-Host "✅ Import done. Hard-refresh the app (Ctrl+Shift+R)." -ForegroundColor Green
