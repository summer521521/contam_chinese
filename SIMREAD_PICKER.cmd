@echo off
setlocal

set "TARGET=%~1"
if not defined TARGET (
  for /f "usebackq delims=" %%I in (`powershell -NoProfile -STA -Command "Add-Type -AssemblyName System.Windows.Forms; $dlg=New-Object System.Windows.Forms.OpenFileDialog; $dlg.Filter='CONTAM SIM (*.sim)|*.sim|All files (*.*)|*.*'; $dlg.Multiselect=$false; if($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){$dlg.FileName}"`) do set "TARGET=%%I"
)

if not defined TARGET (
  echo No SIM file selected.
  pause
  exit /b 1
)

echo Reading: "%TARGET%"
echo.
echo Follow the prompts below. Output text files will be written next to the SIM file.
echo.
"%~dp0simread.exe" "%TARGET%"
echo.
pause
