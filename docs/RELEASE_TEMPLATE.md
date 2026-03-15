# GitHub Release Template

## Suggested Tag

`v3.4.0.8-zh.1`

## Suggested Title

`contam_chinese v3.4.0.8-zh.1`

## Suggested Repository Description

`Unofficial Chinese localization for CONTAM (based on CONTAM 3.4.0.8)`

## Release Notes Template

```md
Unofficial Chinese localization for CONTAM, based on CONTAM 3.4.0.8.

Source notice:
Based on CONTAM developed by NIST.

Modification notice:
This is an unofficial Chinese-localized modified distribution.

Included in this release:
- contamw3_zh.exe
- ContamHelp.chm
- contamx3.exe
- prjup.exe
- simread.exe
- simcomp.exe
- olch2d32.dll
- PRJUP_PICKER.cmd
- SIMREAD_PICKER.cmd
- SIMCOMP_PICKER.cmd
- NOTICE.md

Quick start:
1. Download and extract the zip package.
2. Run contamw3_zh.exe.
3. Open ContamHelp.chm for the Chinese help file.

Notes:
- This is not an official NIST release.
- If you need to rebuild the CHM help file, HTML Help Workshop is not bundled in this release.
```

## Suggested Asset Checklist

- `contam_chinese_v3.4.0.8-zh.1.zip`
- Optional checksum file such as `SHA256SUMS.txt`

## Pre-Release Check

- `README.md` 已更新
- `NOTICE.md` 已保留来源和修改说明
- `CHANGELOG.md` 已更新到本次版本
- 仓库中未提交 `exe/chm/dll` 成品
- Release 页面已写明 `based on CONTAM 3.4.0.8`
- Release 页面已写明“非官方中文汉化修改版”
- 压缩包内包含 `NOTICE.md`
