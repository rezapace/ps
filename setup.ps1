# Cek apakah Git terinstal, jika tidak, install Git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is not installed. Installing Git..."
    winget install -e --id Git.Git
}

# Membuat direktori jika tidak ada
$githubDirectory = Join-Path $env:userprofile "Documents\Github"
if (!(Test-Path -Path $githubDirectory -PathType Container)) {
    New-Item -Path $githubDirectory -ItemType Directory | Out-Null
}

# Navigasi ke direktori Github
Set-Location -Path $githubDirectory

# Clone repositori dari GitHub
git clone "https://github.com/rezapace/powershell-profile"

# Navigasi kembali ke direktori sebelumnya
Set-Location -Path $PWD.Path

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
        Invoke-RestMethod https://github.com/rezapace/powershell-profile/raw/main/Microsoft.PowerShell_profile.ps1 -OutFile $PROFILE
        Write-Host "Profil @ [$PROFILE] telah dibuat."
    }
    catch {
        throw $_.Exception.Message
    }
}
else {
    # Pindahkan profil lama ke oldprofile.ps1 dan unduh profil baru dari GitHub
    Get-Item -Path $PROFILE | Move-Item -Destination oldprofile.ps1 -Force
    Invoke-RestMethod https://github.com/rezapace/powershell-profile/raw/main/Microsoft.PowerShell_profile.ps1 -OutFile $PROFILE
    Write-Host "Profil @ [$PROFILE] telah dibuat dan profil lama dihapus."
}

# Eksekusi profil
& $profile

# Instalasi Oh My Posh menggunakan Windows Package Manager (winget)
winget install -e --accept-source-agreements --accept-package-agreements JanDeDobbeleer.OhMyPosh


# Instalasi font jika tidak ada
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
$fontFamilies = (New-Object System.Drawing.Text.InstalledFontCollection).Families
if ($fontFamilies -notcontains "CaskaydiaCove NF") {
    # Unduh font dari GitHub
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile("https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip", ".\CascadiaCode.zip")

    # Ekstrak font dan instalasi ke direktori Fonts Windows
    Expand-Archive -Path ".\CascadiaCode.zip" -DestinationPath ".\CascadiaCode" -Force
    $destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
    Get-ChildItem -Path ".\CascadiaCode" -Recurse -Filter "*.ttf" | ForEach-Object {
        If (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {        
            # Install font
            $destination.CopyHere($_.FullName, 0x10)
        }
    }
    # Bersihkan file yang tidak diperlukan setelah instalasi font
    Remove-Item -Path ".\CascadiaCode" -Recurse -Force
    Remove-Item -Path ".\CascadiaCode.zip" -Force
}

# Set execution policy dan unduh serta jalankan Chocolatey installer
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Instalasi modul-modul yang dibutuhkan melalui PowerShellGet dan Chocolatey
Install-Module -Name Terminal-Icons -Repository PSGallery -Force
Install-Module -Name posh-git -Scope CurrentUser -Force
Install-Module -Name PowerShellGet -Scope CurrentUser -Force
Install-Module -Name z -Scope CurrentUser -Force
Install-Module -Name PSReadLine -Scope CurrentUser -Force
choco install fzf -y
Install-Module -Name PSFzf -Scope CurrentUser -Force
choco install gsudo -y

# Set execution policy
Set-ExecutionPolicy RemoteSigned
Set-ExecutionPolicy Restricted
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
