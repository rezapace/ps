@echo off
setlocal enabledelayedexpansion

REM Mendapatkan daftar proses dengan judul jendela tidak kosong, dan bukan PowerShell
for /f "tokens=*" %%a in ('powershell -Command "Get-Process | Where-Object { $_.MainWindowTitle -ne '' -and $_.ProcessName -ne 'powershell' } | ForEach-Object { $_.Id }"') do (
    set "processId=%%a"
    REM Menghentikan setiap proses dengan ID yang ditemukan
    taskkill /F /PID !processId!
)

endlocal
