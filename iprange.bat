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


    ping -n 1 -w 100 !IP! | findstr /i "Reply from" > nul
    
    :: 2. Check the ERRORLEVEL status set by findstr.
    :: If "Reply from" was found, ERRORLEVEL will be 0.
    if !errorlevel! equ 0 (
        :: SET the status variable to 1 (Reachable)
        SET "IP_STATUS=1"
        
        ECHO !IP! is REACHABLE.
        ECHO !IP! >> %LOGFILE%
    ) ELSE (
        :: Optional: If ERRORLEVEL is 1 (Not found/Unreachable)
        ECHO !IP! is UNREACHABLE.
    )
)

ECHO.
ECHO Scan complete.
ECHO The list of reachable IPs has been saved to: %LOGFILE%
pause
