import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/doctor_card.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/search_bar.dart';

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

  final List<Doctor> _doctors = [
    Doctor(
      id: '1',
      name: 'Dr. Marie Sarr',
      specialty: 'Médecin généraliste',
      rating: 4.8,
      experience: '10 ans',
      availability: 'Disponible aujourd\'hui',
      price: '10 000 FCFA',
      imageUrl: null,
    ),
    Doctor(
      id: '2',
      name: 'Dr. Alassane Ba',
      specialty: 'Pédiatre',
      rating: 4.9,
      experience: '8 ans',
      availability: 'Disponible demain',
      price: '15 000 FCFA',
      imageUrl: null,
    ),
    Doctor(
      id: '3',
      name: 'Mme. Fatou Ndiaye',
      specialty: 'Sage-femme',
      rating: 4.7,
      experience: '12 ans',
      availability: 'Disponible maintenant',
      price: '8 000 FCFA',
      imageUrl: null,
    ),
    Doctor(
      id: '4',
      name: 'Dr. Omar Diop',
      specialty: 'Cardiologue',
      rating: 4.9,
      experience: '15 ans',
      availability: 'Disponible jeudi',
      price: '25 000 FCFA',
      imageUrl: null,
    ),
    Doctor(
      id: '5',
      name: 'M. Abdoulaye Fall',
      specialty: 'Infirmier',
      rating: 4.6,
      experience: '6 ans',
      availability: 'Disponible aujourd\'hui',
      price: '5 000 FCFA',
      imageUrl: null,
    ),
  ];

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

  List<Doctor> get _filteredDoctors {
    if (_selectedCategory == 0) return _doctors;
    
    final category = _categories[_selectedCategory].toLowerCase();
    return _doctors.where((doctor) {
      switch (category) {
        case 'médecins':
          return doctor.specialty.toLowerCase().contains('médecin') ||
                 doctor.specialty.toLowerCase().contains('pédiatre') ||
                 doctor.specialty.toLowerCase().contains('cardiologue');
        case 'sages-femmes':
          return doctor.specialty.toLowerCase().contains('sage-femme');
        case 'infirmiers':
          return doctor.specialty.toLowerCase().contains('infirmier');
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

  void _showBookingDialog(Doctor doctor) {
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
              doctor.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              doctor.specialty,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkGray,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tarif: ${doctor.price}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              doctor.availability,
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

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final String experience;
  final String availability;
  final String price;
  final String? imageUrl;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.experience,
    required this.availability,
    required this.price,
    this.imageUrl,
  });
}
