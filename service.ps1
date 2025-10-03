# AI-generated code - Cloudflare Tunnel Service Manager
param(
    [switch]$Start,
    [switch]$Stop,
    [switch]$Restart,
    [switch]$Status,
    [switch]$Remove,
    [switch]$Install
)

$serviceName = "CloudflaredTunnel"
$displayName = "Cloudflare Tunnel - OpenEMR"

function Show-ServiceStatus {
    try {
        $service = Get-Service -Name $serviceName -ErrorAction Stop
        $status = $service.Status
        $startType = (Get-WmiObject -Class Win32_Service -Filter "Name='$serviceName'").StartMode
        
        switch ($status) {
            "Running" { 
                Write-Host "✅ Service Status: RUNNING" -ForegroundColor Green 
                Write-Host "   🌐 Remote URL: https://openemr.badgertechnologies.us" -ForegroundColor Cyan
                Write-Host "   🏠 Local URL:  http://localhost:8080" -ForegroundColor Cyan
            }
            "Stopped" { Write-Host "❌ Service Status: STOPPED" -ForegroundColor Red }
            default { Write-Host "⚠️ Service Status: $status" -ForegroundColor Yellow }
        }
        Write-Host "   📋 Startup Type: $startType" -ForegroundColor Gray
    } catch {
        Write-Host "❌ Service not found: $serviceName" -ForegroundColor Red
        Write-Host "   Use -Install to create the service" -ForegroundColor Yellow
    }
}

function Start-TunnelService {
    try {
        Write-Host "🚀 Starting service..." -ForegroundColor Green
        Start-Service -Name $serviceName
        Start-Sleep -Seconds 3
        Show-ServiceStatus
    } catch {
        Write-Host "❌ Failed to start service: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Stop-TunnelService {
    try {
        Write-Host "🛑 Stopping service..." -ForegroundColor Yellow
        Stop-Service -Name $serviceName -Force
        Start-Sleep -Seconds 2
        Show-ServiceStatus
    } catch {
        Write-Host "❌ Failed to stop service: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Restart-TunnelService {
    Stop-TunnelService
    Start-Sleep -Seconds 2
    Start-TunnelService
}

function Remove-TunnelService {
    Write-Host "🗑️ Removing service..." -ForegroundColor Red
    try {
        $service = Get-Service -Name $serviceName -ErrorAction Stop
        if ($service.Status -eq "Running") {
            Stop-Service -Name $serviceName -Force
            Start-Sleep -Seconds 2
        }
        
        # Remove using sc.exe for reliability
        $result = sc.exe delete $serviceName
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Service removed successfully!" -ForegroundColor Green
        } else {
            Write-Host "❌ Failed to remove service" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ Service not found: $serviceName" -ForegroundColor Red
    }
}

function Install-TunnelService {
    try {
        # Check if service already exists
        $existingService = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
        if ($existingService) {
            Write-Host "⚠️ Service already exists!" -ForegroundColor Yellow
            Show-ServiceStatus
            return
        }
        
        Write-Host "📦 Installing service..." -ForegroundColor Green
        
        $cloudflaredPath = (Get-Command cloudflared -ErrorAction Stop).Source
        $configFile = "C:\Users\Administrator\Desktop\New folder\openemr\tunnel-config-fixed.yml"
        $binaryPath = "$cloudflaredPath tunnel --config `"$configFile`" run"
        
        New-Service -Name $serviceName -BinaryPathName $binaryPath -DisplayName $displayName -StartupType Automatic -Description "Cloudflare tunnel for OpenEMR remote access"
        
        Write-Host "✅ Service installed successfully!" -ForegroundColor Green
        Show-ServiceStatus
        
        Write-Host ""
        Write-Host "💡 Use 'service.ps1 -Start' to start the service" -ForegroundColor Cyan
        
    } catch {
        Write-Host "❌ Failed to install service: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Main logic
switch ($true) {
    $Install { Install-TunnelService }
    $Start { Start-TunnelService }
    $Stop { Stop-TunnelService }
    $Restart { Restart-TunnelService }
    $Remove { Remove-TunnelService }
    $Status { Show-ServiceStatus }
    default {
        Write-Host "🛠️ Cloudflare Tunnel Service Manager" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Usage:" -ForegroundColor White
        Write-Host "  .\service.ps1 -Status     # Check service status"
        Write-Host "  .\service.ps1 -Start      # Start the service"
        Write-Host "  .\service.ps1 -Stop       # Stop the service"
        Write-Host "  .\service.ps1 -Restart    # Restart the service"
        Write-Host "  .\service.ps1 -Install    # Install the service"
        Write-Host "  .\service.ps1 -Remove     # Remove the service"
        Write-Host ""
        Show-ServiceStatus
    }
}

# End AI-generated code