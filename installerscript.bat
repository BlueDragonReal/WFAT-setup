@echo off
setlocal

REM Check if Git is already installed
git --version > nul 2>&1
if %errorlevel% EQU 0 (
    echo Git is already installed.
    goto continue_script
)

REM Define the URL for Git installer
set "git_installer_url=https://github.com/git-for-windows/git/releases/download/v2.33.0.windows.2/Git-2.33.0.2-64-bit.exe"

REM Define the installation path (adjust as needed)
set "install_path=C:\Program Files\Git"

REM Download Git installer
echo Downloading Git installer...
curl -L -o git_installer.exe "%git_installer_url%"

REM Install Git
echo Installing Git...
start /wait git_installer.exe /VERYSILENT /NORESTART /NOCANCEL /DIR="%install_path%"

REM Clean up downloaded installer
del git_installer.exe

echo Git installation completed.

:continue_script

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

REM Install Python 3.11 if not already installed
python --version 2>nul
if %errorlevel% NEQ 0 (
    echo Installing Python 3.11...
    start /wait "" "https://www.python.org/ftp/python/3.11.0/python-3.11.0-amd64.exe" /quiet
)

REM Install Node.js if not already installed
node --version 2>nul
if %errorlevel% NEQ 0 (
    echo Installing Node.js...
    start /wait "" "https://nodejs.org/dist/v14.17.6/node-v14.17.6-x64.msi" /quiet
)

REM Activate Python virtual environment
cd "%repo_dir%\Warframe-Algo-Trader"
if not exist "venv\Scripts\activate" (
    python -m venv venv
)
call venv\Scripts\activate

REM Install required Python packages
python -m pip install -r requirements.txt

REM Run init.py to initialize the database
python init.py

REM Deactivate Python virtual environment
deactivate

REM Run npm install manually
cd "%repo_dir%\Warframe-Algo-Trader\frontend"
npm install

REM Re-activate Python virtual environment
call venv\Scripts\activate

REM Run startAll.bat
cd "%repo_dir%\Warframe-Algo-Trader"
call startAll.bat

REM Restore the previous environment
endlocal
pause
