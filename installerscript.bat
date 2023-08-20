@echo off
setlocal

REM Set the installation directory to the user's home directory
set "repo_dir=%USERPROFILE%\algo-trader"
mkdir "%repo_dir%" 2>nul
cd /d "%repo_dir%"

REM Clone the Git repository into the specified directory
set "repo_url=https://github.com/akmayer/Warframe-Algo-Trader"
if exist "%repo_dir%\Warframe-Algo-Trader" (
    echo Repository is already cloned in %repo_dir%\Warframe-Algo-Trader.
) else (
    echo Cloning the Git repository into %repo_dir%\Warframe-Algo-Trader...
    git clone "%repo_url%"
)

REM Check for Python installation
where python > nul 2>&1
if %errorlevel% NEQ 0 (
    echo Python is not installed. Installing Python 3.11...
    start /wait "" "https://www.python.org/ftp/python/3.11.0/python-3.11.0-amd64.exe" /quiet
)

REM Check for Git installation
where git > nul 2>&1
if %errorlevel% NEQ 0 (
    echo Git is not installed. Please install Git and rerun this script.
    pause
    exit /b 1
)

REM Check for Node.js installation
where node > nul 2>&1
if %errorlevel% NEQ 0 (
    echo Node.js is not installed. Please install Node.js and rerun this script.
    pause
    exit /b 1
)

REM Activate Python virtual environment
cd "%repo_dir%\Warframe-Algo-Trader"
if not exist "venv\Scripts\activate" (
    python -m venv venv
)
call venv\Scripts\activate

REM Install required Python packages
python -m pip install -r requirements.txt

REM Rest of your script...

REM Deactivate Python virtual environment
deactivate

REM Restore the previous environment
endlocal
