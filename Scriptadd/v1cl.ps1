$processesToKill = @(
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
    "vmware-tray"
)

foreach ($processName in $processesToKill) {
    Stop-Process -Name $processName -Force
}

Clear-Host

Write-Host "All programs have been closed."