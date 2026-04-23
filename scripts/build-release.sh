#!/bin/bash

# Script de build pour l'application A QUI VEUT ?
# Usage: ./scripts/build-release.sh

echo "🚀 Début du build de l'application A QUI VEUT ?"

# Nettoyage
echo "🧹 Nettoyage du projet..."
flutter clean

# Récupération des dépendances
echo "📦 Installation des dépendances..."
flutter pub get

# Vérification du code
echo "🔍 Analyse du code..."
flutter analyze

# Tests
echo "🧪 Exécution des tests..."
flutter test

# Build APK Release
echo "📱 Build APK Release..."
flutter build apk --release --no-shrink

# Build App Bundle
echo "📦 Build App Bundle..."
flutter build appbundle --release --no-shrink

# Build Web
echo "🌐 Build Web..."
flutter build web --no-web-resources-cdn

echo "✅ Build terminé avec succès !"
echo "📁 Fichiers générés :"
echo "   - APK: build/app/outputs/flutter-apk/app-release.apk"
echo "   - AAB: build/app/outputs/bundle/release/app-release.aab"
echo "   - Web: build/web/"
