@echo off
setlocal
cd /d "%~dp0"

where quarto >nul 2>&1
if errorlevel 1 (
  echo.
  echo Rendering failed. Quarto is not installed or not available in PATH.
  pause
  exit /b 1
)

quarto render --to html
if errorlevel 1 (
  echo.
  echo Rendering failed.
  pause
  exit /b 1
)

rem Public pages currently enabled. To restore prediction models, append
rem prediction-models.html to HTML_FILES and re-enable its copy below.
set "HTML_FILES=authentication-quality-models.html definitional-models.html"
rem set "HTML_FILES=%HTML_FILES% prediction-models.html"

for %%F in (%HTML_FILES%) do (
  if not exist "%~dp0_output\%%~F" (
    echo.
    echo Expected rendered file not found: _output\%%~F
    pause
    exit /b 1
  )

  cscript //nologo "%~dp0make-standalone.js" "%~dp0_output\%%~F"
  if errorlevel 1 (
    echo.
    echo Standalone HTML processing failed for %%~F.
    pause
    exit /b 1
  )
)

if not exist "%~dp0docs" mkdir "%~dp0docs"

rem Keep the canonical landing-page filename as well as index.html so the
rem persistent cross-page navigation works in both _output and docs.
copy /Y "%~dp0_output\authentication-quality-models.html" "%~dp0docs\authentication-quality-models.html" >nul
if errorlevel 1 (
  echo.
  echo Copying authentication-quality-models.html failed.
  pause
  exit /b 1
)

copy /Y "%~dp0_output\authentication-quality-models.html" "%~dp0docs\index.html" >nul
if errorlevel 1 (
  echo.
  echo Copying the landing page to docs\index.html failed.
  pause
  exit /b 1
)

copy /Y "%~dp0_output\definitional-models.html" "%~dp0docs\definitional-models.html" >nul
if errorlevel 1 (
  echo.
  echo Copying definitional-models.html failed.
  pause
  exit /b 1
)

rem Prediction models are intentionally not published for now.
rem copy /Y "%~dp0_output\prediction-models.html" "%~dp0docs\prediction-models.html" >nul

echo.
echo HTML successfully created:
echo %~dp0_output\authentication-quality-models.html
echo %~dp0_output\definitional-models.html
rem echo %~dp0_output\prediction-models.html
echo.
echo GitHub Pages copies updated in:
echo %~dp0docs

start "" "%~dp0_output\authentication-quality-models.html"

endlocal
