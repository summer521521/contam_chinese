# contam_chinese

Unofficial Chinese localization for CONTAM (based on CONTAM 3.4.0.8)

`contam_chinese` 是一个基于 NIST CONTAM 的非官方中文汉化仓库。公开仓库只保留汉化成果、帮助源码、发版素材和说明文档；最终给用户下载的 `zip` 或安装包仅通过 GitHub Releases 分发。

## 最推荐的发布方式

建议采用“仓库放汉化相关内容，Release 放可直接下载的成品”的方式：

- 仓库中保留：
  - `README.md`
  - `NOTICE.md`
  - `CHANGELOG.md`
  - 汉化资源、脚本、补丁说明
  - 帮助源码和构建链路
  - 截图
  - 安装和使用说明
- GitHub Releases 中提供：
  - 可直接下载的 zip 或安装包
  - 对应版本说明
  - 必要时提供校验值

当前仓库结构已经按这个方向整理：公开仓库不再提交运行成品，成品通过本地打包脚本生成到 `dist/` 后再上传到 Release。

## 来源与修改说明

本项目基于 NIST 官方发布的 CONTAM。

根据 CONTAM 官方文档/帮助中的免责声明说明，CONTAM 可被再分发和修改，但衍生作品应明确标注其源自 CONTAM，修改版本还应明确注明已经被修改。因此，这个仓库和任何 Release 页面都应该保留下面两类信息：

- 来源说明：基于 NIST CONTAM
- 修改说明：这是非官方中文汉化修改版

推荐固定写法：

`Based on CONTAM developed by NIST. This is an unofficial Chinese-localized modified distribution.`

同时，不要把该项目表述成 NIST 官方版本，也不要暗示获得 NIST 认可。

## 基底版本

截至 `2026-03-15`，NIST 官方下载页列出的最新发行版为 `CONTAM 3.4.0.8`，发布日期为 `2026-01-08`；该页同时说明随安装包附带的 `ContamX` 为 `3.4.0.3`。

本项目对应发布包中的主要程序文件版本如下：

- `contamw3_zh.exe`: `3.4.0.8`
- `contamx3.exe`: `3.4.0.3`
- `prjup.exe`: `3.4.0.3`
- `simread.exe`: `3.4.0.3`
- `simcomp.exe`: `3.4.0.3`

仓库描述推荐写为：

`Unofficial Chinese localization for CONTAM (based on CONTAM 3.4.0.8)`

仓库名称推荐使用：

`contam_chinese`

## 仓库内容

- `build_assets/`
  - 程序资源汉化文件、帮助翻译缓存与脚本
- `help_src/ContamHelp_zh_html/`
  - 中文帮助 HTML 源码与工程文件
- `release_assets/root/`
  - Release 包根目录要附带的自定义脚本与素材
- `tools/`
  - 中文帮助构建脚本、Release 打包脚本和依赖下载脚本
- `docs/`
  - 补充文档和 Release 模板
- `screenshots/`
  - README 和 Release 中要引用的截图

## 仓库不提交的内容

以下内容不再提交到公开仓库，而是通过本地脚本打包到 Release：

- `contamw3_zh.exe`
- `contamx3.exe`
- `prjup.exe`
- `simread.exe`
- `simcomp.exe`
- `olch2d32.dll`
- `ContamHelp.chm`
- Release 根目录下的运行包装文件

## 本地打包 Release

准备一个本地二进制素材目录，默认路径为：

- `local/release_seed/`

该目录中应放入：

- `contamw3_zh.exe`
- `contamx3.exe`
- `prjup.exe`
- `simread.exe`
- `simcomp.exe`
- `olch2d32.dll`

然后执行：

1. `tools/package_release.cmd`
2. 或 `powershell -ExecutionPolicy Bypass -File .\tools\package_release.ps1`

脚本会自动：

- 校验本地二进制素材
- 从 `help_src/` 重新构建 `ContamHelp.chm`
- 复制 `release_assets/root/` 中的包装脚本
- 复制 `NOTICE.md`
- 生成 `dist/contam_chinese_v3.4.0.8-zh.1.zip`
- 生成对应的 SHA-256 校验文件

## 构建中文 CHM

1. 运行 `tools/build_contam_help_zh.cmd`
2. 默认输出到 `local/build/ContamHelp.chm`

构建脚本会：

- 优先查找系统已安装的 `hhc.exe`
- 自动生成 `help_src/ContamHelp_zh_html/ContamHelp_zh.hhp`
- 将构建产物输出到本地忽略目录，避免把成品提交回仓库

如果本机没有 HTML Help Workshop，可参考：

- `tools/download_html_help_workshop.ps1`

该脚本默认只显示说明；加 `-UseMirror` 时才会从非微软镜像下载安装包。

## 关于 HTML Help Workshop

微软历史说明页：

- [Microsoft HTML Help Downloads](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/htmlhelp/microsoft-html-help-downloads)

截至 `2026-03-15`，该说明页仍可访问，但历史 `Htmlhelp.exe` 直链已经失效。因此，本仓库不建议附带 `hhc.exe` 一起公开分发。

## Release 建议包含的文件

建议把下面这些文件打包成 Release 附件：

- `contamw3_zh.exe`
- `ContamHelp.chm`
- `contamx3.exe`
- `prjup.exe`
- `simread.exe`
- `simcomp.exe`
- `olch2d32.dll`
- `PRJUP_PICKER.cmd`
- `SIMREAD_PICKER.cmd`
- `SIMCOMP_PICKER.cmd`
- `NOTICE.md`

建议不要把 HTML Help Workshop 编译器一起打包。

## 复现与维护

程序资源级汉化和帮助汉化的关键材料保留在：

- `build_assets/contamw3_v3.rc`
- `build_assets/translate_help_to_zh.py`
- `build_assets/ContamHelp_zh_html_translation_cache_zh.json`

如果后续你继续修改界面文本、帮助内容或打包方式，请同步更新：

- `NOTICE.md`
- `CHANGELOG.md`
- `docs/RELEASE_TEMPLATE.md`
- `tools/package_release.ps1`

## 参考链接

- [NIST CONTAM 下载页](https://www.nist.gov/el/energy-and-environment-division-73200/nist-multizone-modeling/software/contam/download)
- [NIST CONTAM 软件页（含许可说明）](https://www.nist.gov/services-resources/software/contam)
- [NIST TN 1887r1 文档](https://doi.org/10.6028/NIST.TN.1887r1)
