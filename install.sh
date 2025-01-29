#!/bin/bash

# Update system
echo "🔄 Updating system..."
sudo apt-get update

# Install Git if not installed
if ! command -v git &> /dev/null; then
    echo "🛠 Installing Git..."
    sudo apt-get install -y git
fi

# Clone your repository
REPO_DIR="xray-installer"
if [ ! -d "$REPO_DIR" ]; then
    echo "📥 Cloning repository..."
    git clone https://github.com/sajjaddg/xray-installer.git
else
    echo "✅ Repository already cloned."
fi

# Change to project directory
cd "$REPO_DIR" || exit

# Install Node.js if not installed
if ! command -v node &> /dev/null; then
    echo "🛠 Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Install npm dependencies
echo "📦 Installing npm dependencies..."
npm install

# Parse command-line arguments
type="h2"  # Default type
while [[ $# -gt 0 ]]; do
    case $1 in
        --type)
            type="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# Run the Node.js CLI with the selected type
echo "🚀 Running xray-installer with type: $type"
npm run build

xray-installer --type "$type"
