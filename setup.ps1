# cek winget sudah terinstall atau belum
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Error: winget is not installed. Please install winget and run the script again."
    exit
}

# cek git sudah terinstall atau belum
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is not installed. Installing Git..."
    winget install -e --id Git.Git
}

# cek oh-my-posh sudah terinstall atau belum
$ohMyPoshInstalled = Get-Command oh-my-posh -ErrorAction SilentlyContinue

if (-not $ohMyPoshInstalled) {
    Write-Host "Oh My Posh is not installed. Installing Oh My Posh..."
    winget install -e --accept-source-agreements --accept-package-agreements JanDeDobbeleer.OhMyPosh
}
else {
    Write-Host "Oh My Posh is already installed."
}

# penginstalan Font
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
$fontFamilies = (New-Object System.Drawing.Text.InstalledFontCollection).Families
if ($fontFamilies -notcontains "CaskaydiaCove NF") {
    # Download Font Dari github
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile("https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip", ".\CascadiaCode.zip")

    # extract font dan install ke direktori font windows
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

# cek chocolatey sudah terinstall atau belum
$chocolateyInstalled = Get-Command choco -ErrorAction SilentlyContinue
if (-not $chocolateyInstalled) {
    # Set execution policy and download/run Chocolatey installer
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
else {
    Write-Host "Chocolatey is already installed."
}

# cek fzf sudah terinstall atau belum
$fzfInstalled = Get-Command fzf -ErrorAction SilentlyContinue
if (-not $fzfInstalled) {
    choco install fzf -y
}
else {
    Write-Host "fzf is already installed."
}

# cek gsudo sudah terinstall atau belum
$gsudoInstalled = Get-Command gsudo -ErrorAction SilentlyContinue
if (-not $gsudoInstalled) {
    choco install gsudo -y
}
else {
    Write-Host "gsudo is already installed."
}

# Membuat direktori jika tidak ada
$githubDirectory = Join-Path $env:userprofile "Documents\Github"
if (!(Test-Path -Path $githubDirectory -PathType Container)) {
    New-Item -Path $githubDirectory -ItemType Directory | Out-Null
}


# Fungsi untuk membuka PowerShell sebagai administrator
function Run-As-Administrator {
    param([scriptblock]$ScriptBlock)
    Start-Process -FilePath powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command $($ScriptBlock | Out-String)" -Verb RunAs
}

# installer ke2

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



# Skrip untuk dijalankan sebagai administrator
$adminScript = {
# clone github repository
Set-Location -Path $env:userprofile\Documents\Github
git clone "https://github.com/rezapace/ps"
}

# Jalankan skrip sebagai administrator
Run-As-Administrator -ScriptBlock $adminScript
