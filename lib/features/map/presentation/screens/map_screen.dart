import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_button.dart';

class HealthLocation {
  final String id;
  final String name;
  final String type;
  final String address;
  final String distance;
  final double rating;
  final String phone;
  final bool isOpen;

  HealthLocation({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.distance,
    required this.rating,
    required this.phone,
    required this.isOpen,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<HealthLocation> _healthLocations = [];
  String _selectedFilter = 'Tous';

  final List<String> _filterOptions = [
    'Tous',
    'Hôpitaux',
    'Pharmacies',
    'Dispensaires',
    'Urgences',
  ];

  @override
  void initState() {
    super.initState();
    _loadHealthLocations();
  }

  void _loadHealthLocations() {
    _healthLocations.addAll([
      HealthLocation(
        id: '1',
        name: 'Hôpital Principal de Dakar',
        type: 'Hôpital',
        address: 'Avenue Pasteur, Dakar',
        distance: '2.3 km',
        rating: 4.2,
        phone: '+221 33 889 45 67',
        isOpen: true,
      ),
      HealthLocation(
        id: '2',
        name: 'Pharmacie du Plateau',
        type: 'Pharmacie',
        address: 'Boulevard de la Liberation, Dakar',
        distance: '1.1 km',
        rating: 4.5,
        phone: '+221 33 822 56 78',
        isOpen: true,
      ),
      HealthLocation(
        id: '3',
        name: 'Dispensaire de Medina',
        type: 'Dispensaire',
        address: 'Rue 10, Medina, Dakar',
        distance: '3.7 km',
        rating: 3.8,
        phone: '+221 33 834 12 45',
        isOpen: true,
      ),
      HealthLocation(
        id: '4',
        name: 'Centre de Santé de Pikine',
        type: 'Hôpital',
        address: 'Zone A, Pikine',
        distance: '8.2 km',
        rating: 3.9,
        phone: '+221 33 876 54 32',
        isOpen: false,
      ),
      HealthLocation(
        id: '5',
        name: 'Pharmacie 24h',
        type: 'Pharmacie',
        address: 'Plateau, Dakar',
        distance: '0.8 km',
        rating: 4.7,
        phone: '+221 33 845 67 89',
        isOpen: true,
      ),
    ]);
  }

  List<HealthLocation> get _filteredLocations {
    if (_selectedFilter == 'Tous') return _healthLocations;
    return _healthLocations
        .where((location) => location.type == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('Carte des services'),
        backgroundColor: AppTheme.white,
        elevation: 0,
        surfaceTintColor: AppTheme.white,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement search functionality
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filterOptions.length,
              itemBuilder: (context, index) {
                final filter = _filterOptions[index];
                final isSelected = filter == _selectedFilter;
                
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? AppTheme.white : AppTheme.darkGray,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: AppTheme.white,
                    selectedColor: AppTheme.primaryBlue,
                    checkmarkColor: AppTheme.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppTheme.primaryBlue : AppTheme.mediumGray,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Map placeholder
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.mediumGray.withOpacity(0.3),
                ),
              ),
              child: Stack(
                children: [
                  // Map placeholder content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 64,
                          color: AppTheme.darkGray.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Carte interactive',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.darkGray,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Les services de santé près de vous',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.darkGray,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Location markers simulation
                  Positioned(
                    top: 80,
                    left: 120,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.white, width: 2),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    right: 80,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.white, width: 2),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    left: 200,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppTheme.softRed,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Locations List
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.mediumGray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          'Services proches',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_filteredLocations.length} trouvés',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.darkGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Locations List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredLocations.length,
                      itemBuilder: (context, index) {
                        final location = _filteredLocations[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: LocationCard(
                            location: location,
                            onTap: () {
                              // TODO: Show location details
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple LocationCard widget
class LocationCard extends StatelessWidget {
  final HealthLocation location;
  final VoidCallback onTap;

  const LocationCard({
    super.key,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.mediumGray.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getIconColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIcon(),
                  size: 20,
                  color: _getIconColor(),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      location.address,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.darkGray,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          location.distance,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.primaryBlue,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              location.rating.toString(),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: location.isOpen ? AppTheme.secondaryGreen.withOpacity(0.1) : AppTheme.mediumGray.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            location.isOpen ? 'Ouvert' : 'Fermé',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: location.isOpen ? AppTheme.secondaryGreen : AppTheme.darkGray,
                              fontSize: 8,
                            ),
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
      ),
    );
  }

  Color _getIconColor() {
    switch (location.type) {
      case 'Hôpital':
        return AppTheme.softRed;
      case 'Pharmacie':
        return AppTheme.secondaryGreen;
      case 'Dispensaire':
        return AppTheme.primaryBlue;
      case 'Urgences':
        return Colors.orange;
      default:
        return AppTheme.primaryBlue;
    }
  }

  IconData _getIcon() {
    switch (location.type) {
      case 'Hôpital':
        return Icons.local_hospital;
      case 'Pharmacie':
        return Icons.local_pharmacy;
      case 'Dispensaire':
        return Icons.medical_services;
      case 'Urgences':
        return Icons.emergency;
      default:
        return Icons.location_on;
    }
  }
}
