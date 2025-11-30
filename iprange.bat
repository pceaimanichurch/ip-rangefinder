@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
SET LOGFILE=reachable_ips.txt

ECHO Scanning 10.1.10.1 to 10.1.10.254...
ECHO.
:: Clear the log file or create it new
DEL /Q %LOGFILE% 2>NUL
ECHO List of Reachable IPs (10.1.10.x) > %LOGFILE%
ECHO --------------------------------- >> %LOGFILE%

:: Loop through numbers 1 to 254
FOR /L %%i IN (1,1,254) DO (
    SET IP=10.1.10.%%i
    
    :: Ping the IP and pipe the result to FINDSTR
    ping -n 1 -w 100 !IP! | findstr /i "Reply from"
    
    :: Check the ERRORLEVEL: 0 means FINDSTR found the "Reply from" text.
    if errorlevel 0 (
        :: Display the reachable IP on the console
        ECHO !IP!
        
        :: Append the reachable IP to the log file
        ECHO !IP! >> %LOGFILE%
    )
)

ECHO.
ECHO Scan complete.
ECHO The list of reachable IPs has been saved to: %LOGFILE%
pause
