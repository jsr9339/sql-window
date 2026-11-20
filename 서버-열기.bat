@echo off
cd /d "%~dp0"
echo Starting server on port 8000. Closing this window stops the server.
echo Open http://localhost:8000 in your browser.
start "" http://localhost:8000
"%LOCALAPPDATA%\Programs\Python\Python312\python.exe" -m http.server 8000
pause
