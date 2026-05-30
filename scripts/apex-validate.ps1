# scripts/apex-validate.ps1
# Validate the APEXlang files under apex_app/scaff-app/ before importing.
# Usage: pwsh scripts/apex-validate.ps1
[CmdletBinding()]
param(
    [string]$Alias = "scaff-app",
    [string]$Schema = "APP_DATA",
    [string]$Password = "Welkom_APEX_2026!",
    [string]$DbHost = "apex_db",
    [string]$Pdb = "FREEPDB1",
    [string]$OrdsContainer = "apex_ords",
    [string]$LocalDir = "D:\oracle apex\apex_app\scaff-app"
)

$ErrorActionPreference = "Stop"
$remoteDir = "/tmp/apex_app_validate"

if (-not (Test-Path $LocalDir)) {
    Write-Error "Local dir not found: $LocalDir. Run apex-export.ps1 first."
    exit 1
}

Write-Host "→ Syncing $LocalDir → ${OrdsContainer}:$remoteDir" -ForegroundColor Cyan
docker exec $OrdsContainer rm -rf $remoteDir
docker exec $OrdsContainer mkdir -p $remoteDir
docker cp "$LocalDir/." "${OrdsContainer}:${remoteDir}"

Write-Host "→ Running apex validate -input $remoteDir" -ForegroundColor Cyan
$cmd = "apex validate -input $remoteDir`nexit"
$out = $cmd | docker exec -i $OrdsContainer sql -S "$Schema/$Password@${DbHost}:1521/$Pdb"
$out

if ($out -match "error|invalid|fail" -and $out -notmatch "0 errors") {
    Write-Host "Validate produced issues. Fix before importing." -ForegroundColor Red
    exit 2
}
Write-Host "Validate OK - safe to import." -ForegroundColor Green
