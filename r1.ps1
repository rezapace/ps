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
