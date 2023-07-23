@echo off
title Simple FFMPEG m3u8 Downloader
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:: This part was made by Eneerge (https://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file#10052222)
:--------------------------------------
:start
cls
cd %~dp0

echo Please input link (to .m3u8 file): 
echo (Default value is: none)
set /p _link=

cls
echo Please input file name:
echo (Default value is: file)
set /p _name= || set _name=file

cls
echo Please input file format (mp4 recommend):
echo (Default value is: mp4)
set /p _format= || set _format=mp4

cls
echo Input user agent if needed (or use this):
echo (Default value is: "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:93.0) Gecko/20100101 Firefox/93.0/Z5PhbZiL-09")
set /p _userAgent= || set _userAgent="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:93.0) Gecko/20100101 Firefox/93.0/Z5PhbZiL-09"

cls
ffmpeg -user_agent %_userAgent% -i %_link% -c copy %_name%.%_format%

echo ------------------------------------------------------
echo Done.
pause
cls

echo Download another file?
echo Send "1" for Yes, anything else for "No"

set /p _act=
if %_act% == 1 goto start
exit

:: Made by Japanese Schoolgirl (Lisa)