#!/bin/bash

# Script pour générer une clé de signature pour l'application A QUI VEUT ?
# Usage: ./scripts/generate-keystore.sh

echo "🔑 Génération de la clé de signature pour A QUI VEUT ?"

# Vérifier si Java est installé
if ! command -v java &> /dev/null; then
    echo "❌ Java n'est pas installé. Veuillez installer Java JDK d'abord."
    exit 1
fi

# Demander les informations à l'utilisateur
echo
echo "Veuillez entrer les informations pour la clé de signature :"
echo

read -s -p "Mot de passe du keystore: " storePassword
echo
read -s -p "Mot de passe de la clé: " keyPassword
echo
read -p "Alias de la clé (recommandé: aquiveut): " keyAlias
if [ -z "$keyAlias" ]; then
    keyAlias="aquiveut"
fi

echo
echo "📋 Résumé des informations :"
echo "  - Keystore: aquiveut-key.jks"
echo "  - Alias: $keyAlias"
echo "  - Répertoire: android/"
echo

# Créer le fichier key.properties
echo "storePassword=$storePassword" > android/key.properties
echo "keyPassword=$keyPassword" >> android/key.properties
echo "keyAlias=$keyAlias" >> android/key.properties
echo "storeFile=../aquiveut-key.jks" >> android/key.properties

echo "✅ Fichier key.properties créé"

# Générer le keystore
echo
echo "🔧 Génération du keystore..."
cd android

keytool -genkey -v -keystore aquiveut-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias "$keyAlias" -dname "CN=A QUI VEUT, OU=Healthcare, O=A QUI VEUT App, L=Dakar, ST=Senegal, C=SN" -storepass "$storePassword" -keypass "$keyPassword"

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de la génération du keystore"
    cd ..
    exit 1
fi

echo "✅ Keystore généré avec succès"
cd ..

echo
echo "🎉 Configuration terminée !"
echo
echo "📝 Prochaines étapes :"
echo "  1. Pousser le code sur GitHub"
echo "  2. GitHub Actions générera un APK signé"
echo "  3. L'APK n'aura plus d'avertissements de sécurité"
echo
echo "⚠️  IMPORTANT : Gardez votre keystore en sécurité !"
echo "   - Ne partagez jamais vos mots de passe"
echo "   - Sauvegardez le fichier aquiveut-key.jks"
echo "   - Ajoutez android/key.properties à .gitignore"
