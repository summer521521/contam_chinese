param(
    [string]$RootDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
    [string]$BinarySourceDir,
    [string]$Version = "3.4.0.8-zh.1",
    [string]$OutDir
)

$ErrorActionPreference = "Stop"

$root = (Resolve-Path $RootDir).Path
$sourceDir = if ($BinarySourceDir) {
    [System.IO.Path]::GetFullPath($BinarySourceDir)
} else {
    Join-Path $root "local\\release_seed"
}
$distDir = if ($OutDir) {
    [System.IO.Path]::GetFullPath($OutDir)
} else {
    Join-Path $root "dist"
}
$releaseName = "contam_chinese_v$Version"
$zipPath = Join-Path $distDir "$releaseName.zip"
$checksumPath = Join-Path $distDir "$releaseName.sha256.txt"

$requiredSourceFiles = @(
    "contamw3.exe",
    "ContamHelp.chm",
    "contamx3.exe",
    "prjup.exe",
    "simread.exe",
    "simcomp.exe",
    "olch2d32.dll"
)

if (-not (Test-Path $sourceDir)) {
    throw "Binary source directory not found: $sourceDir"
}

$missing = @()
foreach ($name in $requiredSourceFiles) {
    $path = Join-Path $sourceDir $name
    if (-not (Test-Path $path)) {
        $missing += $name
    }
}

if ($missing.Count -gt 0) {
    throw "Missing required release files in $sourceDir : $($missing -join ', ')"
}

if (-not (Test-Path $distDir)) {
    New-Item -ItemType Directory -Force -Path $distDir | Out-Null
}

if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

if (Test-Path $checksumPath) {
    Remove-Item $checksumPath -Force
}

$filesToArchive = Get-ChildItem -Path $sourceDir -File | Sort-Object Name
if ($filesToArchive.Count -eq 0) {
    throw "No files found in $sourceDir"
}

Compress-Archive -LiteralPath $filesToArchive.FullName -DestinationPath $zipPath -CompressionLevel Optimal

$hash = (Get-FileHash $zipPath -Algorithm SHA256).Hash.ToLowerInvariant()
[System.IO.File]::WriteAllText(
    $checksumPath,
    "$hash *$([System.IO.Path]::GetFileName($zipPath))`r`n",
    [System.Text.Encoding]::ASCII
)

Write-Host "Source directory: $sourceDir"
Write-Host "ZIP: $zipPath"
Write-Host "SHA256: $checksumPath"
