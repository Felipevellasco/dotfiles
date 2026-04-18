# Start profiling
$startTime = Get-Date

Write-Host "---------- Yazi ----------" -ForegroundColor Cyan

# Check if yazi is in path before running
if (Get-Command "ya" -ErrorAction SilentlyContinue) {
    ya pkg install
} else {
    Write-Warning "Yazi (ya) CLI not found. Skipping package installation."
}

# End profiling
$endTime = Get-Date
$elapsed = ($endTime - $startTime).TotalMilliseconds

Write-Host "Bootstrapping completed in $($elapsed) ms."
Write-Host "---------- End -----------`n"
