@echo off
REM Script de build pour l'application A QUI VEUT ?
REM Usage: scripts\build-release.bat

echo 🚀 Début du build de l'application A QUI VEUT ?

REM Nettoyage
echo 🧹 Nettoyage du projet...
flutter clean

REM Récupération des dépendances
echo 📦 Installation des dépendances...
flutter pub get

REM Vérification du code
echo 🔍 Analyse du code...
flutter analyze

REM Tests
echo 🧪 Exécution des tests...
flutter test

REM Build APK Release
echo 📱 Build APK Release...
flutter build apk --release --no-shrink

REM Build App Bundle
echo 📦 Build App Bundle...
flutter build appbundle --release --no-shrink

REM Build Web
echo 🌐 Build Web...
flutter build web --no-web-resources-cdn

echo ✅ Build terminé avec succès !
echo 📁 Fichiers générés :
echo    - APK: build\app\outputs\flutter-apk\app-release.apk
echo    - AAB: build\app\outputs\bundle\release\app-release.aab
echo    - Web: build\web\

pause
