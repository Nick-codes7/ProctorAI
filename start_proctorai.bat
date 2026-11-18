@echo off
title ProctorAI - AI-Powered Online Examination Proctoring Platform
echo =====================================================================
echo                     ProctorAI Web Platform
echo           AI-Powered Online Examination Proctoring System
echo =====================================================================
echo.

cd /d "%~dp0"

echo Activating Python virtual environment...
call .\venv\Scripts\activate.bat

echo Starting FastAPI Backend & Web Application on http://localhost:8000...
start "" "http://localhost:8000"
python backend\run_backend.py

pause
