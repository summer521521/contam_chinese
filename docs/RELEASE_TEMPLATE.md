# GitHub Release Template

This document records the release format used by this project.

## Tag

`v3.4.0.8-zh.1`

## Title

`contam_chinese v3.4.0.8-zh.1`

## Repository Description

`Unofficial Chinese localization for CONTAM (based on CONTAM 3.4.0.8)`

## Release Notes Template

```md
Unofficial Chinese localization for CONTAM, based on CONTAM 3.4.0.8.

Source notice:
Based on CONTAM developed by NIST.

Modification notice:
This is an unofficial Chinese-localized modified distribution.

Included in this release:
- contamw3.exe
- ContamHelp.chm
- contamx3.exe
- olch2d32.dll
- prjup.exe
- simread.exe
- simcomp.exe

Quick start:
1. Download and extract the zip package.
2. Run contamw3.exe.
3. Open ContamHelp.chm for the Chinese help file.

Notes:
- This is not an official NIST release.
- If you need to rebuild the CHM help file, HTML Help Workshop is not bundled in this release.
```

## Asset Checklist

- `contam_chinese_v3.4.0.8-zh.1.zip`
- Optional checksum file such as `SHA256SUMS.txt`

## Pre-Release Check

- `README.md` reflects the current release
- `NOTICE.md` retains source and modification notice
- `CHANGELOG.md` records the current version
- The repository does not include release `exe/chm/dll` binaries
- `local/release_seed/` contains the final release files
- The Release page states `based on CONTAM 3.4.0.8`
- The Release page states that this is an unofficial Chinese-localized modified distribution
