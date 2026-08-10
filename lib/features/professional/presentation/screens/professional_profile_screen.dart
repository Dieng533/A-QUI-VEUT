import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../../data/providers/professional_provider.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/loading_overlay.dart';

class ProfessionalProfileScreen extends StatefulWidget {
  const ProfessionalProfileScreen({super.key});

  @override
  State<ProfessionalProfileScreen> createState() => _ProfessionalProfileScreenState();
}

class _ProfessionalProfileScreenState extends State<ProfessionalProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _paysController = TextEditingController();
  final TextEditingController _licenceController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _presentationController = TextEditingController();
  
  String? _selectedSpecialite;
  String? _photoPath;

  final List<String> _specialites = [
    'medecin_general',
    'pediatre',
    'gynecologue',
    'cardiologue',
    'dermatologue',
    'ophtalmologue',
    'dentiste',
    'infirmier',
    'sage_femme',
    'kinesitherapeute',
    'psychologue',
    'radiologue',
    'biologiste',
    'pharmacien',
    'autre',
  ];

  final Map<String, String> _specialiteLabels = {
    'medecin_general': 'Médecin généraliste',
    'pediatre': 'Pédiatre',
    'gynecologue': 'Gynécologue',
    'cardiologue': 'Cardiologue',
    'dermatologue': 'Dermatologue',
    'ophtalmologue': 'Ophtalmologue',
    'dentiste': 'Dentiste',
    'infirmier': 'Infirmier',
    'sage_femme': 'Sage-femme',
    'kinesitherapeute': 'Kinésithérapeute',
    'psychologue': 'Psychologue',
    'radiologue': 'Radiologue',
    'biologiste': 'Biologiste',
    'pharmacien': 'Pharmacien',
    'autre': 'Autre',
  };

  @override
  void initState() {
    super.initState();
    _loadProfessionalData();
  }

  Future<void> _loadProfessionalData() async {
    final authProvider = context.read<AuthProvider>();
    final professionalProvider = context.read<ProfessionalProvider>();
    
    print('DEBUG PROFILE - Loading data...');
    print('DEBUG PROFILE - User data: ${authProvider.user}');
    
    if (authProvider.user != null) {
      final professionalId = authProvider.user?['professional_id'] ?? authProvider.user!['id'];
      print('DEBUG PROFILE - Professional ID: $professionalId');
      
      await professionalProvider.getProfessional(professionalId);
      print('DEBUG PROFILE - Professional loaded: ${professionalProvider.professional}');
      
      if (mounted && professionalProvider.professional != null) {
        final prof = professionalProvider.professional!;
        setState(() {
          _nomController.text = prof['nom'] ?? '';
          _prenomController.text = prof['prenom'] ?? '';
          _telephoneController.text = prof['telephone'] ?? '';
          _emailController.text = prof['email'] ?? '';
          _adresseController.text = prof['adresse'] ?? '';
          _villeController.text = prof['ville'] ?? 'Saint-Louis';
          _paysController.text = prof['pays'] ?? 'Sénégal';
          _licenceController.text = prof['numero_licence'] ?? '';
          _experienceController.text = prof['annees_experience']?.toString() ?? '0';
          _presentationController.text = prof['presentation'] ?? '';
          _selectedSpecialite = prof['specialite'];
          _photoPath = prof['photo'];
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null && mounted) {
        setState(() {
          _photoPath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sélection de l\'image: $e'),
            backgroundColor: AppTheme.softRed,
          ),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoadingOverlay(
        isLoading: true,
        child: SizedBox.shrink(),
        loadingText: 'Sauvegarde en cours...',
      ),
    );

    try {
      final authProvider = context.read<AuthProvider>();
      final professionalProvider = context.read<ProfessionalProvider>();
      
      if (professionalProvider.professional == null) {
        throw Exception('Profil professionnel non chargé');
      }

      final professionalId = professionalProvider.professional!['id'];
      
      final data = {
        'nom': _nomController.text.trim(),
        'prenom': _prenomController.text.trim(),
        'telephone': _telephoneController.text.trim(),
        'email': _emailController.text.trim(),
        'adresse': _adresseController.text.trim(),
        'ville': _villeController.text.trim(),
        'pays': _paysController.text.trim(),
        'numero_licence': _licenceController.text.trim(),
        'specialite': _selectedSpecialite,
        'annees_experience': int.tryParse(_experienceController.text) ?? 0,
        'presentation': _presentationController.text.trim(),
        if (_photoPath != null) 'photo': _photoPath,
      };

      await professionalProvider.updateProfessional(professionalId, data);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil mis à jour avec succès'),
            backgroundColor: AppTheme.healthGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sauvegarde: $e'),
            backgroundColor: AppTheme.softRed,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _adresseController.dispose();
    _villeController.dispose();
    _paysController.dispose();
    _licenceController.dispose();
    _experienceController.dispose();
    _presentationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.darkGray),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Mon profil professionnel',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.darkGray,
          ),
        ),
      ),
      body: Consumer<ProfessionalProvider>(
        builder: (context, professionalProvider, child) {
          if (professionalProvider.isLoading) {
            return const LoadingWidget();
          }

          return RefreshIndicator(
            onRefresh: _loadProfessionalData,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo de profil
                    FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      child: Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.lightGray,
                                  border: Border.all(
                                    color: AppTheme.primaryBlue,
                                    width: 3,
                                  ),
                                ),
                                child: _photoPath != null
                                    ? ClipOval(
                                        child: Image.network(
                                          _photoPath!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(
                                              Icons.person,
                                              size: 60,
                                              color: AppTheme.darkGray.withOpacity(0.5),
                                            );
                                          },
                                        ),
                                      )
                                    : Icon(
                                        Icons.person,
                                        size: 60,
                                        color: AppTheme.darkGray.withOpacity(0.5),
                                      ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: AppTheme.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Informations personnelles
                    FadeInLeft(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 100),
                      child: Text(
                        'Informations personnelles',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    FadeInLeft(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 200),
                      child: CustomTextField(
                        controller: _nomController,
                        label: 'Nom',
                        hintText: 'Votre nom',
                        prefixIcon: Icons.person,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    FadeInLeft(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 300),
                      child: CustomTextField(
                        controller: _prenomController,
                        label: 'Prénom',
                        hintText: 'Votre prénom',
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    FadeInLeft(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 400),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.lightGray.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            value: _selectedSpecialite,
                            decoration: InputDecoration(
                              labelText: 'Spécialité',
                              prefixIcon: Icon(Icons.medical_services, color: AppTheme.primaryBlue),
                              border: InputBorder.none,
                            ),
                            items: _specialites.map((specialite) {
                              return DropdownMenuItem(
                                value: specialite,
                                child: Text(_specialiteLabels[specialite] ?? specialite),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSpecialite = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Ce champ est obligatoire';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    FadeInLeft(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 500),
                      child: CustomTextField(
                        controller: _licenceController,
                        label: 'Numéro de licence',
                        hintText: 'Votre numéro de licence',
                        prefixIcon: Icons.badge,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    FadeInLeft(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 600),
                      child: CustomTextField(
                        controller: _experienceController,
                        label: 'Années d\'expérience',
                        hintText: 'Nombre d\'années',
                        prefixIcon: Icons.work_history,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          final years = int.tryParse(value);
                          if (years == null || years < 0) {
                            return 'Veuillez entrer un nombre valide';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Contact
                    FadeInLeft(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 700),
                      child: Text(
                        'Contact',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    FadeInLeft(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 800),
                      child: CustomTextField(
                        controller: _telephoneController,
                        label: 'Téléphone',
                        hintText: '+221 XX XXX XX XX',
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    FadeInLeft(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 900),
                      child: CustomTextField(
                        controller: _emailController,
                        label: 'Email',
                        hintText: 'votre@email.com',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          if (!value.contains('@')) {
                            return 'Veuillez entrer un email valide';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Adresse
                    FadeInLeft(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 1000),
                      child: Text(
                        'Adresse',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    FadeInLeft(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 1100),
                      child: CustomTextField(
                        controller: _adresseController,
                        label: 'Adresse',
                        hintText: 'Votre adresse complète',
                        prefixIcon: Icons.location_on,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    FadeInLeft(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 1200),
                      child: CustomTextField(
                        controller: _villeController,
                        label: 'Ville',
                        hintText: 'Saint-Louis',
                        prefixIcon: Icons.location_city,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    FadeInLeft(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 1300),
                      child: CustomTextField(
                        controller: _paysController,
                        label: 'Pays',
                        hintText: 'Sénégal',
                        prefixIcon: Icons.public,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Présentation
                    FadeInLeft(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 1400),
                      child: Text(
                        'Présentation',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    FadeInLeft(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 1500),
                      child: CustomTextField(
                        controller: _presentationController,
                        label: 'Présentation',
                        hintText: 'Décrivez votre parcours et vos spécialités...',
                        prefixIcon: Icons.description,
                        maxLines: 4,
                      ),
                    ),

                    const SizedBox(height: 32),

                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 1600),
                      child: CustomButton(
                        text: 'Sauvegarder les modifications',
                        onPressed: _saveProfile,
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
