@echo off
setlocal enabledelayedexpansion

:: Read the destination path from rollback-config.ini
set destinationPath=
for /f "tokens=2 delims==" %%i in (rollback-config.ini) do (
    set destinationPath=%%i
)

:: Check if the destination path is not empty
if "%destinationPath%"=="" (
    echo Error: The destination path is not specified in rollback-config.ini.
    exit /b 1
)

:: Traverse the current directory and copy files and folders, excluding rollback.bat and rollback-config.ini
for /f "delims=" %%f in ('dir /b /a-d ^| findstr /v /i "rollback.bat rollback-config.ini"') do (
    copy /y "%%f" "%destinationPath%"
)

for /f "delims=" %%d in ('dir /b /ad ^| findstr /v /i "rollback.bat rollback-config.ini"') do (
    xcopy "%%d" "%destinationPath%\%%d" /E /I /H /Y
)

echo Rollback completed, files have been copied to "%destinationPath%"
pause
