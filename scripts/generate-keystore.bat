@echo off
REM Script pour générer une clé de signature pour l'application A QUI VEUT ?
REM Usage: scripts\generate-keystore.bat

echo 🔑 Génération de la clé de signature pour A QUI VEUT ?

REM Vérifier si Java est installé
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Java n'est pas installé. Veuillez installer Java JDK d'abord.
    pause
    exit /b 1
)

REM Demander les informations à l'utilisateur
echo.
echo Veuillez entrer les informations pour la clé de signature :
echo.

set /p storePassword="Mot de passe du keystore: "
set /p keyPassword="Mot de passe de la clé: "
set /p keyAlias="Alias de la clé (recommandé: aquiveut): "
if "%keyAlias%"=="" set keyAlias=aquiveut

echo.
echo 📋 Résumé des informations :
echo   - Keystore: aquiveut-key.jks
echo   - Alias: %keyAlias%
echo   - Répertoire: android\
echo.

REM Créer le fichier key.properties
echo storePassword=%storePassword% > android\key.properties
echo keyPassword=%keyPassword% >> android\key.properties
echo keyAlias=%keyAlias% >> android\key.properties
echo storeFile=../aquiveut-key.jks >> android\key.properties

echo ✅ Fichier key.properties créé

REM Générer le keystore
echo.
echo 🔧 Génération du keystore...
cd android

keytool -genkey -v -keystore aquiveut-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias %keyAlias% -dname "CN=A QUI VEUT, OU=Healthcare, O=A QUI VEUT App, L=Dakar, ST=Senegal, C=SN" -storepass %storePassword% -keypass %keyPassword%

if %errorlevel% neq 0 (
    echo ❌ Erreur lors de la génération du keystore
    cd ..
    pause
    exit /b 1
)

echo ✅ Keystore généré avec succès
cd ..

echo.
echo 🎉 Configuration terminée !
echo.
echo 📝 Prochaines étapes :
echo   1. Pousser le code sur GitHub
echo   2. GitHub Actions générera un APK signé
echo   3. L'APK n'aura plus d'avertissements de sécurité
echo.
echo ⚠️  IMPORTANT : Gardez votre keystore en sécurité !
echo    - Ne partagez jamais vos mots de passe
echo    - Sauvegardez le fichier aquiveut-key.jks
echo    - Ajoutez android/key.properties à .gitignore

pause
