@echo off
title ProctorAI - Development Mode
echo =====================================================================
echo                ProctorAI Full-Stack Development Mode
echo =====================================================================
echo.

cd /d "%~dp0"

echo 1. Starting FastAPI Backend Server on port 8000...
start cmd /k ".\venv\Scripts\activate.bat && python backend\run_backend.py"

timeout /t 3 /nobreak > nul

echo 2. Starting Vite React Frontend Dev Server on port 3000...
cd frontend
set "Path=C:\Program Files\nodejs;%Path%"
start cmd /k "npm run dev"

echo.
echo Application ready:
echo - Frontend Dev Server: http://localhost:3000
echo - Backend API & Docs: http://localhost:8000/docs
echo =====================================================================
