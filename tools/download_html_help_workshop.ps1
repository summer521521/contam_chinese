param(
    [string]$Destination = (Join-Path $PSScriptRoot "downloads\\htmlhelp.exe"),
    [switch]$UseMirror
)

$ErrorActionPreference = "Stop"

$officialDocs = "https://learn.microsoft.com/en-us/previous-versions/windows/desktop/htmlhelp/microsoft-html-help-downloads"
$mirrorUrl = "https://raw.githubusercontent.com/EWSoftware/SHFB/master/ThirdPartyTools/htmlhelp.exe"

if (-not $UseMirror) {
    Write-Host "Official Microsoft docs:"
    Write-Host "  $officialDocs"
    Write-Host ""
    Write-Host "Microsoft's historical HTML Help Workshop download is no longer reliable."
    Write-Host "If you accept a non-Microsoft mirror, rerun:"
    Write-Host "  .\\tools\\download_html_help_workshop.ps1 -UseMirror"
    exit 1
}

$dir = Split-Path -Parent $Destination
New-Item -ItemType Directory -Force -Path $dir | Out-Null

Invoke-WebRequest -Uri $mirrorUrl -OutFile $Destination
Write-Host "Downloaded to: $Destination"
Write-Host "Run the installer, then rerun .\\tools\\build_contam_help_zh.ps1"
