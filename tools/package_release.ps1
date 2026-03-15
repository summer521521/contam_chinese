param(
    [string]$RootDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
    [string]$BinarySourceDir,
    [string]$Version = "3.4.0.8-zh.1",
    [string]$OutDir,
    [string]$HhcPath
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
$stageDir = Join-Path $distDir "${releaseName}_stage"
$packageDir = Join-Path $stageDir $releaseName
$zipPath = Join-Path $distDir "$releaseName.zip"
$checksumPath = Join-Path $distDir "$releaseName.sha256.txt"
$helpOutput = Join-Path $packageDir "ContamHelp.chm"
$releaseAssetsDir = Join-Path $root "release_assets\\root"

$requiredSourceFiles = @(
    "contamw3_zh.exe",
    "contamx3.exe",
    "prjup.exe",
    "simread.exe",
    "simcomp.exe",
    "olch2d32.dll"
)

if (-not (Test-Path $sourceDir)) {
    throw "Binary source directory not found: $sourceDir"
}

if (-not (Test-Path $releaseAssetsDir)) {
    throw "Release assets directory not found: $releaseAssetsDir"
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

if (Test-Path $stageDir) {
    Remove-Item $stageDir -Recurse -Force
}

if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

if (Test-Path $checksumPath) {
    Remove-Item $checksumPath -Force
}

New-Item -ItemType Directory -Force -Path $packageDir | Out-Null

foreach ($name in $requiredSourceFiles) {
    Copy-Item (Join-Path $sourceDir $name) (Join-Path $packageDir $name) -Force
}

Copy-Item (Join-Path $releaseAssetsDir "*") $packageDir -Recurse -Force
Copy-Item (Join-Path $root "NOTICE.md") (Join-Path $packageDir "NOTICE.md") -Force

$helpScript = Join-Path $PSScriptRoot "build_contam_help_zh.ps1"
& $helpScript `
    -RootDir $root `
    -HhcPath $HhcPath `
    -OutputPath $helpOutput

if ($LASTEXITCODE -ne 0 -or -not (Test-Path $helpOutput)) {
    if (Test-Path $stageDir) {
        Remove-Item $stageDir -Recurse -Force
    }
    throw "Release packaging stopped because ContamHelp.chm was not built successfully."
}

Compress-Archive -Path $packageDir -DestinationPath $zipPath -CompressionLevel Optimal

$hash = (Get-FileHash $zipPath -Algorithm SHA256).Hash.ToLowerInvariant()
[System.IO.File]::WriteAllText(
    $checksumPath,
    "$hash *$([System.IO.Path]::GetFileName($zipPath))`r`n",
    [System.Text.Encoding]::ASCII
)

Write-Host "Package directory: $packageDir"
Write-Host "ZIP: $zipPath"
Write-Host "SHA256: $checksumPath"
