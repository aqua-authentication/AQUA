@echo off
setlocal
cd /d "%~dp0"
where dot >nul 2>&1
if errorlevel 1 (
  echo Graphviz was not found.
  echo Install Graphviz and make sure dot.exe is on PATH.
  echo After installation, restart Visual Studio Code and try again.
  pause
  exit /b 1
)

echo Regenerating tree graphics...
dot -Tsvg "trees\solution-tree.dot" -o "figures\solution-tree.svg"
if errorlevel 1 goto :error
dot -Tsvg "trees\employment-tree.dot" -o "figures\employment-tree.svg"
if errorlevel 1 goto :error
dot -Tsvg "trees\authenticator-tree.dot" -o "figures\authenticator-tree.svg"
if errorlevel 1 goto :error
cscript //nologo "fix-tree-branches.js" "figures\solution-tree.svg" "figures\employment-tree.svg" "figures\authenticator-tree.svg"
if errorlevel 1 goto :error

echo.
echo Updated:
echo   figures\solution-tree.svg
echo   figures\employment-tree.svg
echo   figures\authenticator-tree.svg
echo.
echo Remember to render the HTML again after changing the trees.
pause
exit /b 0

:error
echo.
echo Graphviz reported an error. Check the .dot file named above for a missing quote, bracket, or table row.
pause
exit /b 1
