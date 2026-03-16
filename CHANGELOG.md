# Changelog

This file records notable changes to this project.

This project uses the version format `v<上游版本>-zh.<修订号>`，例如：

- `v3.4.0.8-zh.1`

## [Unreleased]

- 待记录

## [3.4.0.8-zh.1] - 2026-03-15

### Added

- 标准仓库入口文件：`README.md`、`NOTICE.md`、`CHANGELOG.md`
- GitHub Release 说明模板：`docs/RELEASE_TEMPLATE.md`
- 截图占位目录：`screenshots/`
- 中文帮助 HTML 源码与构建链路
- Release 打包脚本：`tools/package_release.ps1`、`tools/package_release.cmd`

### Changed

- 将项目定位明确为“基于 NIST CONTAM 的非官方中文汉化修改版”
- 将仓库推荐名称明确为 `contam_chinese`
- 将仓库推荐描述明确为 `Unofficial Chinese localization for CONTAM (based on CONTAM 3.4.0.8)`
- 将基底主程序版本明确记录为 `3.4.0.8`
- 将当前附带工具版本明确记录为 `3.4.0.3`
- 将中文帮助构建产物改为输出到本地忽略目录
- 将公开仓库结构改为“不提交运行成品，只保留汉化成果和文档”
- 将发布主程序文件名统一为 `contamw3.exe`
- 将 Release 打包简化为“直接压缩 `local/release_seed/` 中的成品文件”

### Notes

- GitHub Releases 作为最终 zip 或安装包的分发入口。
- 本文件与 `NOTICE.md` 记录项目版本与发布信息。
