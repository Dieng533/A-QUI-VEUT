import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../../../data/providers/professional_provider.dart';
import '../../../../shared/widgets/doctor_card.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/search_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  final List<String> _categories = [
    'Tous',
    'Médecins',
    'Sages-femmes',
    'Infirmiers',
  ];

  int _selectedCategory = 0;

  List<Map<String, dynamic>> _professionals = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProfessionals();
  }

  Future<void> _loadProfessionals() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final professionalProvider = context.read<ProfessionalProvider>();
      await professionalProvider.getProfessionals();
      
      if (mounted) {
        setState(() {
          _professionals = professionalProvider.professionals;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('DEBUG APPOINTMENTS - Error loading professionals: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredProfessionals {
    if (_selectedCategory == 0) return _professionals;
    
    final category = _categories[_selectedCategory].toLowerCase();
    return _professionals.where((professional) {
      final specialite = professional['specialite']?.toString().toLowerCase() ?? '';
      
      switch (category) {
        case 'médecins':
          return specialite.contains('medecin') ||
                 specialite.contains('pediatre') ||
                 specialite.contains('cardiologue') ||
                 specialite.contains('gynecologue') ||
                 specialite.contains('dermatologue') ||
                 specialite.contains('ophtalmologue') ||
                 specialite.contains('radiologue') ||
                 specialite.contains('biologiste');
        case 'sages-femmes':
          return specialite.contains('sage_femme');
        case 'infirmiers':
          return specialite.contains('infirmier');
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('Prendre rendez-vous'),
        backgroundColor: AppTheme.white,
        elevation: 0,
        surfaceTintColor: AppTheme.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FadeInDown(
              duration: const Duration(milliseconds: 800),
              child: CustomSearchBar(
                hintText: 'Rechercher un professionnel...',
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),

          // Categories
          FadeInLeft(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 200),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(_categories[index]),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = index;
                        });
                      },
                      backgroundColor: AppTheme.lightGray,
                      selectedColor: AppTheme.primaryBlue.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primaryBlue : AppTheme.darkGray,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: isSelected ? AppTheme.primaryBlue : AppTheme.mediumGray,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Professionals List
          Expanded(
            child: _isLoading
                ? const Center(child: LoadingWidget())
                : _professionals.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: AppTheme.mediumGray,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aucun professionnel disponible',
                              style: TextStyle(
                                color: AppTheme.darkGray,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        delay: const Duration(milliseconds: 400),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _filteredProfessionals.length,
                          itemBuilder: (context, index) {
                            final professional = _filteredProfessionals[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: DoctorCard(
                                doctor: professional,
                                onTap: () => _showBookingDialog(professional),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog(Map<String, dynamic> professional) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Confirmer le rendez-vous',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${professional['nom']} ${professional['prenom']}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              professional['specialite'] ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkGray,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              professional['ville'] ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkGray,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Statut: ${professional['statut'] == 'actif' ? 'Actif' : 'Inactif'}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: professional['statut'] == 'actif' ? AppTheme.secondaryGreen : AppTheme.softRed,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          CustomButton(
            text: 'Confirmer',
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage();
            },
            type: ButtonType.primary,
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Rendez-vous confirmé avec succès!'),
        backgroundColor: AppTheme.secondaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

