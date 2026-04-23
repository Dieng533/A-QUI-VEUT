# Guide de Déploiement - A QUI VEUT ?

## 🚀 Déploiement Automatique avec GitHub Actions

### Prérequis
- Compte GitHub avec repository créé
- Token d'accès GitHub (si privé)
- Configuration des secrets si nécessaire

### Étapes de Déploiement

#### 1. Initialiser le Repository GitHub

```bash
# Ajouter le remote GitHub
git remote add origin https://github.com/VOTRE_USERNAME/a-qui-veut.git

# Pousser le code
git push -u origin main
```

#### 2. Configuration des Workflows

Les workflows GitHub Actions sont déjà configurés dans `.github/workflows/` :

- **`flutter-build.yml`** : Build automatique APK/AAB/Web
- **`flutter-test.yml`** : Tests et analyse de code

#### 3. Déclenchement du Build

Le build se déclenche automatiquement sur :
- Push sur la branche `main`
- Pull Request sur `main`
- Déclenchement manuel depuis l'onglet "Actions"

#### 4. Téléchargement des Artéfacts

1. Allez dans l'onglet "Actions" de votre repository GitHub
2. Sélectionnez le workflow "Flutter Build and Release"
3. Cliquez sur la dernière exécution
4. Téléchargez les artéfacts générés :
   - `debug-apk` : APK de débogage
   - `release-apk` : APK de production
   - `app-bundle` : AAB pour Google Play

## 📱 Installation de l'APK

### Méthode 1 : Installation Directe

1. Téléchargez le fichier `app-release.apk`
2. Transférez-le sur votre appareil Android
3. Activez "Installation d'applications inconnues"
4. Cliquez sur le fichier APK pour installer

### Méthode 2 : ADB (Développeurs)

```bash
# Connecter l'appareil
adb devices

# Installer l'APK
adb install build/app/outputs/flutter-apk/app-release.apk

# Lancer l'application
adb shell am start -n com.aquiveut.app/.MainActivity
```

## 🔧 Build Local

### Script Automatisé

**Windows :**
```bash
scripts\build-release.bat
```

**Linux/Mac :**
```bash
chmod +x scripts/build-release.sh
./scripts/build-release.sh
```

### Build Manuel

```bash
# Nettoyage
flutter clean

# Dépendances
flutter pub get

# Build APK Release
flutter build apk --release --no-shrink

# Build App Bundle (Play Store)
flutter build appbundle --release --no-shrink

# Build Web
flutter build web --no-web-resources-cdn
```

## 🌐 Déploiement Web

### Firebase Hosting

```bash
# Installer Firebase CLI
npm install -g firebase-tools

# Initialiser Firebase
firebase init

# Déployer
firebase deploy
```

### Vercel

```bash
# Installer Vercel CLI
npm install -g vercel

# Déployer
vercel --prod
```

## 📋 Configuration Android Studio

### Signature de Release

1. Générer une clé de signature :
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Configurer `key.properties` :
```properties
storePassword=votre_mot_de_passe
keyPassword=votre_mot_de_passe
keyAlias=upload
storeFile=../upload-keystore.jks
```

3. Mettre à jour `android/app/build.gradle.kts` pour la signature en production

## 🔍 Tests et Validation

### Tests Automatisés

Les workflows GitHub Actions incluent :
- Analyse de code (`flutter analyze`)
- Formatage du code (`dart format`)
- Tests unitaires (`flutter test`)
- Coverage de code

### Tests Manuels

```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter test integration_test/

# Analyse de performance
flutter run --profile
```

## 📊 Monitoring

### Crash Reporting

Pour le monitoring en production :
- Firebase Crashlytics
- Sentry
- Custom analytics

### Performance

- Flutter DevTools
- Firebase Performance Monitoring
- Custom metrics

## 🚨 Dépannage

### Problèmes Communs

1. **Build échoue** : Vérifier les dépendances dans `pubspec.yaml`
2. **APK ne s'installe pas** : Vérifier les permissions Android
3. **Crash au démarrage** : Vérifier les logs avec `adb logcat`
4. **Build lent** : Activer le cache dans GitHub Actions

### Logs et Debug

```bash
# Logs Android
adb logcat | grep flutter

# Logs de build
flutter build apk --verbose

# Tests avec logs
flutter test --verbose
```

## 📝 Checklist de Déploiement

- [ ] Code pushé sur GitHub
- [ ] Tests passés avec succès
- [ ] Build généré sans erreur
- [ ] APK testé sur appareil
- [ ] Version incrémentée dans `pubspec.yaml`
- [ ] Notes de version mises à jour
- [ ] Documentation à jour

## 🔄 Mises à Jour

### Processus de Release

1. Créer une branche `release/vX.X.X`
2. Mettre à jour la version dans `pubspec.yaml`
3. Ajouter les notes de version
4. Merger vers `main`
5. Créer un tag Git
6. GitHub Actions génère automatiquement la release

### Versioning

Suivre le Semantic Versioning :
- `MAJOR.MINOR.PATCH`
- Exemple : `1.0.0`, `1.1.0`, `1.1.1`

---

**📞 Support** : En cas de problème, vérifier les logs GitHub Actions ou contacter l'équipe de développement.
