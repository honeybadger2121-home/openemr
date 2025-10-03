# AI-generated code - Windows Service Setup for Cloudflare Tunnel
# This script creates a proper Windows service for the Cloudflare tunnel

Write-Host "🚀 Setting up Cloudflare Tunnel as Windows Service..." -ForegroundColor Cyan
Write-Host ""

$serviceName = "CloudflaredTunnel"
$displayName = "Cloudflare Tunnel - OpenEMR"
$description = "Cloudflare tunnel service for OpenEMR remote access"
$tunnelId = "74f3a7b9-44a1-47db-a975-744091eea32d"
$workingDir = "C:\Users\Administrator\Desktop\New folder\openemr"
$configFile = "$workingDir\tunnel-config-fixed.yml"
$cloudflaredPath = (Get-Command cloudflared).Source

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ This script requires Administrator privileges!" -ForegroundColor Red
    Write-Host "   Please run PowerShell as Administrator and try again." -ForegroundColor Yellow
    exit 1
}

# Stop existing service if it exists
try {
    $existingService = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($existingService) {
        Write-Host "🛑 Stopping existing service..." -ForegroundColor Yellow
        Stop-Service -Name $serviceName -Force
        Start-Sleep -Seconds 3
    }
} catch {
    # Service doesn't exist, continue
}

# Remove existing service if it exists
try {
    if (Get-Service -Name $serviceName -ErrorAction SilentlyContinue) {
        Write-Host "🗑️ Removing existing service..." -ForegroundColor Yellow
        sc.exe delete $serviceName
        Start-Sleep -Seconds 2
    }
} catch {
    # Service doesn't exist, continue
}

# Create the service using sc.exe (more reliable than New-Service for this use case)
$arguments = "tunnel --config `"$configFile`" run"
$binaryPath = "`"$cloudflaredPath`" $arguments"

Write-Host "📝 Creating Windows service..." -ForegroundColor Green
Write-Host "   Service Name: $serviceName"
Write-Host "   Display Name: $displayName"
Write-Host "   Binary Path: $binaryPath"
Write-Host ""

# Create the service
$result = sc.exe create $serviceName binPath= $binaryPath DisplayName= $displayName start= auto

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Service created successfully!" -ForegroundColor Green
    
    # Set service description
    sc.exe description $serviceName $description
    
    # Configure service to restart on failure
    sc.exe failure $serviceName reset= 86400 actions= restart/5000/restart/10000/restart/30000
    
    # Start the service
    Write-Host "🚀 Starting the service..." -ForegroundColor Green
    Start-Service -Name $serviceName
    
    Start-Sleep -Seconds 5
    
    # Check service status
    $service = Get-Service -Name $serviceName
    if ($service.Status -eq "Running") {
        Write-Host ""
        Write-Host "🎉 SUCCESS! Cloudflare tunnel is now running as a Windows service!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Service Details:" -ForegroundColor Cyan
        Write-Host "  Name: $serviceName"
        Write-Host "  Status: $($service.Status)"
        Write-Host "  Startup Type: Automatic"
        Write-Host ""
        Write-Host "URLs:" -ForegroundColor Cyan
        Write-Host "  Remote: https://openemr.badgertechnologies.us"
        Write-Host "  Local:  http://localhost:8080"
        Write-Host ""
        Write-Host "Service Management:" -ForegroundColor Yellow
        Write-Host "  Start:   Start-Service -Name '$serviceName'"
        Write-Host "  Stop:    Stop-Service -Name '$serviceName'"
        Write-Host "  Restart: Restart-Service -Name '$serviceName'"
        Write-Host "  Status:  Get-Service -Name '$serviceName'"
        Write-Host "  Remove:  sc.exe delete '$serviceName'"
        Write-Host ""
        Write-Host "The tunnel will now start automatically when Windows boots! 🎯"
    } else {
        Write-Host "❌ Service created but failed to start. Status: $($service.Status)" -ForegroundColor Red
        Write-Host "Check Windows Event Viewer for details." -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Failed to create service. Error code: $LASTEXITCODE" -ForegroundColor Red
    Write-Host "Make sure you're running as Administrator." -ForegroundColor Yellow
}

# End AI-generated code