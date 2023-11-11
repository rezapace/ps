# clone github repository
Set-Location -Path $env:userprofile\Documents\Github
git clone "https://github.com/rezapace/ps"

# Periksa apakah file profil pengguna ada, jika tidak, buat profil baru
if (!(Test-Path -Path $PROFILE -PathType Leaf)) {
    try {
        # Periksa versi PowerShell yang digunakan (Core atau Desktop)
        if ($PSVersionTable.PSEdition -eq "Core") { 
            if (!(Test-Path -Path ($env:userprofile + "\Documents\Powershell"))) {
                New-Item -Path ($env:userprofile + "\Documents\Powershell") -ItemType "directory"
            }
        }
        elseif ($PSVersionTable.PSEdition -eq "Desktop") {
            if (!(Test-Path -Path ($env:userprofile + "\Documents\WindowsPowerShell"))) {
                New-Item -Path ($env:userprofile + "\Documents\WindowsPowerShell") -ItemType "directory"
            }
        }
        # Unduh profil dari GitHub dan tulis ke $PROFILE
        Invoke-RestMethod https://github.com/rezapace/ps/raw/main/Microsoft.PowerShell_profile.ps1 -OutFile $PROFILE
        Write-Host "Profil @ [$PROFILE] telah dibuat."
    }
    catch {
        throw $_.Exception.Message
    }
}
else {
    # Pindahkan profil lama ke oldprofile.ps1 dan unduh profil baru dari GitHub
    Get-Item -Path $PROFILE | Move-Item -Destination oldprofile.ps1 -Force
    Invoke-RestMethod https://github.com/rezapace/ps/raw/main/Microsoft.PowerShell_profile.ps1 -OutFile $PROFILE
    Write-Host "Profil @ [$PROFILE] telah dibuat dan profil lama dihapus."
}

# Eksekusi profil
& $profile

# Instalasi modul-modul yang dibutuhkan melalui PowerShellGet dan Chocolatey
Install-Module -Name Terminal-Icons -Repository PSGallery -Force
Install-Module -Name posh-git -Scope CurrentUser -Force
Install-Module -Name PowerShellGet -Scope CurrentUser -Force
Install-Module -Name z -Scope CurrentUser -Force
Install-Module -Name PSReadLine -Scope CurrentUser -Force
Install-Module -Name PSFzf -Scope CurrentUser -Force

# Set execution policy
Set-ExecutionPolicy RemoteSigned
Set-ExecutionPolicy Restricted
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
