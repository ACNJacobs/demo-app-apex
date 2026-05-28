# PowerShell script to download and install APEX in the container automatically
$ErrorActionPreference = "Stop"

Write-Host "======================================" -ForegroundColor Cyan
Write-Host " Oracle APEX Automatic Installer " -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

if (-not (Test-Path "apex-latest.zip")) {
    Write-Host "Downloading Oracle APEX latest version..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri "https://download.oracle.com/otn_software/apex/apex-latest.zip" -OutFile "apex-latest.zip"
} else {
    Write-Host "apex-latest.zip already exists. Skipping download." -ForegroundColor Green
}

if (-not (Test-Path "apex")) {
    Write-Host "Extracting APEX zip file..." -ForegroundColor Yellow
    Expand-Archive -Path "apex-latest.zip" -DestinationPath "." -Force
} else {
    Write-Host "apex folder already exists. Skipping extraction." -ForegroundColor Green
}

Write-Host "Copying APEX files into the database container..." -ForegroundColor Yellow
docker cp ./apex apex_db:/opt/oracle/apex

Write-Host "Installing APEX in the database (This step takes 10-20 minutes, please be patient!)..." -ForegroundColor Yellow
docker exec -i apex_db bash -c "cd /opt/oracle/apex && sqlplus sys/Welkom_APEX_2026\!@FREEPDB1 as sysdba @apexins.sql sysaux sysaux temp /i/"

Write-Host "Configuring APEX REST..." -ForegroundColor Yellow
$restConfig = @"
@apex_rest_config_core.sql ./ apex_rest_public_user Welkom_APEX_2026! apex_listener Welkom_APEX_2026!
exit;
"@
$restConfig | docker exec -i apex_db bash -c "cd /opt/oracle/apex && sqlplus sys/Welkom_APEX_2026\!@FREEPDB1 as sysdba"


Write-Host "Setting APEX Admin username to ADMIN and password to Welkom_APEX_2026! ..." -ForegroundColor Yellow
$createAdminSql = @"
BEGIN
    APEX_UTIL.set_security_group_id( 10 );
    APEX_UTIL.create_user(
        p_user_name       => 'ADMIN',
        p_email_address   => 'admin@localhost.com',
        p_web_password    => 'Welkom_APEX_2026!',
        p_developer_privs => 'ADMIN' );
    APEX_UTIL.set_security_group_id( null );
    COMMIT;
END;
/
exit;
"@
$createAdminSql | docker exec -i apex_db bash -c "sqlplus sys/Welkom_APEX_2026\!@FREEPDB1 as sysdba"

Write-Host "======================================" -ForegroundColor Cyan
Write-Host " APEX INSTALLATION COMPLETE!" -ForegroundColor Green
Write-Host " You can log in with workspace INTERNAL, user ADMIN, password Welkom_APEX_2026!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
