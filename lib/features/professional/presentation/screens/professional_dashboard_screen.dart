import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../../data/providers/appointment_provider.dart';
import '../../../../data/providers/professional_provider.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/profile_menu_item.dart';
import '../widgets/stats_card.dart';
import '../widgets/appointment_card.dart';

class ProfessionalDashboardScreen extends StatefulWidget {
  const ProfessionalDashboardScreen({super.key});

  @override
  State<ProfessionalDashboardScreen> createState() => _ProfessionalDashboardScreenState();
}

class _ProfessionalDashboardScreenState extends State<ProfessionalDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = context.read<AuthProvider>();
    final appointmentProvider = context.read<AppointmentProvider>();
    final professionalProvider = context.read<ProfessionalProvider>();
    
    // Charger les données du professionnel (utiliser l'ID du professionnel lié à l'utilisateur)
    final professionalId = authProvider.user?['professional_id'] ?? authProvider.user!['id'];
    await professionalProvider.getProfessional(professionalId);
    
    // Charger les rendez-vous
    await appointmentProvider.getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.primaryBlue.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/logoaquiveut.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Espace Professionnel',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGray,
                  ),
                ),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Text(
                      authProvider.user?['email'] ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.darkGray,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _handleLogout();
              } else if (value == 'profile') {
                _showProfile();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: AppTheme.darkGray),
                    SizedBox(width: 8),
                    Text('Profil'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppTheme.softRed),
                    SizedBox(width: 8),
                    Text('Déconnexion'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<ProfessionalProvider>(
        builder: (context, professionalProvider, child) {
          if (professionalProvider.isLoading) {
            return const LoadingWidget();
          }

          return RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section d'accueil
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      padding: const EdgeInsets.all(20),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bienvenue !',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return Text(
                                'Dr ${authProvider.user?['first_name'] ?? ''} ${authProvider.user?['last_name'] ?? ''}',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.white.withOpacity(0.9),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                            Expanded(
                              child: _buildQuickAction(
                                icon: Icons.calendar_today,
                                label: 'Mes RDV',
                                onTap: () => _navigateToAppointments(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildQuickAction(
                                icon: Icons.schedule,
                                label: 'Disponibilités',
                                onTap: () => _navigateToAvailability(),
                              ),
                            ),
                          ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Statistiques
                  FadeInLeft(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 200),
                    child: Consumer<AppointmentProvider>(
                      builder: (context, appointmentProvider, child) {
                        return Row(
                          children: [
                            Expanded(
                              child: StatsCard(
                                title: 'Rendez-vous',
                                value: appointmentProvider.appointments.length.toString(),
                                icon: Icons.calendar_month,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: StatsCard(
                                title: 'Aujourd\'hui',
                                value: _getTodayAppointments(appointmentProvider.appointments).length.toString(),
                                icon: Icons.today,
                                color: AppTheme.healthGreen,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Prochains rendez-vous
                  FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Prochains rendez-vous',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () => _navigateToAppointments(),
                              child: Text(
                                'Voir tout',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Consumer<AppointmentProvider>(
                          builder: (context, appointmentProvider, child) {
                            final upcomingAppointments = _getUpcomingAppointments(appointmentProvider.appointments);
                            
                            if (upcomingAppointments.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightGray.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 48,
                                      color: AppTheme.darkGray.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Aucun rendez-vous à venir',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: AppTheme.darkGray.withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Vos rendez-vous apparaîtront ici',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.darkGray.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return Column(
                              children: upcomingAppointments
                                  .take(3)
                                  .map((appointment) => Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: AppointmentCard(
                                          appointment: appointment,
                                          onTap: () => _showAppointmentDetails(appointment),
                                        ),
                                      ))
                                  .toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Actions rapides
                  FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Actions rapides',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ProfileMenuItem(
                                icon: Icons.add_circle_outline,
                                title: 'Ajouter RDV',
                                subtitle: 'Créer un nouveau rendez-vous',
                                onTap: () => _navigateToAddAppointment(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ProfileMenuItem(
                                icon: Icons.edit_calendar,
                                title: 'Gérer disponibilités',
                                subtitle: 'Mettre à jour vos horaires',
                                onTap: () => _navigateToAvailability(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppTheme.white,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getUpcomingAppointments(List<Map<String, dynamic>> appointments) {
    final now = DateTime.now();
    return appointments.where((appointment) {
      final appointmentDate = DateTime.parse(appointment['date_heure']);
      return appointmentDate.isAfter(now);
    }).toList()
      ..sort((a, b) {
        final dateA = DateTime.parse(a['date_heure']);
        final dateB = DateTime.parse(b['date_heure']);
        return dateA.compareTo(dateB);
      });
  }

  List<Map<String, dynamic>> _getTodayAppointments(List<Map<String, dynamic>> appointments) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return appointments.where((appointment) {
      final appointmentDate = DateTime.parse(appointment['date_heure']);
      final appointmentDay = DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day);
      return appointmentDay.isAtSameMomentAs(today);
    }).toList();
  }

  void _navigateToAppointments() {
    // Navigation vers la liste des rendez-vous
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigation vers les rendez-vous...'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _navigateToAvailability() {
    Navigator.of(context).pushNamed(AppRouter.availabilityManagement);
  }

  void _navigateToAddAppointment() {
    // Navigation vers l'ajout de rendez-vous
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigation vers l\'ajout de rendez-vous...'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _showAppointmentDetails(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Détails du rendez-vous'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Patient: ${appointment['patient_nom'] ?? 'N/A'}'),
              Text('Date: ${appointment['date_heure'] ?? 'N/A'}'),
              Text('Statut: ${appointment['statut'] ?? 'N/A'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  void _showProfile() {
    Navigator.of(context).pushNamed(AppRouter.professionalProfile);
  }

  void _handleLogout() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.logout();
    
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/professional-login',
        (Route<dynamic> route) => false,
      );
    }
  }
}
