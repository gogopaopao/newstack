@echo off
setlocal

cd /d "%~dp0"

echo [1/5] git init
git init
powershell -NoProfile -Command "Start-Sleep -Milliseconds 300"

echo [2/5] git add .
git add .
powershell -NoProfile -Command "Start-Sleep -Milliseconds 300"

echo [3/5] git commit -m "%date% %time%"
git commit -m "%date% %time%"
powershell -NoProfile -Command "Start-Sleep -Milliseconds 300"

echo [4/5] git branch -M main
git branch -M main
powershell -NoProfile -Command "Start-Sleep -Milliseconds 300"

echo [5/5] git push -u origin main
git push -u origin main

echo.
echo Done.
pause
