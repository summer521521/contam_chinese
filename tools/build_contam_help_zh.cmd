@echo off
setlocal
powershell -ExecutionPolicy Bypass -File "%~dp0build_contam_help_zh.ps1" %*
endlocal
