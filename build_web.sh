#!/bin/bash

# Ensure the script exits on failure
set -e

# Clone Flutter if not present
if [ ! -d "flutter" ]; then
    echo "Cloning Flutter..."
    git clone https://github.com/flutter/flutter.git -b stable --depth 1
else
    echo "Flutter directory exists. Updating..."
    cd flutter
    git pull
    cd ..
fi

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Run Flutter commands
echo "Running Flutter doctor..."
flutter doctor

echo "Enabling web..."
flutter config --enable-web

echo "Getting dependencies..."
flutter pub get

echo "Generating localization..."
flutter gen-l10n

echo "Building web..."
flutter build web --release
