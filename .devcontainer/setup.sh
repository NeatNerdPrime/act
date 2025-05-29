#!/bin/bash
set -e

echo "🚀 Setting up MITRE ACT development environment..."

# The universal image has nvm at /usr/local/share/nvm
export NVM_DIR="/usr/local/share/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Install Node.js 22
echo "📦 Installing Node.js 22..."
nvm install 22
nvm use 22
nvm alias default 22

# Verify Node installation
echo "✅ Node.js version: $(node -v)"

# Enable corepack for pnpm with auto-download
echo "📦 Setting up pnpm..."
export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
corepack enable
corepack prepare pnpm@latest --activate

# Install dependencies
echo "📦 Installing dependencies..."
pnpm install --frozen-lockfile

# Rebuild native modules
echo "🔧 Rebuilding native modules..."
pnpm rebuild

# Create .env file if it doesn't exist and add the Nuxt UI Pro license if available
if [ ! -f .env ] && [ -n "$NUXT_UI_PRO_LICENSE" ]; then
    echo "🔑 Setting up Nuxt UI Pro license..."
    echo "NUXT_UI_PRO_LICENSE=$NUXT_UI_PRO_LICENSE" > .env
fi

echo "✅ Setup complete! Run 'pnpm dev' to start the development server."