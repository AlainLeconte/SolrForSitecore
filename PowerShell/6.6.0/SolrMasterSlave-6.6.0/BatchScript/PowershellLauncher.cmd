@Echo OFF
@Echo Launching Powershell as Administrator to execute script : 
@Echo Param1: %1
@Echo Param2: %2
@Echo Param3: %3
@Echo Param4: %4
@Echo Param5: %5
@Echo Param6: %6
@Echo Param7: %7
@Echo Param8: %8
::timeout /t 1
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process -Wait PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%1\" \"%2\" \"%3\" \"%4\" \"%5\" \"%6\" \"%7\" \"%8\"' -Verb runAs}" 
@Echo.
@Echo Powershell ended.
timeout /t 2
::PAUSE
