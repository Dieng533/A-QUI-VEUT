import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../../data/providers/professional_provider.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/loading_overlay.dart';

class AvailabilityManagementScreen extends StatefulWidget {
  const AvailabilityManagementScreen({super.key});

  @override
  State<AvailabilityManagementScreen> createState() => _AvailabilityManagementScreenState();
}

class _AvailabilityManagementScreenState extends State<AvailabilityManagementScreen> {
  final Map<String, Map<String, TimeOfDay?>> _availabilities = {};
  final Map<String, bool> _isAvailable = {};
  
  final List<String> _days = [
    'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi', 'dimanche'
  ];

  @override
  void initState() {
    super.initState();
    _initializeAvailabilities();
    _loadExistingAvailabilities();
  }

  void _initializeAvailabilities() {
    for (var day in _days) {
      _availabilities[day] = {
        'morning_start': null,
        'morning_end': null,
        'afternoon_start': null,
        'afternoon_end': null,
      };
      _isAvailable[day] = true;
    }
  }

  Future<void> _loadExistingAvailabilities() async {
    final authProvider = context.read<AuthProvider>();
    final professionalProvider = context.read<ProfessionalProvider>();
    
    print('DEBUG AVAILABILITY - Loading data...');
    print('DEBUG AVAILABILITY - User data: ${authProvider.user}');
    
    if (authProvider.user != null) {
      final professionalId = authProvider.user?['professional_id'] ?? authProvider.user!['id'];
      print('DEBUG AVAILABILITY - Professional ID: $professionalId');
      
      await professionalProvider.getProfessional(professionalId);
      
      if (professionalProvider.professional != null) {
        await professionalProvider.getAvailabilities(professionalProvider.professional!['id']);
        
        if (mounted) {
          setState(() {
            for (var availability in professionalProvider.availabilities) {
              final day = availability['jour'];
              _isAvailable[day] = availability['est_disponible'];
              
              if (availability['heure_debut_matin'] != null) {
                _availabilities[day]?['morning_start'] = _parseTime(availability['heure_debut_matin']);
              }
              if (availability['heure_fin_matin'] != null) {
                _availabilities[day]?['morning_end'] = _parseTime(availability['heure_fin_matin']);
              }
              if (availability['heure_debut_apresmidi'] != null) {
                _availabilities[day]?['afternoon_start'] = _parseTime(availability['heure_debut_apresmidi']);
              }
              if (availability['heure_fin_apresmidi'] != null) {
                _availabilities[day]?['afternoon_end'] = _parseTime(availability['heure_fin_apresmidi']);
              }
            }
          });
        }
      }
    }
  }

  TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
  }

  Future<void> _selectTime(BuildContext context, String day, String period, String type) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _availabilities[day]?['${period}_${type}'] = picked;
      });
    }
  }

  Future<void> _saveAvailabilities() async {
    final authProvider = context.read<AuthProvider>();
    final professionalProvider = context.read<ProfessionalProvider>();
    
    if (professionalProvider.professional == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur: Profil professionnel non chargé'),
          backgroundColor: AppTheme.softRed,
        ),
      );
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
      final professionalId = professionalProvider.professional!['id'];
      
      for (var day in _days) {
        // Si le jour n'est pas disponible, on peut soit le désactiver soit l'ignorer
        if (!_isAvailable[day]!) {
          // Optionnel : désactiver la disponibilité existante
          continue;
        }
        
        final availability = _availabilities[day];
        if (availability?['morning_start'] == null || availability?['morning_end'] == null) {
          continue;
        }

        final data = {
          'professionnel': professionalId,
          'jour': day,
          'heure_debut_matin': _formatTime(availability?['morning_start']),
          'heure_fin_matin': _formatTime(availability?['morning_end']),
          'heure_debut_apresmidi': availability?['afternoon_start'] != null 
              ? _formatTime(availability?['afternoon_start']) 
              : null,
          'heure_fin_apresmidi': availability?['afternoon_end'] != null 
              ? _formatTime(availability?['afternoon_end']) 
              : null,
          'est_disponible': _isAvailable[day],
        };

        print('DEBUG AVAILABILITY - Saving availability for $day: $data');

        // Vérifier si une disponibilité existe déjà pour ce jour
        final existingAvailabilities = professionalProvider.availabilities
            .where((a) => a['jour'] == day).toList();
        
        if (existingAvailabilities.isNotEmpty) {
          // Mettre à jour la disponibilité existante
          await professionalProvider.updateAvailability(existingAvailabilities.first['id'], data);
          print('DEBUG AVAILABILITY - Updated availability for $day');
        } else {
          // Créer une nouvelle disponibilité
          await professionalProvider.createAvailability(data);
          print('DEBUG AVAILABILITY - Created availability for $day');
        }
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Disponibilités sauvegardées avec succès'),
            backgroundColor: AppTheme.healthGreen,
          ),
        );
      }
    } catch (e) {
      print('DEBUG AVAILABILITY - Error saving availabilities: $e');
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
          'Gestion des disponibilités',
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
            onRefresh: _loadExistingAvailabilities,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppTheme.primaryBlue,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Définissez vos horaires de disponibilité pour chaque jour de la semaine',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.darkGray,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _days.length,
                      itemBuilder: (context, index) {
                        final dayDisplayName = _days[index].substring(0, 1).toUpperCase() + 
                            _days[index].substring(1);
                        return _buildDayCard(_days[index], dayDisplayName, index);
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 200),
                    child: CustomButton(
                      text: 'Sauvegarder les disponibilités',
                      onPressed: _saveAvailabilities,
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

  Widget _buildDayCard(String day, String displayName, int index) {
    final availability = _availabilities[day];
    final isAvailable = _isAvailable[day] ?? true;

    return FadeInLeft(
      duration: const Duration(milliseconds: 600),
      delay: Duration(milliseconds: index * 100),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isAvailable ? AppTheme.primaryBlue.withOpacity(0.3) : AppTheme.lightGray,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.darkGray.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isAvailable ? AppTheme.primaryBlue : AppTheme.darkGray,
                  ),
                ),
                Switch(
                  value: isAvailable,
                  onChanged: (value) {
                    setState(() {
                      _isAvailable[day] = value;
                    });
                  },
                  activeColor: AppTheme.primaryBlue,
                ),
              ],
            ),
            
            if (isAvailable) ...[
              const SizedBox(height: 16),
              
              // Matin
              _buildTimeSection(
                'Matin',
                availability?['morning_start'],
                availability?['morning_end'],
                () => _selectTime(context, day, 'morning', 'start'),
                () => _selectTime(context, day, 'morning', 'end'),
              ),
              
              const SizedBox(height: 12),
              
              // Après-midi
              _buildTimeSection(
                'Après-midi',
                availability?['afternoon_start'],
                availability?['afternoon_end'],
                () => _selectTime(context, day, 'afternoon', 'start'),
                () => _selectTime(context, day, 'afternoon', 'end'),
                optional: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSection(
    String label,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    VoidCallback onStartTap,
    VoidCallback onEndTap, {
    bool optional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.darkGray.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onStartTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.lightGray.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: startTime != null 
                          ? AppTheme.primaryBlue 
                          : AppTheme.lightGray,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18,
                        color: startTime != null 
                            ? AppTheme.primaryBlue 
                            : AppTheme.darkGray.withOpacity(0.5),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(startTime),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: startTime != null 
                              ? AppTheme.darkGray 
                              : AppTheme.darkGray.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'à',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkGray.withOpacity(0.5),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: onEndTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.lightGray.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: endTime != null 
                          ? AppTheme.primaryBlue 
                          : AppTheme.lightGray,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18,
                        color: endTime != null 
                            ? AppTheme.primaryBlue 
                            : AppTheme.darkGray.withOpacity(0.5),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(endTime),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: endTime != null 
                              ? AppTheme.darkGray 
                              : AppTheme.darkGray.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
