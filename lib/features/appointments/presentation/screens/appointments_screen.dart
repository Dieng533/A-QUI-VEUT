import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/doctor_card.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/search_bar.dart';
import '../../../../shared/data/mock_data.dart';

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

  final List<Map<String, dynamic>> _doctors = MockData.doctors;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredDoctors {
    if (_selectedCategory == 0) return _doctors;
    
    final category = _categories[_selectedCategory].toLowerCase();
    return _doctors.where((doctor) {
      switch (category) {
        case 'médecins':
          return doctor['specialty'].toString().toLowerCase().contains('médecin') ||
                 doctor['specialty'].toString().toLowerCase().contains('pédiatre') ||
                 doctor['specialty'].toString().toLowerCase().contains('cardiologue') ||
                 doctor['specialty'].toString().toLowerCase().contains('gynécologue') ||
                 doctor['specialty'].toString().toLowerCase().contains('dermatologue');
        case 'sages-femmes':
          return doctor['specialty'].toString().toLowerCase().contains('sage-femme');
        case 'infirmiers':
          return doctor['specialty'].toString().toLowerCase().contains('infirmier');
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

          // Doctors List
          Expanded(
            child: FadeInUp(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 400),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filteredDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = _filteredDoctors[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: DoctorCard(
                      doctor: doctor,
                      onTap: () => _showBookingDialog(doctor),
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

  void _showBookingDialog(Map<String, dynamic> doctor) {
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
              doctor['name'],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              doctor['specialty'],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkGray,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tarif: ${doctor['price']}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              doctor['availability'] == true ? 'Disponible' : 'Indisponible',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryGreen,
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

