#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for Git
if ! command_exists git; then
    echo "Git not found. Please install Git to continue."
    exit 1
fi

# Install Docker
if ! command_exists docker; then
    echo "Docker not found. Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
fi

# Install Docker Compose
if ! command_exists docker-compose; then
    echo "Docker Compose not found. Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Clone the repository
REPO_URL="https://github.com/maniqofgod/vps-worker.git"
# Remove existing directory if it exists to ensure a clean clone
rm -rf vps-worker
git clone "$REPO_URL" vps-worker
cd vps-worker

# Get API Key
# If an argument is passed to the script, use it as the API key.
# Otherwise, prompt the user.
if [ -n "$1" ]; then
    API_KEY="$1"
    echo "API Key provided via argument."
else
    echo "Please enter your API Key:"
    read -r API_KEY
fi
echo "API_KEY=$API_KEY" > .env

echo ".env file created successfully."

# Start the worker
echo "Starting the VPS worker..."
docker-compose up -d --build

echo "VPS worker has been installed and started successfully."