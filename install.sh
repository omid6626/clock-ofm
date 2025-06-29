#!/bin/bash

# RGB Controller App Installer
echo "==================================="
echo "RGB Controller App Installer"
echo "==================================="

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    echo "Visit: https://nodejs.org/"
    exit 1
fi

# Check Node.js version
node_version=$(node -v | cut -d'v' -f2)
required_version="18.0.0"

if ! node -pe "require('semver').gte('$node_version', '$required_version')" 2>/dev/null; then
    echo "❌ Node.js version $node_version is not supported. Please install Node.js 18 or higher."
    exit 1
fi

echo "✅ Node.js version $node_version detected"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

echo "✅ npm detected"

# Install dependencies
echo "📦 Installing dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed successfully"

# Check if PostgreSQL is available (optional)
echo "🔍 Checking for PostgreSQL..."
if command -v psql &> /dev/null; then
    echo "✅ PostgreSQL detected"
else
    echo "⚠️  PostgreSQL not found. App will use in-memory storage."
fi

# Setup database (if DATABASE_URL is provided)
if [ ! -z "$DATABASE_URL" ]; then
    echo "🗄️  Setting up database..."
    npm run db:push
    if [ $? -eq 0 ]; then
        echo "✅ Database setup completed"
    else
        echo "⚠️  Database setup failed, using in-memory storage"
    fi
else
    echo "⚠️  No DATABASE_URL provided, using in-memory storage"
fi

# Build the application
echo "🔨 Building application..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo "✅ Build completed successfully"

# Create start script
cat > start.sh << 'EOF'
#!/bin/bash
echo "Starting RGB Controller App..."
npm start
EOF

chmod +x start.sh

echo ""
echo "==================================="
echo "✅ Installation completed successfully!"
echo "==================================="
echo ""
echo "To start the application:"
echo "  ./start.sh"
echo ""
echo "Or manually run:"
echo "  npm start"
echo ""
echo "The app will be available at:"
echo "  http://localhost:5000"
echo ""
echo "==================================="