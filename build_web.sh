#!/bin/bash

# Ensure the script exits on failure and prints commands
set -e
set -x

# Define variables
FLUTTER_ROOT="$PWD/flutter"

# Check if Flutter is already installed and in PATH
if ! command -v flutter &> /dev/null; then
    # Flutter not found, check if we need to clone it
    if [ ! -d "$FLUTTER_ROOT" ]; then
        echo "Cloning Flutter (stable)..."
        git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$FLUTTER_ROOT"
    else
        echo "Flutter directory exists, using it."
    fi
    # Add Flutter to PATH
    export PATH="$PATH:$FLUTTER_ROOT/bin"
else
    echo "Flutter is already installed."
fi

# Run Flutter commands
echo "Checking Flutter version..."
flutter --version

echo "Running Flutter doctor..."
flutter doctor

echo "Enabling web..."
flutter config --enable-web

echo "Getting dependencies..."
flutter pub get

echo "Generating localization..."
flutter gen-l10n

echo "Building web..."
flutter build web --release --verbose
