@echo off
REM AI-generated code - Easy Cloudflare Tunnel Starter
echo Starting OpenEMR Cloudflare Tunnel...
echo.
echo Tunnel URL: https://openemr.badgertechnologies.us
echo Local URL:  http://localhost:8080
echo.
echo Press Ctrl+C to stop the tunnel
echo.

REM Kill any existing cloudflared processes
taskkill /F /IM cloudflared.exe >nul 2>&1

REM Start the tunnel
cloudflared tunnel --config tunnel-config-fixed.yml run

REM End AI-generated code