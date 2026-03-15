# NOTICE

## 项目身份

本仓库是一个基于 NIST CONTAM 的非官方中文汉化修改版。
公开仓库只保留汉化成果、说明文件和发版脚本；可运行成品通过 GitHub Releases 分发。

建议在仓库首页、Release 页面和压缩包说明中固定保留以下两句话：

- `Based on CONTAM developed by NIST.`
- `This is an unofficial Chinese-localized modified distribution.`

## 上游来源

原始软件：

- 名称：`CONTAM`
- 发布方：美国国家标准与技术研究院 `NIST`
- 官方下载页：<https://www.nist.gov/el/energy-and-environment-division-73200/nist-multizone-modeling/software/contam/download>
- 许可说明页：<https://www.nist.gov/services-resources/software/contam>
- 参考文档：<https://doi.org/10.6028/NIST.TN.1887r1>

根据 CONTAM 官方帮助/文档中的免责声明说明：

- 软件由 NIST 联邦雇员在执行公务期间开发
- 在美国法下，上游 CONTAM 软件属于联邦政府作品
- 软件可以被再分发和修改
- 但衍生作品应注明源自 CONTAM
- 修改版本应明确注明已经被修改

本 NOTICE 的目的就是把这两点在仓库和二次发布中固定下来：一是说明来源，二是说明这是修改版。

截至 `2026-03-15`，NIST 官方下载页列出的最新 CONTAM 发行版为 `3.4.0.8`，发布日期为 `2026-01-08`；该下载页同时注明安装包附带的 `ContamX` 版本为 `3.4.0.3`。

## 本仓库中的修改

当前仓库包含的主要修改或新增内容如下：

- `contamw3_zh.exe` 的中文界面资源汉化
- 中文帮助文件 `ContamHelp.chm`
- 中文帮助 HTML 源码与构建工程
- 构建中文帮助所需脚本
- `prjup.exe`、`simread.exe`、`simcomp.exe` 的双击包装器
- 公开发布所需的 README、CHANGELOG、Release 模板等说明文件

目前没有在本 NOTICE 中声明对原始数值求解算法进行了修改。

## 当前二进制版本标识

本项目发布包中的版本信息如下：

- `contamw3_zh.exe`: `3.4.0.8`
- `contamx3.exe`: `3.4.0.3`
- `prjup.exe`: `3.4.0.3`
- `simread.exe`: `3.4.0.3`
- `simcomp.exe`: `3.4.0.3`

在 README、Release 标题或说明中，建议把基底版本写成：

- `based on CONTAM 3.4.0.8`

## 再分发时的最低保留要求

无论是公开仓库还是打包成 zip/安装包，建议至少保留以下内容：

- 本文件 `NOTICE.md`
- 对 NIST CONTAM 的来源说明
- “这是非官方中文汉化修改版”的修改说明
- 不得表述为 NIST 官方发布版本
- 公开仓库中不必提交编译后的 `exe/chm/dll` 成品

## 第三方与原始声明

CONTAM 官方帮助中还包含诸如 SUNDIALS/CVODE 等上游组件的原始声明。若你继续再分发相关程序或帮助文件，不要移除这些原始声明和免责声明。

## 额外说明

本文件用于保留上游来源与修改说明；它本身不是你新增翻译、脚本或文档内容的单独许可证声明。如果你希望明确授权他人复用你新增的中文翻译和仓库文件，建议另行添加一个适用于你自有贡献的 `LICENSE` 文件。
