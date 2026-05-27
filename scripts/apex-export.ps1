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

Write-Host "✅ Export done: $LocalDir" -ForegroundColor Green
Write-Host "   Next: git status apex_app/ ; git diff apex_app/" -ForegroundColor DarkGray
