@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

SET SUBNET=10.1.10
SET LIVE_IPS=pingable_ips.txt
SET LOGFILE=reachable_ips.txt

ECHO Phase 1: Pinging %SUBNET%.1 - %SUBNET%.254
ECHO.

:: Reset files
DEL /Q %LIVE_IPS% %LOGFILE% 2>NUL

:: Phase 1 — Ping sweep
FOR /L %%i IN (1,1,254) DO (
    SET IP=%SUBNET%.%%i

    ping -n 1 -w 100 !IP! | find "Reply from" > nul
    IF !ERRORLEVEL! EQU 0 (
        ECHO !IP!
        ECHO !IP!>>%LIVE_IPS%
    )
)

ECHO.
ECHO Phase 2: Checking /login.html route (HTTP 2xx only)
ECHO.

:: Phase 2 — curl only success (2xx)
FOR /F %%I IN (%LIVE_IPS%) DO (
    SET IP=%%I
    SET URL=http://!IP!/login.html

    :: -f fails on 4xx/5xx, --max-redirs 0 blocks redirects
    curl -s -o nul -f --max-redirs 0 --connect-timeout 2 --max-time 3 !URL!

    IF !ERRORLEVEL! EQU 0 (
        ECHO !IP! has SUCCESS /login.html
        ECHO !IP!>>%LOGFILE%
    )
)

:: Cleanup temp file
DEL /Q %LIVE_IPS% 2>NUL

ECHO.
ECHO Scan complete.
ECHO Results saved to %LOGFILE%
pause
