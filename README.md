# A QUI VEUT ? - Application Mobile de Santé

Application mobile Flutter moderne permettant aux utilisateurs d'accéder à des services de santé, recevoir des conseils rapides, prendre rendez-vous, localiser des structures sanitaires et discuter avec un chatbot d'assistance.

## 📋 Vue d'ensemble

**A QUI VEUT ?** est une application de santé conçue pour rendre les services médicaux plus accessibles au Sénégal et en Afrique. L'application offre une interface moderne et intuitive pour connecter les patients aux professionnels de santé.

## 🎯 Fonctionnalités Principales

### 🔐 Authentification
- **Inscription/Connexion** : Formulaire complet avec validation
- **Gestion des profils** : Informations personnelles modifiables
- **Sécurité** : Validation des données et gestion des erreurs

### 🏠 Dashboard Accueil
- **Interface moderne** : Design Material Design 3
- **Navigation fluide** : Bottom navigation intuitive
- **Services rapides** : Accès direct aux fonctionnalités principales
- **Conseils santé** : Astuces quotidiennes pour le bien-être

### 📅 Prise de Rendez-vous
- **Liste de professionnels** : Médecins, sages-femmes, infirmiers
- **Filtrage par spécialité** : Recherche ciblée
- **Disponibilités** : Information en temps réel
- **Confirmation instantanée** : Processus de réservation simple

### 💬 Chatbot Santé
- **Assistant intelligent** : Réponses 24/7 aux questions médicales
- **Suggestions rapides** : Accès direct aux symptômes courants
- **Conseils personnalisés** : Recommandations adaptées
- **Alertes urgence** : Orientation vers les services d'urgence

### 🗺️ Carte des Services
- **Géolocalisation** : Trouver les services de santé proches
- **Filtres interactifs** : Hôpitaux, pharmacies, dispensaires
- **Informations détaillées** : Horaires, avis, contacts
- **Itinéraires** : Navigation GPS intégrée

### 👤 Profil Utilisateur
- **Informations personnelles** : Gestion du compte
- **Historique** : Suivi des rendez-vous passés
- **Paramètres** : Personnalisation de l'expérience
- **Mode sombre** : Option d'accessibilité

### 🔔 Notifications
- **Rappels** : Alertes de rendez-vous
- **Conseils santé** : Astuces quotidiennes
- **Alertes importantes** : Informations urgentes

## 🏗️ Architecture Technique

### Structure du Projet
```
lib/
├── main.dart                          # Point d'entrée de l'application
├── core/
│   ├── theme/
│   │   └── app_theme.dart             # Thème et couleurs
│   └── router/
│       └── app_router.dart            # Configuration navigation
├── data/
│   └── providers/
│       ├── auth_provider.dart         # Gestion authentification
│       └── app_provider.dart          # État global de l'app
├── features/
│   ├── splash/
│   │   └── presentation/screens/
│   │       └── splash_screen.dart     # Écran de chargement
│   ├── onboarding/
│   │   └── presentation/screens/
│   │       └── onboarding_screen.dart # Tutoriel initial
│   ├── auth/
│   │   └── presentation/screens/
│   │       ├── login_screen.dart      # Connexion
│   │       └── register_screen.dart   # Inscription
│   ├── home/
│   │   └── presentation/screens/
│   │       └── home_screen.dart       # Dashboard principal
│   ├── appointments/
│   │   └── presentation/screens/
│   │       └── appointments_screen.dart # Rendez-vous
│   ├── chatbot/
│   │   └── presentation/screens/
│   │       └── chatbot_screen.dart    # Assistant santé
│   ├── map/
│   │   └── presentation/screens/
│   │       └── map_screen.dart        # Carte services
│   ├── profile/
│   │   └── presentation/screens/
│   │       └── profile_screen.dart    # Profil utilisateur
│   └── notifications/
│       └── presentation/screens/
│           └── notifications_screen.dart # Centre notifications
└── shared/
    └── widgets/
        ├── custom_button.dart         # Boutons personnalisés
        ├── custom_text_field.dart     # Champs de texte
        ├── service_card.dart          # Cartes services
        ├── doctor_card.dart           # Cartes médecins
        ├── chat_bubble.dart           # Bulles de chat
        ├── location_card.dart         # Cartes lieux
        ├── profile_menu_item.dart     # Éléments menu profil
        ├── notification_card.dart     # Cartes notifications
        ├── health_tip_card.dart       # Cartes conseils santé
        ├── search_bar.dart            # Barre de recherche
        └── loading_overlay.dart       # Overlay chargement
```

### Stack Technique
- **Frontend** : Flutter 3.x avec Material Design 3
- **State Management** : Provider pattern
- **Navigation** : Go Router pour une navigation structurée
- **Animations** : animate_do pour des transitions fluides
- **Typography** : Google Fonts (Poppins)
- **Maps** : Google Maps Flutter
- **Location** : Geolocator pour la géolocalisation
- **Images** : cached_network_image pour les images réseau
- **Storage** : shared_preferences pour les préférences

