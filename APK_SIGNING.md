# Guide de Signature d'APK - A QUI VEUT ?

## 🔑 Pourquoi signer l'APK ?

L'APK actuel est signé avec une clé de **debug**, ce qui cause :
- ⚠️ Avertissements de sécurité lors de l'installation
- 🔒 Message "Installation d'applications inconnues"
- 🚫 Bloqueur automatique sur certains appareils

## ✅ Solution : Signature avec clé de production

### Étape 1 : Générer une clé de signature

#### Option A : Script Automatisé (Recommandé)

**Windows :**
```bash
scripts\generate-keystore.bat
```

**Linux/Mac :**
```bash
chmod +x scripts/generate-keystore.sh
./scripts/generate-keystore.sh
```

#### Option B : Manuel

1. **Générer le keystore** :
```bash
cd android
keytool -genkey -v -keystore aquiveut-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias aquiveut
```

2. **Créer key.properties** :
```properties
storePassword=votre_mot_de_passe
keyPassword=votre_mot_de_passe_cle
keyAlias=aquiveut
storeFile=../aquiveut-key.jks
```

### Étape 2 : Mettre à jour .gitignore

Ajoutez ces lignes à votre `.gitignore` :
```
# Keystore files (NE JAMAIS PARTAGER)
android/key.properties
android/aquiveut-key.jks
*.jks
*.keystore
```

### Étape 3 : Pousser sur GitHub

```bash
git add .
git commit -m "Add production signing configuration"
git push origin main
```

### Étape 4 : GitHub Actions

Le workflow GitHub Actions va maintenant :
- ✅ Détecter la clé de signature
- ✅ Générer un APK signé en production
- ✅ Éliminer les avertissements de sécurité

## 📱 Installation de l'APK Signé

Une fois le build terminé sur GitHub :

1. **Téléchargez l'APK** depuis les artifacts GitHub Actions
2. **Installez-le** sur votre appareil
3. **Bénéfices** :
   - ✅ Plus d'avertissements de sécurité
   - ✅ Installation comme application de confiance
   - ✅ Compatible avec tous les appareils Android

## 🔐 Sécurité du Keystore

### ⚠️ TRÈS IMPORTANT :

1. **Ne partagez JAMAIS** votre keystore
2. **Sauvegardez** le fichier `aquiveut-key.jks`
3. **Notez vos mots de passe** dans un endroit sûr
4. **Ne commitez JAMAIS** les fichiers de signature

### 📋 Checklist de Sécurité :

- [ ] Keystore sauvegardé sur plusieurs supports
- [ ] Mots de passe stockés dans un gestionnaire de mots de passe
- [ ] Fichiers de signature dans .gitignore
- [ ] Accès limité à l'équipe de développement

## 🚀 Déploiement sur Google Play

Pour le Google Play Store, vous aurez besoin de :

1. **APK signé** (ce que nous configurons maintenant)
2. **Compte développeur Google Play** ($25 une fois)
3. **Listing de l'application** avec captures d'écran
4. **Politique de confidentialité**

## 🔄 Mises à Jour Futures

Pour les futures versions :

- Utilisez le **même keystore**
- Incrémentez le **versionCode** dans `pubspec.yaml`
- GitHub Actions signera automatiquement chaque nouvelle version

## 🆘 Dépannage

### Problèmes Communs :

1. **"Keystore password incorrect"**
   - Vérifiez le fichier `key.properties`
   - Assurez-vous que les mots de passe sont corrects

2. **"Key alias not found"**
   - Vérifiez que l'alias dans `key.properties` correspond au keystore

3. **"Build failed on GitHub Actions"**
   - Assurez-vous que `key.properties` est dans le bon répertoire
   - Vérifiez que le keystore est accessible

### Commandes Utiles :

```bash
# Vérifier le keystore
keytool -list -v -keystore android/aquiveut-key.jks

# Signer manuellement (si nécessaire)
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore android/aquiveut-key.jks app-release.apk aquiveut
```

---

**📞 Support** : Si vous rencontrez des problèmes, vérifiez d'abord les logs GitHub Actions et les permissions des fichiers.
