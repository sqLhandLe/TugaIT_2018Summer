@ECHO OFF
cd /d "%~dp0"
ECHO. 2>counters__rehydrated.txt

for /f "delims=" %%l in (System_counters__dehydrated.txt) DO (
  ECHO %%l>>counters__rehydrated.txt
)

for /f "tokens=* delims=" %%i in ('typeperf -q ^| findstr /C:"Buffer Manager\\Database pages"') DO (
 for /f "tokens=1 delims=:" %%j in ("%%i") DO (
  for /f "delims=" %%k in (SQLServer_counters__dehydrated.txt) DO (
   ECHO %%j%%k>>counters__rehydrated.txt
  )
 )
)

:: logman stop    https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/logman-start-stop
for /f "tokens=3 delims= " %%m in ('logman query ^| findstr "perfmon_%computername%"') DO (if "%%m" == "Running" logman.exe stop perfmon_%COMPUTERNAME%)

:: logman delete  https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/logman-delete
for /f "tokens=3 delims= " %%n in ('logman query ^| findstr "perfmon_%computername%"') DO (if "%%n" == "Stopped" logman.exe delete perfmon_%COMPUTERNAME%)

:: logman create  https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/logman-create
logman.exe create counter perfmon_%COMPUTERNAME% -f csv -v mmddhhmm -max 32 -cf counters__rehydrated.txt -o "perfmon_%COMPUTERNAME%" -si 00:00:30 -cnf 24:00:00 -rf 168:00:00

:: logman start   https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/logman-start-stop
logman.exe start perfmon_%COMPUTERNAME%

pause








