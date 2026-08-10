@echo off
setlocal
cd /d "%~dp0"
quarto render index.qmd --to html
if errorlevel 1 (
  echo.
  echo Rendering failed. Check that Quarto is installed.
  pause
  exit /b 1
)

cscript //nologo "%~dp0make-standalone.js" "%~dp0_output\authentication-quality-models.html"
if errorlevel 1 (
  echo.
  echo Standalone HTML processing failed.
  pause
  exit /b 1
)

move /Y "%~dp0_output\authentication-quality-models.html" "%~dp0_output\a-quality-model-for-authentication-solutions.html" >nul
if errorlevel 1 (
  echo.
  echo Renaming the rendered HTML failed.
  pause
  exit /b 1
)

if not exist "%~dp0docs" mkdir "%~dp0docs"
copy /Y "%~dp0_output\a-quality-model-for-authentication-solutions.html" "%~dp0docs\index.html" >nul
if errorlevel 1 (
  echo.
  echo Copying the HTML to docs\index.html failed.
  pause
  exit /b 1
)

start "" "%~dp0_output\a-quality-model-for-authentication-solutions.html"
endlocal
