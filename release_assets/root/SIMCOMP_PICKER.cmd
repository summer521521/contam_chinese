@echo off
setlocal

set "FILE1=%~1"
set "FILE2=%~2"

if not defined FILE1 (
  for /f "usebackq delims=" %%I in (`powershell -NoProfile -STA -Command "Add-Type -AssemblyName System.Windows.Forms; $dlg=New-Object System.Windows.Forms.OpenFileDialog; $dlg.Filter='CONTAM SIM (*.sim)|*.sim|All files (*.*)|*.*'; $dlg.Title='Select first SIM file'; $dlg.Multiselect=$false; if($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){$dlg.FileName}"`) do set "FILE1=%%I"
)

if not defined FILE2 (
  for /f "usebackq delims=" %%I in (`powershell -NoProfile -STA -Command "Add-Type -AssemblyName System.Windows.Forms; $dlg=New-Object System.Windows.Forms.OpenFileDialog; $dlg.Filter='CONTAM SIM (*.sim)|*.sim|All files (*.*)|*.*'; $dlg.Title='Select second SIM file'; $dlg.Multiselect=$false; if($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){$dlg.FileName}"`) do set "FILE2=%%I"
)

if not defined FILE1 (
  echo First SIM file not selected.
  pause
  exit /b 1
)

if not defined FILE2 (
  echo Second SIM file not selected.
  pause
  exit /b 1
)

set "LEVEL="
set /p LEVEL=Comparison detail level [0-3, default 1]:
if not defined LEVEL set "LEVEL=1"

echo Comparing:
echo   "%FILE1%"
echo   "%FILE2%"
echo.
"%~dp0simcomp.exe" "%FILE1%" "%FILE2%" %LEVEL%
echo.
pause
