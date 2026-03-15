# CONTAM_zh

这个目录是整理后的中文化分发目录，目标是：

- 直接运行中文界面的 CONTAM
- 保留中文帮助源码
- 保留 `ContamHelp_zh.chm` 的构建链路
- 保留资源级汉化和帮助汉化的核心复现材料

## 目录结构

- 根目录
  - 可直接双击的运行文件
  - 主程序：`contamw3_zh.exe`
  - 中文帮助：`ContamHelp_zh.chm`
  - 运行时帮助：`ContamHelp.chm`
  - 原始命令行工具：`prjup.exe`、`simread.exe`、`simcomp.exe`
  - 双击包装器：`PRJUP_PICKER.cmd`、`SIMREAD_PICKER.cmd`、`SIMCOMP_PICKER.cmd`
- `help_src/ContamHelp_zh_html/`
  - 中文帮助 HTML 源码
  - 可以直接打开 `html/Introduction/Cover.htm`
- `tools/`
  - `build_contam_help_zh.ps1`：生成 `ContamHelp_zh.chm`
  - `build_contam_help_zh.cmd`：上面脚本的双击入口
  - `download_html_help_workshop.ps1`：下载 HTML Help Workshop 的兜底脚本
- `build_assets/`
  - 程序汉化资源、帮助翻译缓存与脚本
- `docs/`
  - 补充文档 PDF

## 直接使用

直接双击根目录下的 `contamw3_zh.exe` 即可。

帮助可直接双击：

- `ContamHelp_zh.chm`
- `ContamHelp.chm`

三个命令行工具本身不是窗口程序，直接双击通常会一闪而过。要双击使用，请改用：

- `PRJUP_PICKER.cmd`
- `SIMREAD_PICKER.cmd`
- `SIMCOMP_PICKER.cmd`

如果只是查看中文帮助源码，不等 CHM，直接打开 `help_src/ContamHelp_zh_html/html/Introduction/Cover.htm`。

## 构建 ContamHelp_zh.chm

1. 直接运行 `tools/build_contam_help_zh.cmd`
2. 成功后会生成：
   - `ContamHelp_zh.chm`
   - `ContamHelp.chm`

说明：

- 脚本会优先查找系统已安装的 `hhc.exe`
- 如果没装 HTML Help Workshop，可以运行 `tools/download_html_help_workshop.ps1 -UseMirror`
- 构建脚本会自动生成 `help_src/ContamHelp_zh_html/ContamHelp_zh.hhp`
- 构建完成后会把中文 CHM 同步复制为根目录运行时帮助 `ContamHelp.chm`
- 这样程序里点击帮助时就会优先打开中文 CHM

## 关于 HTML Help Workshop

官方说明页：

- <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/htmlhelp/microsoft-html-help-downloads>

注意：

- 截至 `2026-03-15`，上面这个微软说明页还能打开，但页内历史 `Download Htmlhelp.exe` 直链已经返回 `404`
- 这不是你本地的问题，是微软旧下载资源本身已经失效

如果你想重新从微软安装包恢复编译器，可以看：

- `tools/download_html_help_workshop.ps1`

这个脚本默认只显示说明；加 `-UseMirror` 后才会从非微软镜像下载安装包。

## 关于发布

- `CONTAM` 主程序资源里标注为 `Public Domain Software`
- 中文帮助里的免责声明页也写明 `CONTAM` 可自由再分发和修改，但修改版应注明已修改
- 微软的 HTML Help Workshop 编译器不建议和这个目录一起公开分发

因此，这个目录默认不再附带 `hhc.exe`。你公开发布时直接发布当前目录即可；如果以后要重建 `CHM`，再按上面的脚本单独下载安装编译器。

## 复现说明

程序资源级汉化和帮助汉化相关材料保留在 `build_assets/` 中，包括：

- `contamw3_v3.rc`
- `translate_help_to_zh.py`
- `ContamHelp_zh_html_translation_cache_zh.json`

## 发布到 GitHub

1. 打开 GitHub，新建一个空仓库，不要勾选自动生成 `README`。
2. 在 PowerShell 进入这个目录：
   `cd C:\Users\shijinyu\Desktop\CONTAM_zh`
3. 初始化并首次提交：
   `git init -b main`
   `git add .`
   `git commit -m "Initial CONTAM zh package"`
4. 绑定你新建的 GitHub 仓库：
   `git remote add origin https://github.com/你的用户名/你的仓库名.git`
5. 推送：
   `git push -u origin main`

如果 GitHub 提示登录，按浏览器提示完成授权即可。

## 当前状态

- 中文程序：已完成，可运行
- 中文 HTML 帮助：已完成，可直接打开
- 中文 CHM：已生成，位于根目录 `ContamHelp_zh.chm`
