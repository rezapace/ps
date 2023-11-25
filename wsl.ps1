# Cek apakah script dijalankan dengan hak administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Script ini harus dijalankan dengan hak administrator."
    Exit
}

# Fungsi untuk menjalankan perintah dengan penanganan kesalahan
function Run-Command {
    param (
        [string]$command
    )

    try {
        Invoke-Expression -Command $command -ErrorAction Stop
    } catch {
        Write-Host "Error: $_"
        Exit 1
    }
}

# Install Windows Subsystem for Linux (WSL)
Run-Command "wsl.exe --install"

# Enable Windows Subsystem for Linux feature
Run-Command "dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart"

# Enable Virtual Machine Platform feature
Run-Command "dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart"

# Enable Virtual Machine Platform feature using PowerShell
Run-Command "Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart"

# Set default WSL version to 2
Run-Command "wsl --set-default-version 2"

# Install Ubuntu 22.04 from the Windows Package Manager (winget)
Run-Command "winget install Canonical.Ubuntu.2204"

# Set WSL version for the Ubuntu 22.04 instance to 2
Run-Command "wsl.exe --set-version Canonical.Ubuntu.2204 2"

# List installed WSL distributions
Run-Command "wsl --list -v"

# Tentukan path ke file MSI yang telah diunduh
$msiFilePath = "$HOME\Documents\Github\wsl_update_x64.msi"

# Cek apakah file MSI ada
if (Test-Path $msiFilePath) {
    # Instal file MSI
    Start-Process -Wait -FilePath msiexec.exe -ArgumentList "/i `"$msiFilePath`" /qn"
    Write-Host "Instalasi wsl_update_x64.msi berhasil."
} else {
    Write-Host "File MSI tidak ditemukan: $msiFilePath"
}

Write-Host "di sarankan untuk melakukan restart."
