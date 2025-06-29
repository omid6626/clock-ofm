@echo off
echo ===================================
echo RGB Controller App Installer
echo ===================================

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed. Please install Node.js first.
    echo Visit: https://nodejs.org/
    pause
    exit /b 1
)

echo ✅ Node.js detected
node --version

REM Check if npm is installed
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm is not installed. Please install npm first.
    pause
    exit /b 1
)

echo ✅ npm detected

REM Install dependencies
echo 📦 Installing dependencies...
npm install
if %errorlevel% neq 0 (
    echo ❌ Failed to install dependencies
    pause
    exit /b 1
)

echo ✅ Dependencies installed successfully

REM Setup database if DATABASE_URL exists
if defined DATABASE_URL (
    echo 🗄️ Setting up database...
    npm run db:push
    if %errorlevel% equ 0 (
        echo ✅ Database setup completed
    ) else (
        echo ⚠️ Database setup failed, using in-memory storage
    )
) else (
    echo ⚠️ No DATABASE_URL provided, using in-memory storage
)

REM Build the application
echo 🔨 Building application...
npm run build
if %errorlevel% neq 0 (
    echo ❌ Build failed
    pause
    exit /b 1
)

echo ✅ Build completed successfully

REM Create start script
echo @echo off > start.bat
echo echo Starting RGB Controller App... >> start.bat
echo npm start >> start.bat

echo.
echo ===================================
echo ✅ Installation completed successfully!
echo ===================================
echo.
echo To start the application:
echo   start.bat
echo.
echo Or manually run:
echo   npm start
echo.
echo The app will be available at:
echo   http://localhost:5000
echo.
echo ===================================
pause