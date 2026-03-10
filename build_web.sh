#!/bin/bash

# Ensure the script exits on failure and prints commands
set -e
set -x

# Define variables
FLUTTER_ROOT="$PWD/flutter"

# Always use a fresh Flutter clone to ensure latest stable version and avoid git errors
if [ -d "$FLUTTER_ROOT" ]; then
  echo "Cleaning up Flutter..."
  rm -rf "$FLUTTER_ROOT"
fi

echo "Cloning Flutter (stable)..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$FLUTTER_ROOT"

# Add Flutter to PATH (put it at the front so it overrides any pre-installed system flutter)
export PATH="$FLUTTER_ROOT/bin:$PATH"

# Run Flutter commands
echo "Checking Flutter version..."
flutter --version

echo "Running Flutter doctor..."
flutter doctor || true

echo "Enabling web..."
flutter config --enable-web

echo "Getting dependencies..."
flutter pub get

echo "Generating localization..."
flutter gen-l10n

echo "Building web..."
flutter build web --release --no-wasm-dry-run
