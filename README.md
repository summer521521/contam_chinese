# contam_chinese

Unofficial Chinese localization for CONTAM (based on CONTAM 3.4.0.8)

`contam_chinese` 提供 CONTAM 的非官方中文汉化版本。可直接使用的程序通过 GitHub Releases 分发；本仓库保留项目说明、版本记录和汉化资料。

## 下载

可直接运行的版本请从 GitHub Releases 下载压缩包。

当前 Release 包包含：

- `contamw3.exe`
- `ContamHelp.chm`
- `contamx3.exe`
- `prjup.exe`
- `simread.exe`
- `simcomp.exe`
- `olch2d32.dll`

## 使用方法

1. 下载并解压 Release 压缩包。
2. 运行 `contamw3.exe`。
3. 需要帮助文档时，打开 `ContamHelp.chm`。

## 来源与修改说明

本项目基于 NIST 官方发布的 CONTAM，仓库和 Release 均保留下列声明：

- `Based on CONTAM developed by NIST.`
- `This is an unofficial Chinese-localized modified distribution.`

本项目不是 NIST 官方发布版本，也不代表 NIST 认可。

## 基底版本

截至 `2026-03-16`，NIST 官方下载页列出的最新发行版为 `CONTAM 3.4.0.8`，发布日期为 `2026-01-08`；该页同时说明随安装包附带的 `ContamX` 为 `3.4.0.3`。

本项目对应发布包中的主要程序文件版本如下：

- `contamw3.exe`: `3.4.0.8`
- `contamx3.exe`: `3.4.0.3`
- `prjup.exe`: `3.4.0.3`
- `simread.exe`: `3.4.0.3`
- `simcomp.exe`: `3.4.0.3`

## 仓库内容

- `README.md`
  - 项目说明和下载指引
- `NOTICE.md`
  - 来源说明和修改说明
- `CHANGELOG.md`
  - 版本更新记录
- `build_assets/`
  - 程序资源汉化文件、翻译缓存与相关脚本
- `tools/`
  - 项目维护和打包脚本
- `docs/`
  - 补充文档和 Release 资料
- `screenshots/`
  - README 和 Release 中使用的截图

## 说明

本仓库的主要入口是：

- `README.md`
- GitHub Releases

可直接使用的程序通过 Release 下载；仓库中的其余内容用于保存项目资料和版本信息。

## 参考链接

- [NIST CONTAM 下载页](https://www.nist.gov/el/energy-and-environment-division-73200/nist-multizone-modeling/software/contam/download)
- [NIST CONTAM 软件页（含许可说明）](https://www.nist.gov/services-resources/software/contam)
- [NIST TN 1887r1 文档](https://doi.org/10.6028/NIST.TN.1887r1)
