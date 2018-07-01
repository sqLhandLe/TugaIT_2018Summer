@ECHO OFF
cd /d "%~dp0"

:: logman stop    https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/logman-start-stop
for /f "tokens=3 delims= " %%m in ('logman query ^| findstr "perfmon_%computername%"') DO (if "%%m" == "Running" logman.exe stop perfmon_%COMPUTERNAME%)

pause








