@echo off
setlocal enabledelayedexpansion

:: Get the current date and time, and format it as yyyy-MM-dd hhmmss
for /f "tokens=1-3 delims=/- " %%a in ('echo %date%') do (
    set year=%%a
    set month=%%b
    set day=%%c
)

for /f "tokens=1-3 delims=:." %%a in ("%time%") do (
    set hour=%%a
    set minute=%%b
    set second=%%c
)

set datetime=%year%-%month%-%day%-%hour%%minute%%second%

:: Read the backup-config.ini for the path
set configPath=
for /f "tokens=2 delims==" %%i in (backup-config.ini) do (
    set configPath=%%i
)

:: Create the backup directory
set backupDir=%configPath%\%datetime%
mkdir "%backupDir%"

:: Traverse the current directory and copy files and folders, excluding backup.bat and backup-config.ini
for /f "delims=" %%f in ('dir /b /a-d ^| findstr /v /i "backup.bat backup-config.ini"') do (
    copy "%%f" "%backupDir%"
)

for /f "delims=" %%d in ('dir /b /ad ^| findstr /v /i "backup.bat backup-config.ini"') do (
    xcopy "%%d" "%backupDir%\%%d" /E /I /H /Y
)

echo Backup completed, files have been copied to "%backupDir%"
pause
