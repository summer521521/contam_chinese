@echo off
setlocal

set "TARGET=%~1"
if not defined TARGET (
  for /f "usebackq delims=" %%I in (`powershell -NoProfile -STA -Command "Add-Type -AssemblyName System.Windows.Forms; $dlg=New-Object System.Windows.Forms.OpenFileDialog; $dlg.Filter='CONTAM PRJ (*.prj)|*.prj|All files (*.*)|*.*'; $dlg.Multiselect=$false; if($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){$dlg.FileName}"`) do set "TARGET=%%I"
)

if not defined TARGET (
  echo No PRJ file selected.
  pause
  exit /b 1
)

echo Upgrading: "%TARGET%"
echo.
"%~dp0prjup.exe" "%TARGET%"
echo.
pause
