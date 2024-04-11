$processesToStop = @(
    "OfficeClickToRun",
    "GoogleCrashHandler",
    "GoogleCrashHandler64",
    "Telegram",
    "Code",
    "chrome",
    "notepad",
    "7zFM",
    "Discord",
    "WINWORD",
    "EXCEL",
    "POWERPNT",
    "Notion",
    "vlc",
    "xampp-control",
    "cmd",
    "SearchApp",
    "Postman",
    "obs64",
    "GitHubDesktop",
    "wpscenter",
    "wpscloudsvr",
    "vmware-authd",
    "vmnetdhcp",
    "vmnat",
    "vmware-usbarbitrator64",
    "vmware-unity-helper",
    "vmware",
    "vmware-tray",
    "MicrosoftEdgeUpdate",
    "vmcompute"
)

# Start background jobs to stop processes
$jobs = foreach ($processName in $processesToStop) {
    Start-Job -ScriptBlock { param($name) Stop-Process -Name $name -Force } -ArgumentList $processName
}

# Wait for all background jobs to complete
Wait-Job -Job $jobs | Out-Null

# Receive the results from the background jobs
Receive-Job -Job $jobs | ForEach-Object {
    Write-Output $_
}

# Remove the completed jobs
Remove-Job -Job $jobs

# Clear screen
Clear-Host

Write-Output "All specified processes have been closed."
