# Membersihkan folder C:\Windows\Temp
$windowsTempPath = "C:\Windows\Temp"
if (Test-Path -Path $windowsTempPath) {
    Remove-Item -Path $windowsTempPath\* -Force -Recurse -ErrorAction SilentlyContinue
}

# Membersihkan folder C:\Users\R\AppData\Local\Temp
$userTempPath = "C:\Users\R\AppData\Local\Temp"
if (Test-Path -Path $userTempPath) {
    Remove-Item -Path $userTempPath\* -Force -Recurse -ErrorAction SilentlyContinue
}

# Membersihkan folder C:\Windows\Prefetch
$prefetchPath = "C:\Windows\Prefetch"
if (Test-Path -Path $prefetchPath) {
    Get-ChildItem -Path $prefetchPath -File -Force | Remove-Item -Force -ErrorAction SilentlyContinue
}

# Menjalankan utilitas Disk Cleanup
$diskCleanupPath = "$env:SystemRoot\System32\cleanmgr.exe"
if (Test-Path -Path $diskCleanupPath) {
    Start-Process -FilePath $diskCleanupPath -ArgumentList "/sagerun:1" -Wait
}

# Membersihkan Recycle Bin
Clear-RecycleBin -Force
