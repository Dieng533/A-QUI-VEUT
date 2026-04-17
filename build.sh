#!/bin/bash
set -e

echo "Installing Flutter..."
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.0-stable.tar.xz
tar xf flutter_linux_3.19.0-stable.tar.xz
export PATH="$PATH:`pwd`/flutter/bin"

echo "Flutter doctor..."
flutter doctor -v

echo "Getting dependencies..."
flutter pub get

echo "Building web app..."
flutter build web --no-sound-null-safety --web-renderer canvaskit

echo "Build completed!"
ls -la build/web/
