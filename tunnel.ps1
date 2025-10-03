# AI-generated code - PowerShell Cloudflare Tunnel Manager
param(
    [switch]$Start,
    [switch]$Stop,
    [switch]$Status,
    [switch]$Background
)

$tunnelId = "74f3a7b9-44a1-47db-a975-744091eea32d"
$configFile = "tunnel-config-fixed.yml"
$processName = "cloudflared"

function Show-Status {
    $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($processes) {
        Write-Host "✅ Tunnel is RUNNING" -ForegroundColor Green
        Write-Host "   Process IDs: $($processes.Id -join ', ')"
        Write-Host "   URL: https://openemr.badgertechnologies.us"
        Write-Host "   Local: http://localhost:8080"
    } else {
        Write-Host "❌ Tunnel is STOPPED" -ForegroundColor Red
    }
}

function Stop-Tunnel {
    Write-Host "🛑 Stopping tunnel..." -ForegroundColor Yellow
    Get-Process -Name $processName -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2
    Show-Status
}

function Start-Tunnel {
    param([bool]$RunInBackground = $false)
    
    # Stop existing processes
    Stop-Tunnel
    
    Write-Host "🚀 Starting tunnel..." -ForegroundColor Green
    
    if ($RunInBackground) {
        Start-Process -FilePath "cloudflared" -ArgumentList "tunnel", "--config", $configFile, "run" -WindowStyle Hidden
        Start-Sleep -Seconds 3
        Show-Status
    } else {
        Write-Host "Press Ctrl+C to stop the tunnel" -ForegroundColor Cyan
        & cloudflared tunnel --config $configFile run
    }
}

# Main logic
if ($Stop) {
    Stop-Tunnel
} elseif ($Status) {
    Show-Status
} elseif ($Start) {
    Start-Tunnel -RunInBackground $Background
} else {
    Write-Host "🌐 OpenEMR Cloudflare Tunnel Manager" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  .\tunnel.ps1 -Start          # Start tunnel (interactive)"
    Write-Host "  .\tunnel.ps1 -Start -Background  # Start tunnel (background)"
    Write-Host "  .\tunnel.ps1 -Stop           # Stop tunnel"
    Write-Host "  .\tunnel.ps1 -Status         # Check tunnel status"
    Write-Host ""
    Show-Status
}

# End AI-generated code