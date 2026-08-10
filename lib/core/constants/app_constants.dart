class AppConstants {
  // Informations de l'application
  static const String appName = 'A QUI VEUT ?';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Application mobile de santé - Votre santé, plus proche de vous';
  
  // Clés pour SharedPreferences
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String onboardingKey = 'onboarding_completed';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  
  // Messages d'erreur
  static const String networkError = 'Erreur de connexion. Vérifiez votre internet.';
  static const String serverError = 'Erreur serveur. Réessayez plus tard.';
  static const String authError = 'Erreur d\'authentification.';
  static const String unknownError = 'Une erreur inconnue est survenue.';
  
  // Messages de succès
  static const String loginSuccess = 'Connexion réussie !';
  static const String registerSuccess = 'Inscription réussie !';
  static const String logoutSuccess = 'Déconnexion réussie !';
  static const String profileUpdateSuccess = 'Profil mis à jour !';
  static const String appointmentCreateSuccess = 'Rendez-vous créé !';
  static const String appointmentUpdateSuccess = 'Rendez-vous mis à jour !';
  static const String appointmentDeleteSuccess = 'Rendez-vous supprimé !';
  
  // Validation des formulaires
  static const String emailRequired = 'L\'email est requis';
  static const String emailInvalid = 'L\'email est invalide';
  static const String passwordRequired = 'Le mot de passe est requis';
  static const String passwordMinLength = 'Le mot de passe doit contenir au moins 6 caractères';
  static const String nameRequired = 'Le nom est requis';
  static const String phoneRequired = 'Le téléphone est requis';
  static const String phoneInvalid = 'Le numéro de téléphone est invalide';
  
  // Types de lieux de santé
  static const List<String> locationTypes = [
    'hopital',
    'pharmacie',
    'dispensaire',
    'clinique',
    'laboratoire',
    'centre_de_sante',
  ];
  
  static const Map<String, String> locationTypeLabels = {
    'hopital': 'Hôpital',
    'pharmacie': 'Pharmacie',
    'dispensaire': 'Dispensaire',
    'clinique': 'Clinique',
    'laboratoire': 'Laboratoire',
    'centre_de_sante': 'Centre de santé',
  };
  
  // Spécialités médicales
  static const List<String> medicalSpecialties = [
    'médecine_générale',
    'cardiologie',
    'pédiatrie',
    'gynécologie',
    'dermatologie',
    'ophtalmologie',
    'radiologie',
    'psychiatrie',
    'chirurgie',
    'anesthésie',
  ];
  
  static const Map<String, String> medicalSpecialtyLabels = {
    'médecine_générale': 'Médecine générale',
    'cardiologie': 'Cardiologie',
    'pédiatrie': 'Pédiatrie',
    'gynécologie': 'Gynécologie',
    'dermatologie': 'Dermatologie',
    'ophtalmologie': 'Ophtalmologie',
    'radiologie': 'Radiologie',
    'psychiatrie': 'Psychiatrie',
    'chirurgie': 'Chirurgie',
    'anesthésie': 'Anesthésie',
  };
  
  // Statuts de rendez-vous
  static const List<String> appointmentStatuses = [
    'en_attente',
    'confirmé',
    'annulé',
    'terminé',
    'reporté',
  ];
  
  static const Map<String, String> appointmentStatusLabels = {
    'en_attente': 'En attente',
    'confirmé': 'Confirmé',
    'annulé': 'Annulé',
    'terminé': 'Terminé',
    'reporté': 'Reporté',
  };
  
  // Rôles utilisateur
  static const List<String> userRoles = [
    'user',
    'professional',
    'admin',
  ];
  
  static const Map<String, String> userRoleLabels = {
    'user': 'Utilisateur',
    'professional': 'Professionnel',
    'admin': 'Administrateur',
  };
  
  // Durées et limites
  static const int maxRetryAttempts = 3;
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration debounceDelay = Duration(milliseconds: 500);
  
  // URLs externes
  static const String privacyPolicyUrl = 'https://aquiviut.sn/privacy';
  static const String termsOfServiceUrl = 'https://aquiviut.sn/terms';
  static const String supportEmail = 'support@aquiviut.sn';
  static const String supportPhone = '+221 33 123 45 67';
  
  // Configuration de la carte
  static const double defaultLatitude = 16.0313; // Saint-Louis, Sénégal
  static const double defaultLongitude = -16.4495;
  static const double defaultZoom = 13.0;
  static const double searchRadius = 5.0; // km
  
  // Configuration des notifications
  static const Duration notificationReminder = Duration(hours: 2);
  static const Duration notificationDeadline = Duration(minutes: 30);
}
