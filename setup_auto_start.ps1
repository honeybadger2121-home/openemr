# AI-generated code - Create Windows Task Scheduler entry for auto-start tunnel
$taskName = "OpenEMR-Cloudflare-Tunnel"
$tunnelPath = "C:\Users\Administrator\Desktop\New folder\openemr"
$configPath = "$tunnelPath\tunnel-config-fixed.yml"

# Create task action
$action = New-ScheduledTaskAction -Execute "cloudflared" -Argument "tunnel --config `"$configPath`" run" -WorkingDirectory $tunnelPath

# Create task trigger (at startup)
$trigger = New-ScheduledTaskTrigger -AtStartup

# Create task settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Create task principal (run as current user)
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive

# Register the task
try {
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description "Auto-start Cloudflare tunnel for OpenEMR" -Force
    Write-Host "✅ Task scheduler entry created successfully!" -ForegroundColor Green
    Write-Host "   Task Name: $taskName"
    Write-Host "   Will start tunnel automatically at system startup"
    Write-Host ""
    Write-Host "To manage this task:"
    Write-Host "   Start: Start-ScheduledTask -TaskName '$taskName'"
    Write-Host "   Stop:  Stop-ScheduledTask -TaskName '$taskName'"
    Write-Host "   Remove: Unregister-ScheduledTask -TaskName '$taskName' -Confirm:`$false"
} catch {
    Write-Host "❌ Error creating task: $($_.Exception.Message)" -ForegroundColor Red
}

# End AI-generated code