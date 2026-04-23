// Données mockées pour l'application A QUI VEUT ?
// Utilisées pour démonstration sans backend

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class MockData {
  // Médecins simulés
  static final List<Map<String, dynamic>> doctors = [
    {
      'id': '1',
      'name': 'Dr. Aminata Ndiaye',
      'specialty': 'Médecin Généraliste',
      'rating': 4.8,
      'distance': '2.3 km',
      'availability': true,
      'experience': '15 ans',
      'price': '5000 FCFA',
      'address': 'Hôpital Principal, Dakar',
      'phone': '+221 33 123 45 67',
      'image': 'assets/doctor1.png',
    },
    {
      'id': '2',
      'name': 'Dr. Babacar Fall',
      'specialty': 'Gynécologue',
      'rating': 4.9,
      'distance': '3.7 km',
      'availability': true,
      'experience': '12 ans',
      'price': '8000 FCFA',
      'address': 'Clinique Médicale, Pikine',
      'phone': '+221 33 234 56 78',
      'image': 'assets/doctor2.png',
    },
    {
      'id': '3',
      'name': 'Dr. Fatou Diop',
      'specialty': 'Pédiatre',
      'rating': 4.7,
      'distance': '1.5 km',
      'availability': false,
      'experience': '10 ans',
      'price': '6000 FCFA',
      'address': 'Centre de Santé, Thiès',
      'phone': '+221 33 345 67 89',
      'image': 'assets/doctor3.png',
    },
    {
      'id': '4',
      'name': 'Dr. Moussa Sène',
      'specialty': 'Cardiologue',
      'rating': 4.9,
      'distance': '4.2 km',
      'availability': true,
      'experience': '18 ans',
      'price': '10000 FCFA',
      'address': 'Hôpital Fann, Dakar',
      'phone': '+221 33 456 78 90',
      'image': 'assets/doctor4.png',
    },
    {
      'id': '5',
      'name': 'Dr. Aïda Ba',
      'specialty': 'Dermatologue',
      'rating': 4.6,
      'distance': '2.8 km',
      'availability': true,
      'experience': '8 ans',
      'price': '7000 FCFA',
      'address': 'Cabinet Privé, Mbour',
      'phone': '+221 33 567 89 01',
      'image': 'assets/doctor5.png',
    },
  ];

  // Centres de santé
  static final List<Map<String, dynamic>> healthCenters = [
    {
      'id': '1',
      'name': 'Hôpital Principal de Dakar',
      'type': 'Hôpital',
      'distance': '3.5 km',
      'rating': 4.5,
      'address': 'Avenue Pasteur, Dakar',
      'phone': '+221 33 889 00 00',
      'hours': '24h/24',
      'services': ['Urgence', 'Consultation', 'Laboratoire', 'Imagerie'],
      'coordinates': {'lat': 14.6928, 'lng': -17.4467},
    },
    {
      'id': '2',
      'name': 'Pharmacie Centrale',
      'type': 'Pharmacie',
      'distance': '1.2 km',
      'rating': 4.7,
      'address': 'Boulevard de la Libération, Dakar',
      'phone': '+221 33 823 45 67',
      'hours': '08h-22h',
      'services': ['Médicaments', 'Conseils', 'Vaccination'],
      'coordinates': {'lat': 14.6928, 'lng': -17.4467},
    },
    {
      'id': '3',
      'name': 'Dispensaire Darou',
      'type': 'Dispensaire',
      'distance': '5.8 km',
      'rating': 4.3,
      'address': 'Route de Darou Salam',
      'phone': '+221 33 934 56 78',
      'hours': '08h-18h',
      'services': ['Consultation', 'Vaccination', 'Planification familiale'],
      'coordinates': {'lat': 14.6928, 'lng': -17.4467},
    },
    {
      'id': '4',
      'name': 'Cabinet Médical le Palmier',
      'type': 'Cabinet',
      'distance': '2.1 km',
      'rating': 4.8,
      'address': 'Sicap Liberté 6, Dakar',
      'phone': '+221 33 845 67 89',
      'hours': '09h-20h',
      'services': ['Consultation', 'Analyses', 'Suivi'],
      'coordinates': {'lat': 14.6928, 'lng': -17.4467},
    },
  ];

  // Réponses du chatbot santé
  static final Map<String, String> chatbotResponses = {
    'maux de tête': 'Reposez-vous et hydratez-vous bien.\nPrenez du paracétamol si nécessaire.\nConsultez un médecin si:\n- La douleur persiste > 24h\n- Fièvre associée\n- Douleur intense soudaine\n- Vision trouble\n\nCes conseils ne remplacent pas un médecin.',
    
    'fièvre': 'Reposez-vous et buvez beaucoup d\'eau.\nPrenez du paracétamol pour la fièvre.\nSurveillez la température toutes les 4h.\n\nConsultez immédiatement si:\n- Température > 40°C\n- Difficultés respiratoires\n- Confusion\n- Vomissements persistants\n\nCes conseils ne remplacent pas un médecin.',
    
    'petite blessure': '1. Lavez la plaie à l\'eau et au savon\n2. Désinfectez avec un antiseptique\n3. Couvrez avec un pansement propre\n4. Surveillez l\'infection (rougeur, chaleur, pus)\n\nConsultez si:\n- La plaie est profonde\n- Saignement abondant\n- Signes d\'infection\n\nCes conseils ne remplacent pas un médecin.',
    
    'hémorragie': 'URGENCE - Appelez le 15 immédiatement!\n\nEn attendant les secours:\n- Allongez la personne\n- Élevez la zone qui saigne\n- Appliquez une pression directe\n- Couvrez la personne\n\nNE PAS:\n- Donner à boire ou manger\n- Déplacer la personne si trauma\n\nCes conseils ne remplacent pas un médecin.',

'grossesse': 'Pendant la grossesse:\n- Consultations régulières chez le gynécologue\n- Alimentation équilibrée\n- Éviter alcool et tabac\n- Exercice modéré\n\nConsultez en urgence si:\n- Saignements\n- Douleurs intenses\n- Perte de liquide\n- Baisse des mouvements fétaux\n\nCes conseils ne remplacent pas un médecin.',
    
    'stress': 'Techniques pour gérer le stress:\n- Respiration profonde (4-7-8)\n- Méditation 10min/jour\n- Exercice physique régulier\n- Sommeil suffisant (7-8h)\n\nConsultez si:\n- Stress persistant > 2 semaines\n- Impact sur vie quotidienne\n- Symptômes physiques\n\nCes conseils ne remplacent pas un médecin.',
  };

  // Notifications simulées
  static final List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'title': 'Rendez-vous demain',
      'message': 'Dr. Ndiaye à 10h00 - Hôpital Principal',
      'time': 'Il y a 2h',
      'type': 'appointment',
      'read': false,
    },
    {
      'id': '2',
      'title': 'Conseil santé du jour',
      'message': 'Buvez au moins 8 verres d\'eau par jour',
      'time': 'Il y a 5h',
      'type': 'health_tip',
      'read': true,
    },
    {
      'id': '3',
      'title': 'Vaccination disponible',
      'message': 'Vaccin COVID-19 disponible à Pharmacie Centrale',
      'time': 'Hier',
      'type': 'vaccine',
      'read': true,
    },
    {
      'id': '4',
      'title': 'Nouvelle assistance',
      'message': 'Chatbot santé disponible 24/7',
      'time': 'Il y a 2 jours',
      'type': 'service',
      'read': true,
    },
  ];

  // Conseils santé du jour
  static final List<Map<String, dynamic>> healthTips = [
    {
      'id': '1',
      'title': 'Hydratation',
      'content': 'Buvez au moins 8 verres d\'eau par jour pour maintenir une bonne hydratation et favoriser l\'élimination des toxines.',
      'category': 'nutrition',
      'icon': Icons.water_drop,
      'color': Colors.blue,
    },
    {
      'id': '2',
      'title': 'Sommeil',
      'content': 'Visez 7-8 heures de sommeil par nuit pour une meilleure récupération et un système immunitaire renforcé.',
      'category': 'lifestyle',
      'icon': Icons.bedtime,
      'color': Colors.purple,
    },
    {
      'id': '3',
      'title': 'Activité physique',
      'content': '30 minutes d\'exercice modéré par jour réduisent les risques de maladies chroniques.',
      'category': 'exercise',
      'icon': Icons.directions_run,
      'color': Colors.green,
    },
    {
      'id': '4',
      'title': 'Alimentation équilibrée',
      'content': 'Privilégiez les fruits et légumes frais, limitez les sucres et les graisses saturées.',
      'category': 'nutrition',
      'icon': Icons.restaurant,
      'color': Colors.orange,
    },
  ];

  // Premiers secours
  static final List<Map<String, dynamic>> firstAid = [
    {
      'id': '1',
      'title': 'Arrêter un saignement',
      'description': 'Appliquez une pression directe avec un tissu propre. Élevez la zone blessée.',
      'steps': [
        'Lavez-vous les mains',
        'Appliquez pression directe',
        'Élevez le membre blessé',
        'Maintenez 10-15 minutes',
        'Couvrez avec pansement',
      ],
      'emergency': false,
      'icon': Icons.healing,
      'color': Colors.red,
    },
    {
      'id': '2',
      'title': 'Brûlure légère',
      'description': 'Refroidissez la brûlure avec de l\'eau fraîche pendant 15 minutes.',
      'steps': [
        'Arrêtez la source de chaleur',
        'Refroidissez avec eau fraîche',
        'Enlevez vêtements près brûlure',
        'Couvrez avec pansement stérile',
        'Ne percez pas les cloques',
      ],
      'emergency': false,
      'icon': Icons.local_fire_department,
      'color': Colors.orange,
    },
    {
      'id': '3',
      'title': 'Fièvre chez l\'enfant',
      'description': 'Surveillez la température et donnez du paracétamol adapté à l\'âge.',
      'steps': [
        'Prenez la température',
        'Donnez médicament si > 38.5°C',
        'Hydratez l\'enfant',
        'Vêtements légers',
        'Consultez si fièvre persiste',
      ],
      'emergency': false,
      'icon': Icons.thermostat,
      'color': Colors.blue,
    },
    {
      'id': '4',
      'title': 'Malaise / Évanouissement',
      'description': 'Allongez la personne et surélevez ses jambes.',
      'steps': [
        'Allongez sur le dos',
        'Élevez jambes à 45°',
        'Desserrez vêtements',
        'Aérez la pièce',
        'Appelez secours si reprise rapide',
      ],
      'emergency': true,
      'icon': Icons.sick,
      'color': Colors.red,
    },
    {
      'id': '5',
      'title': 'Plaie légère',
      'description': 'Nettoyez et désinfectez la plaie, puis couvrez-la.',
      'steps': [
        'Lavez mains et plaie',
        'Désinfectez avec antiseptique',
        'Séchez délicatement',
        'Appliquez pansement',
        'Surveillez infection',
      ],
      'emergency': false,
      'icon': Icons.medical_services,
      'color': Colors.green,
    },
  ];

  // Soutien psychosocial
  static final List<Map<String, dynamic>> psychosocialSupport = [
    {
      'id': '1',
      'title': 'Besoin de parler',
      'description': 'Parfois, il suffit d\'une oreille attentive pour se sentir mieux.',
      'content': 'Nos professionnels sont là pour vous écouter sans jugement.',
      'contact': 'Appelez le 777 123 456',
      'available': '24h/24',
      'icon': Icons.chat,
      'color': Colors.blue,
    },
    {
      'id': '2',
      'title': 'Stress / Anxiété',
      'description': 'Le stress peut devenir accablant. Apprenez à le gérer.',
      'content': 'Techniques de relaxation, méditation et accompagnement personnalisé.',
      'contact': 'Rendez-vous en ligne',
      'available': '08h-20h',
      'icon': Icons.psychology,
      'color': Colors.purple,
    },
    {
      'id': '3',
      'title': 'Violence / Danger',
      'description': 'Vous n\'êtes pas seul(e). Aide immédiate disponible.',
      'content': 'Protection, hébergement sécurisé et accompagnement juridique.',
      'contact': 'Appelez le 33 800 00 01',
      'available': '24h/24',
      'icon': Icons.security,
      'color': Colors.red,
    },
    {
      'id': '4',
      'title': 'Solitude',
      'description': 'La solitude peut être difficile. Rejoignez notre communauté.',
      'content': 'Groupes de soutien, activités et échanges bienveillants.',
      'contact': 'Inscription gratuite',
      'available': '09h-18h',
      'icon': Icons.people,
      'color': Colors.green,
    },
    {
      'id': '5',
      'title': 'Conseils bien-être',
      'description': 'Prenez soin de votre santé mentale au quotidien.',
      'content': 'Exercices, astuces et ressources pour votre équilibre.',
      'contact': 'Ressources en ligne',
      'available': 'Accès libre',
      'icon': Icons.self_improvement,
      'color': Colors.orange,
    },
  ];

  // Services populaires
  static final List<Map<String, dynamic>> popularServices = [
    {
      'id': '1',
      'name': 'Consultation générale',
      'icon': Icons.medical_services,
      'description': 'Médecins disponibles',
      'color': AppTheme.primaryBlue,
      'price': 'À partir de 5000 FCFA',
    },
    {
      'id': '2',
      'name': 'Vaccination',
      'icon': Icons.vaccines,
      'description': 'Centres proches',
      'color': AppTheme.healthGreen,
      'price': 'Gratuit selon programme',
    },
    {
      'id': '3',
      'name': 'Analyses médicales',
      'icon': Icons.science,
      'description': 'Laboratoires',
      'color': AppTheme.primaryBlue,
      'price': 'À partir de 3000 FCFA',
    },
    {
      'id': '4',
      'name': 'Suivi grossesse',
      'icon': Icons.pregnant_woman,
      'description': 'Maternité',
      'color': AppTheme.healthGreen,
      'price': 'Forfait disponible',
    },
  ];

  // Historique des rendez-vous
  static final List<Map<String, dynamic>> appointmentHistory = [
    {
      'id': '1',
      'doctor': 'Dr. Aminata Ndiaye',
      'specialty': 'Médecin Généraliste',
      'date': '15/04/2026',
      'time': '10:00',
      'status': 'completed',
      'notes': 'Consultation routine - Traitement prescrit',
    },
    {
      'id': '2',
      'doctor': 'Dr. Babacar Fall',
      'specialty': 'Gynécologue',
      'date': '10/04/2026',
      'time': '14:30',
      'status': 'completed',
      'notes': 'Suivi grossesse - Tout va bien',
    },
    {
      'id': '3',
      'doctor': 'Dr. Fatou Diop',
      'specialty': 'Pédiatre',
      'date': '05/04/2026',
      'time': '11:00',
      'status': 'cancelled',
      'notes': 'Annulé par patient',
    },
  ];
}

class OnboardingItem {
  final IconData icon;
  final String title;
  final String description;
  final String illustration;

  OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.illustration,
  });
}