## 🎨 Design et UX

### Charte Graphique
- **Bleu médical** : #2D8CFF (couleur principale)
- **Vert santé** : #27AE60 (couleur secondaire)
- **Blanc** : #FFFFFF (fond dominant)
- **Gris clair** : #F5F5F5 (arrière-plans)
- **Rouge doux** : #FF6B6B (alertes et urgences)
- **Texte foncé** : #212121 (texte principal)

### Principes de Design
- **Material Design 3** : Interface moderne et cohérente
- **Coins arrondis** : Border radius 16-24px pour un aspect doux
- **Ombres légères** : Profondeur et hiérarchie visuelle
- **Espacement aéré** : Interface claire et lisible
- **Animations fluides** : Transitions douces et naturelles
- **Responsive** : Adaptation Android/iOS

### Typographie
- **Police** : Poppins (Google Fonts)
- **Hiérarchie claire** : Titres gras, texte lisible
- **Accessibilité** : Contraste optimal et tailles adaptées

## 🚀 Installation et Configuration

### Prérequis
- Flutter SDK >= 3.10.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Émulateur Android ou appareil physique

### Installation
1. **Cloner le projet**
```bash
git clone <repository-url>
cd a-qui-veut
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configurer les clés API**
   - Google Maps : Ajouter la clé dans `android/app/src/main/AndroidManifest.xml`
   - Autres services : Configurer selon besoins

4. **Lancer l'application**
```bash
flutter run
```

### Build pour production
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 📱 Compatibilité

### Plateformes Supportées
- ✅ Android (API 21+)
- ✅ iOS (iOS 12.0+)
- 🔄 Web (en développement)
- 🔄 Desktop (en développement)

### Résolutions Supportées
- Mobile : 4.7" - 6.7"
- Tablet : 7" - 12.9"
- Responsive design adaptatif

## 🔧 Configuration API

### Backend Django REST
L'application est prête à se connecter à une API Django REST :

```dart
// Exemple de configuration API
class ApiService {
  static const String baseUrl = 'https://votre-api.com/api';
  
  // Endpoints à implémenter
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String appointments = '/appointments';
  static const String doctors = '/doctors';
  static const String healthLocations = '/health-locations';
  // ...
}
```

### Intégration Firebase (Optionnel)
Pour des fonctionnalités temps réel :
```bash
flutter pub add firebase_core firebase_auth firebase_cloud_firestore
```

## 🧪 Tests

### Tests Unitaires
```bash
flutter test
```

### Tests d'Intégration
```bash
flutter test integration_test/
```

### Analyse Statique
```bash
flutter analyze
```

## 📈 Performance

### Optimisations
- **Lazy Loading** : Chargement progressif des contenus
- **Image Caching** : Mise en cache des images réseau
- **State Management** : Gestion efficace de l'état
- **Memory Management** : Nettoyage des ressources

### Métriques Cibles
- **Temps de démarrage** : < 3 secondes
- **Navigation** : < 500ms entre écrans
- **Memory Usage** : < 100MB en utilisation normale

## 🔒 Sécurité

### Mesures Implémentées
- **Validation des entrées** : Protection contre injections
- **HTTPS** : Communications sécurisées
- **Token Storage** : Stockage sécurisé des tokens
- **Input Sanitization** : Nettoyage des données utilisateur

### Bonnes Pratiques
- **Code Obfuscation** : Protection du code source
- **Certificate Pinning** : Validation des certificats
- **Biometric Auth** : Authentification biométrique (future)

## 🌍 Internationalisation

### Langues Supportées
- 🇫🇷 Français (par défaut)
- 🇬🇧 Anglais (à venir)
- 🇸🇳 Wolof (à venir)

### Configuration
```dart
// Ajouter au pubspec.yaml
flutter:
  generate: true
  
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1
```

## 📝 Documentation Complémentaire

### Guides
- [Guide d'intégration API](docs/api-integration.md)
- [Guide de déploiement](docs/deployment.md)
- [Guide de contribution](docs/contributing.md)

### API Documentation
- [Endpoints Auth](docs/api/auth.md)
- [Endpoints Rendez-vous](docs/api/appointments.md)
- [Endpoints Carte](docs/api/map.md)

## 🤝 Contribution

### Comment Contribuer
1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/amazing-feature`)
3. Commit les changements (`git commit -m 'Add amazing feature'`)
4. Push vers la branche (`git push origin feature/amazing-feature`)
5. Ouvrir une Pull Request

### Code Style
- Suivre les conventions Flutter/Dart
- Commenter le code complexe
- Ajouter des tests pour nouvelles fonctionnalités
- Maintenir la cohérence du design

## 📄 Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour détails.

## 📞 Contact

- **Équipe de développement** : dev@aquivaut.sn
- **Support technique** : support@aquivaut.sn
- **Site web** : https://aquivaut.sn

---

**© 2024 A QUI VEUT ? - Votre santé, plus proche de vous**
