@echo off
title Simple FFMPEG m3u8 (or other media) Downloader
:: BatchGotAdmin
::-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:: This part was made by MRxSNIPES2
::--------------------------------------

:start
cd %~dp0

cls
echo Please input link to .m3u8 (or other media) file: 
set /p _link=
if not defined _link goto err_link

cls
echo Please input file name:
echo (Nothing for default value: file)
set /p _name= || set _name=file

cls
echo Please input file format (mp4 recommend):
echo (Nothing for default value: mp4)
set /p _format= || set _format=mp4

cls
echo Input user agent if needed (or use this):
echo (Nothing for default value: "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:93.0) Gecko/20100101 Firefox/93.0/Z5PhbZiL-09")
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

:err_link
cls
echo You should input link to media file.
pause
goto start

:: This spaghetti code was made by Japanese Schoolgirl (Lisa)