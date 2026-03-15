# Release Assets

这个目录保存会被打包进 GitHub Release 的自定义文件。

当前约定：

- `root/` 下的文件会被复制到 Release 压缩包根目录
- 上游或本地生成的二进制成品不提交到仓库
- 运行成品由 `tools/package_release.ps1` 从本地素材目录组装
