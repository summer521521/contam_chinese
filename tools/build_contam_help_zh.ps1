param(
    [string]$RootDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
    [string]$HhcPath
)

$ErrorActionPreference = "Stop"

function Resolve-HhcPath {
    param([string]$Preferred)

    if ($Preferred -and (Test-Path $Preferred)) {
        return (Resolve-Path $Preferred).Path
    }

    $candidates = @(
        (Join-Path $PSScriptRoot "hhw_extract\\hhc.exe"),
        (Join-Path ${env:ProgramFiles(x86)} "HTML Help Workshop\\hhc.exe"),
        (Join-Path $env:ProgramFiles "HTML Help Workshop\\hhc.exe"),
        (Join-Path ${env:ProgramFiles(x86)} "Microsoft HTML Help Workshop\\hhc.exe"),
        (Join-Path $env:ProgramFiles "Microsoft HTML Help Workshop\\hhc.exe")
    ) | Where-Object { $_ }

    foreach ($item in $candidates) {
        if (Test-Path $item) {
            return (Resolve-Path $item).Path
        }
    }

    return $null
}

function Get-RelativePath {
    param(
        [string]$BasePath,
        [string]$TargetPath
    )

    $base = [System.Uri]((Resolve-Path $BasePath).Path.TrimEnd('\') + '\')
    $target = [System.Uri](Resolve-Path $TargetPath).Path
    return $base.MakeRelativeUri($target).ToString().Replace('/', '\')
}

function Get-Gb18030Encoding {
    return [System.Text.Encoding]::GetEncoding(54936)
}

function Write-TextFile {
    param(
        [string]$Path,
        [string]$Content,
        [System.Text.Encoding]$Encoding
    )

    $dir = Split-Path -Parent $Path
    if ($dir -and -not (Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }

    $writer = New-Object System.IO.StreamWriter($Path, $false, $Encoding)
    try {
        $writer.Write($Content)
    }
    finally {
        $writer.Dispose()
    }
}

function Convert-ChmTextFile {
    param([string]$Path)

    $utf8 = New-Object System.Text.UTF8Encoding($false)
    $gb = Get-Gb18030Encoding
    $content = [System.IO.File]::ReadAllText($Path, $utf8)
    $content = [regex]::Replace($content, '^\s*<\?xml[^>]+\?>\s*', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $content = [regex]::Replace($content, 'charset\s*=\s*UTF-8', 'charset=gb18030', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    Write-TextFile -Path $Path -Content $content -Encoding $gb
}

$root = (Resolve-Path $RootDir).Path
$helpSourceDir = Join-Path $root "help_src\\ContamHelp_zh_html"
$buildAssetsDir = Join-Path $root "build_assets"
$compiledFile = Join-Path $root "ContamHelp.chm"

if (-not (Test-Path $helpSourceDir)) {
    throw "Help source not found: $helpSourceDir"
}

$hhc = Resolve-HhcPath -Preferred $HhcPath
if (-not $hhc) {
    Write-Host @"
hhc.exe not found.

Install Microsoft HTML Help Workshop first, then rerun this script.
Docs: https://learn.microsoft.com/en-us/previous-versions/windows/desktop/htmlhelp/microsoft-html-help-downloads
Optional mirror helper: .\\tools\\download_html_help_workshop.ps1 -UseMirror
"@
    exit 1
}

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$stageDir = Join-Path $buildAssetsDir "help_chm_stage_$stamp"
$stageSourceDir = Join-Path $stageDir "ContamHelp_zh_html"
$projectFile = Join-Path $stageSourceDir "ContamHelp_zh.hhp"

New-Item -ItemType Directory -Force -Path $stageDir | Out-Null
Copy-Item $helpSourceDir $stageSourceDir -Recurse -Force

Get-ChildItem -Path $stageSourceDir -Recurse -File -Include *.htm,*.hhc,*.hhk |
    ForEach-Object {
        Convert-ChmTextFile -Path $_.FullName
    }

$compiledRelPath = Get-RelativePath -BasePath $stageSourceDir -TargetPath $compiledFile

$files = Get-ChildItem -Path $stageSourceDir -Recurse -File |
    Where-Object {
        $_.Name -ne "ContamHelp_zh.hhp" -and
        $_.Extension -ne ".bak"
    } |
    Sort-Object FullName |
    ForEach-Object {
        Get-RelativePath -BasePath $stageSourceDir -TargetPath $_.FullName
    }

$project = @"
[OPTIONS]
Compatibility=1.1 or later
Compiled file=$compiledRelPath
Contents file=_Temp.hhc
Index file=_Temp.hhk
Default Window=main
Default topic=html\Introduction\Cover.htm
Display compile progress=Yes
Full-text search=Yes
Language=0x804 Chinese (Simplified, PRC)
Title=CONTAM Help zh-CN
Binary TOC=No
Flat=No

[WINDOWS]
main="CONTAM Help zh-CN","_Temp.hhc","_Temp.hhk","html\Introduction\Cover.htm","html\Introduction\Cover.htm",,,,,0x23520,220,0x384e,[10,10,980,720],,,,,,,0

[FILES]
$($files -join "`r`n")
"@

Set-Content -Path $projectFile -Value $project -Encoding ASCII

Push-Location $stageSourceDir
try {
    & $hhc $projectFile | Out-Host
}
finally {
    Pop-Location
}

if (-not (Test-Path $compiledFile)) {
    throw "CHM build failed. Expected output not found: $compiledFile"
}

Write-Host "Built: $compiledFile"
Write-Host "Stage: $stageSourceDir"
