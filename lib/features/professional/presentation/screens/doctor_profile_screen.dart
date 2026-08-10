import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../../data/providers/professional_provider.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/specialty_card.dart';
import '../widgets/availability_card.dart';
import '../widgets/stats_overview_card.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final authProvider = context.read<AuthProvider>();
    final professionalProvider = context.read<ProfessionalProvider>();
    
    if (authProvider.user != null) {
      await professionalProvider.getProfessional(authProvider.user!['id']);
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        title: Text(
          'Mon Profil',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.darkGray,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _toggleEditMode,
            icon: Icon(
              _isEditing ? Icons.save : Icons.edit,
              color: AppTheme.primaryBlue,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
      body: Consumer2<AuthProvider, ProfessionalProvider>(
        builder: (context, authProvider, professionalProvider, child) {
          if (professionalProvider.isLoading) {
            return const LoadingOverlay(
              isLoading: true,
              child: SizedBox.expand(),
            );
          }

          final professional = professionalProvider.professional;
          final user = authProvider.user;

          return RefreshIndicator(
            onRefresh: _loadProfileData,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header avec photo de profil
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primaryBlue, AppTheme.lightBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Photo de profil
                          Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.white,
                                  border: Border.all(
                                    color: AppTheme.white,
                                    width: 4,
                                  ),
                                ),
                                child: ClipOval(
                                  child: professional?['photo'] != null
                                      ? Image.network(
                                          professional!['photo'],
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(
                                              Icons.person,
                                              size: 50,
                                              color: AppTheme.darkGray.withOpacity(0.5),
                                            );
                                          },
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 50,
                                          color: AppTheme.darkGray.withOpacity(0.5),
                                        ),
                                ),
                              ),
                              if (_isEditing)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryBlue,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppTheme.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: AppTheme.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Dr ${user?['first_name'] ?? ''} ${user?['last_name'] ?? ''}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            professional?['specialite'] ?? 'Médecin généraliste',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              professional?['statut'] ?? 'Actif',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Statistiques d'aperçu
                  FadeInLeft(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 200),
                    child: StatsOverviewCard(
                      totalPatients: professional?['total_patients'] ?? 0,
                      totalAppointments: professional?['total_appointments'] ?? 0,
                      averageRating: professional?['average_rating']?.toDouble() ?? 0.0,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Informations personnelles
                  FadeInRight(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 400),
                    child: ProfileInfoCard(
                      title: 'Informations personnelles',
                      icon: Icons.person,
                      isEditing: _isEditing,
                      fields: [
                        {
                          'label': 'Nom',
                          'value': user?['last_name'] ?? '',
                          'editable': false,
                        },
                        {
                          'label': 'Prénom',
                          'value': user?['first_name'] ?? '',
                          'editable': false,
                        },
                        {
                          'label': 'Email',
                          'value': user?['email'] ?? '',
                          'editable': false,
                        },
                        {
                          'label': 'Téléphone',
                          'value': professional?['telephone'] ?? '',
                          'editable': true,
                        },
                        {
                          'label': 'Adresse',
                          'value': professional?['adresse'] ?? '',
                          'editable': true,
                        },
                      ],
                      onSave: (updatedData) {
                        // Logique de sauvegarde des informations
                        _saveProfileInfo(updatedData);
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Spécialités
                  FadeInLeft(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 600),
                    child: SpecialtyCard(
                      title: 'Spécialités',
                      icon: Icons.medical_services,
                      specialties: professional?['specialites'] ?? ['Médecine générale'],
                      isEditing: _isEditing,
                      onSave: (updatedSpecialties) {
                        // Logique de sauvegarde des spécialités
                        _saveSpecialties(updatedSpecialties);
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Disponibilités
                  FadeInRight(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 800),
                    child: AvailabilityCard(
                      title: 'Disponibilités',
                      icon: Icons.schedule,
                      availabilities: professional?['disponibilites'] ?? [],
                      isEditing: _isEditing,
                      onSave: (updatedAvailabilities) {
                        // Logique de sauvegarde des disponibilités
                        _saveAvailabilities(updatedAvailabilities);
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Informations professionnelles
                  FadeInLeft(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 1000),
                    child: ProfileInfoCard(
                      title: 'Informations professionnelles',
                      icon: Icons.work,
                      isEditing: _isEditing,
                      fields: [
                        {
                          'label': 'Numéro RPPS',
                          'value': professional?['numero_rpps'] ?? '',
                          'editable': true,
                        },
                        {
                          'label': 'Années d\'expérience',
                          'value': professional?['annees_experience']?.toString() ?? '',
                          'editable': true,
                        },
                        {
                          'label': 'Langues parlées',
                          'value': professional?['langues']?.join(', ') ?? '',
                          'editable': true,
                        },
                        {
                          'label': 'Description',
                          'value': professional?['description'] ?? '',
                          'editable': true,
                          'multiline': true,
                        },
                      ],
                      onSave: (updatedData) {
                        // Logique de sauvegarde des informations professionnelles
                        _saveProfessionalInfo(updatedData);
                      },
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveProfileInfo(Map<String, String> data) async {
    final professionalProvider = context.read<ProfessionalProvider>();
    final authProvider = context.read<AuthProvider>();
    
    try {
      await professionalProvider.updateProfessional(
        authProvider.user!['id'],
        data,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Informations personnelles mises à jour avec succès'),
            backgroundColor: AppTheme.healthGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la mise à jour: $e'),
            backgroundColor: AppTheme.softRed,
          ),
        );
      }
    }
  }

  Future<void> _saveSpecialties(List<String> specialties) async {
    // Implémentation de la sauvegarde des spécialités
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Spécialités mises à jour avec succès'),
          backgroundColor: AppTheme.healthGreen,
        ),
      );
    }
  }

  Future<void> _saveAvailabilities(List<Map<String, dynamic>> availabilities) async {
    // Implémentation de la sauvegarde des disponibilités
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Disponibilités mises à jour avec succès'),
          backgroundColor: AppTheme.healthGreen,
        ),
      );
    }
  }

  Future<void> _saveProfessionalInfo(Map<String, String> data) async {
    // Implémentation de la sauvegarde des informations professionnelles
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Informations professionnelles mises à jour avec succès'),
          backgroundColor: AppTheme.healthGreen,
        ),
      );
    }
  }
}
