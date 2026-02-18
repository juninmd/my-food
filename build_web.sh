#!/bin/bash

# Ensure the script exits on failure and prints commands
set -e
set -x

# Always use a fresh Flutter clone to ensure latest stable version and avoid git errors
echo "Cleaning up Flutter..."
rm -rf flutter

echo "Cloning Flutter (stable)..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

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
