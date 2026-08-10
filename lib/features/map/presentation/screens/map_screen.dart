import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';

class HealthLocation {
  final String id;
  final String name;
  final String type;
  final String address;
  final String distance;
  final double rating;
  final String phone;
  final bool isOpen;
  final double latitude;
  final double longitude;
  final String? description;

  HealthLocation({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.distance,
    required this.rating,
    required this.phone,
    required this.isOpen,
    required this.latitude,
    required this.longitude,
    this.description,
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
  HealthLocation? _selectedLocation;

  final List<String> _filterOptions = [
    'Tous',
    'Hôpitaux',
    'Pharmacies',
    'Dispensaires',
    'Urgences',
  ];

  // Coordonnées de Saint-Louis, Sénégal
  static const double _saintLouisLat = 16.0196663;
  static const double _saintLouisLng = -16.4616104;

  @override
  void initState() {
    super.initState();
    _loadHealthLocations();
  }

  void _loadHealthLocations() {
    _healthLocations.addAll([
      // Hôpitaux et structures de santé à Saint-Louis avec coordonnées réelles
      HealthLocation(
        id: '1',
        name: 'Hôpital Régional de Saint-Louis',
        type: 'Hôpital',
        address: 'Boulevard de la République, Saint-Louis',
        distance: '0.5 km',
        rating: 4.3,
        phone: '+221 33 961 23 45',
        isOpen: true,
        latitude: 16.0188,
        longitude: -16.4622,
        description: 'Principal hôpital de la région',
      ),
      HealthLocation(
        id: '2',
        name: 'Centre de Santé Sor',
        type: 'Dispensaire',
        address: 'Quartier Sor, Saint-Louis',
        distance: '2.1 km',
        rating: 3.9,
        phone: '+221 33 961 45 67',
        isOpen: true,
        latitude: 16.0212,
        longitude: -16.4589,
        description: 'Centre de santé primaire',
      ),
      HealthLocation(
        id: '3',
        name: 'Pharmacie de la Gare',
        type: 'Pharmacie',
        address: 'Avenue Charles de Gaulle, Saint-Louis',
        distance: '0.8 km',
        rating: 4.6,
        phone: '+221 33 961 78 90',
        isOpen: true,
        latitude: 16.0201,
        longitude: -16.4601,
        description: 'Pharmacie près de la gare',
      ),
      HealthLocation(
        id: '4',
        name: 'Pharmacie Ndiolofène',
        type: 'Pharmacie',
        address: 'Quartier Ndiolofène, Saint-Louis',
        distance: '1.5 km',
        rating: 4.4,
        phone: '+221 33 961 23 78',
        isOpen: true,
        latitude: 16.0175,
        longitude: -16.4645,
        description: 'Pharmacie de quartier',
      ),
      HealthLocation(
        id: '5',
        name: 'Pharmacie du Marché',
        type: 'Pharmacie',
        address: 'Près du marché central, Saint-Louis',
        distance: '1.2 km',
        rating: 4.2,
        phone: '+221 33 961 56 34',
        isOpen: true,
        latitude: 16.0199,
        longitude: -16.4598,
        description: 'Pharmacie du marché central',
      ),
      HealthLocation(
        id: '6',
        name: 'Poste de Santé de Pikine',
        type: 'Dispensaire',
        address: 'Quartier Pikine, Saint-Louis',
        distance: '3.8 km',
        rating: 3.7,
        phone: '+221 33 961 89 12',
        isOpen: true,
        latitude: 16.0234,
        longitude: -16.4667,
        description: 'Poste de santé de Pikine',
      ),
      HealthLocation(
        id: '7',
        name: 'Centre de Santé de Guet Ndar',
        type: 'Dispensaire',
        address: 'Île de Guet Ndar, Saint-Louis',
        distance: '2.5 km',
        rating: 4.0,
        phone: '+221 33 961 34 56',
        isOpen: true,
        latitude: 16.0167,
        longitude: -16.4789,
        description: 'Centre de santé sur l\'île',
      ),
      HealthLocation(
        id: '8',
        name: 'Pharmacie de l\'Amitié',
        type: 'Pharmacie',
        address: 'Rue Abdoulaye Wade, Saint-Louis',
        distance: '1.8 km',
        rating: 4.5,
        phone: '+221 33 961 67 89',
        isOpen: true,
        latitude: 16.0218,
        longitude: -16.4634,
        description: 'Pharmacie de l\'Amitié',
      ),
      HealthLocation(
        id: '9',
        name: 'Dispensaire de Lodo',
        type: 'Dispensaire',
        address: 'Quartier Lodo, Saint-Louis',
        distance: '4.2 km',
        rating: 3.8,
        phone: '+221 33 961 45 23',
        isOpen: true,
        latitude: 16.0145,
        longitude: -16.4698,
        description: 'Dispensaire de Lodo',
      ),
      HealthLocation(
        id: '10',
        name: 'Pharmacie Saint-Louis 24h',
        type: 'Pharmacie',
        address: 'Boulevard de la République, Saint-Louis',
        distance: '0.6 km',
        rating: 4.7,
        phone: '+221 33 961 12 34',
        isOpen: true,
        latitude: 16.0192,
        longitude: -16.4615,
        description: 'Pharmacie ouverte 24h/24',
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
        title: const Text('Services de santé - Saint-Louis'),
        backgroundColor: AppTheme.white,
        elevation: 0,
        surfaceTintColor: AppTheme.white,
        actions: [
          IconButton(
            onPressed: () {
              _openGoogleMaps();
            },
            icon: const Icon(Icons.map),
            tooltip: 'Ouvrir dans Google Maps',
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

          // Interactive Map View
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // Background map image
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blue.shade50,
                            Colors.green.shade50,
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_city,
                              size: 64,
                              color: Colors.blueGrey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Vue de Saint-Louis',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Cliquez sur un marqueur pour voir les détails',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Interactive markers
                    ..._filteredLocations.map((location) {
                      return _buildMarker(location);
                    }).toList(),
                    
                    // Selected location details
                    if (_selectedLocation != null)
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: _buildLocationCard(_selectedLocation!),
                      ),
                  ],
                ),
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
                              _showLocationDetails(location);
                            },
                            onMapTap: () {
                              setState(() {
                                _selectedLocation = location;
                              });
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

  Widget _buildMarker(HealthLocation location) {
    // Convertir les coordonnées GPS en positions sur l'écran
    double x = ((location.longitude - _saintLouisLng) * 10000) + 200;
    double y = ((location.latitude - _saintLouisLat) * -10000) + 150;
    
    // Limiter les positions dans les bornes de l'écran
    x = x.clamp(20.0, 380.0);
    y = y.clamp(20.0, 280.0);
    
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLocation = location;
          });
        },
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _getMarkerColor(location.type),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            _getMarkerIcon(location.type),
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(HealthLocation location) {
    return FadeInUp(
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getIconColor(location.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getIcon(location.type),
                    size: 20,
                    color: _getIconColor(location.type),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        location.type,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedLocation = null;
                    });
                  },
                  icon: const Icon(Icons.close),
                  iconSize: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              location.address,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  location.phone,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '${location.rating}/5.0',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _callPhone(location.phone),
                    icon: const Icon(Icons.phone, size: 16),
                    label: const Text('Appeler'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 36),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openInGoogleMaps(location),
                    icon: const Icon(Icons.map, size: 16),
                    label: const Text('Maps'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 36),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getMarkerColor(String type) {
    switch (type) {
      case 'Hôpital':
        return Colors.red;
      case 'Pharmacie':
        return Colors.green;
      case 'Dispensaire':
        return Colors.blue;
      case 'Urgences':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _getMarkerIcon(String type) {
    switch (type) {
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

  Color _getIconColor(String type) {
    switch (type) {
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

  IconData _getIcon(String type) {
    switch (type) {
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

  void _showLocationDetails(HealthLocation location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.mediumGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Header
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _getIconColor(location.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIcon(location.type),
                      size: 24,
                      color: _getIconColor(location.type),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          location.type,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.darkGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: location.isOpen ? AppTheme.secondaryGreen.withOpacity(0.1) : AppTheme.mediumGray.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      location.isOpen ? 'Ouvert' : 'Fermé',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: location.isOpen ? AppTheme.secondaryGreen : AppTheme.darkGray,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Info
              _buildInfoRow(Icons.location_on, 'Adresse', location.address),
              _buildInfoRow(Icons.phone, 'Téléphone', location.phone),
              _buildInfoRow(Icons.star, 'Note', '${location.rating}/5.0'),
              _buildInfoRow(Icons.directions, 'Distance', location.distance),
              _buildInfoRow(Icons.map, 'Coordonnées', '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}'),
              
              if (location.description != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  location.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.darkGray,
                  ),
                ),
              ],
              
              const Spacer(),
              
              // Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _openInGoogleMaps(location),
                      icon: const Icon(Icons.map),
                      label: const Text('Google Maps'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: AppTheme.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _callPhone(location.phone),
                      icon: const Icon(Icons.phone),
                      label: const Text('Appeler'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryGreen,
                        foregroundColor: AppTheme.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.darkGray),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkGray,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _callPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible d\'appeler $phone')),
        );
      }
    }
  }

  void _openInGoogleMaps(HealthLocation location) async {
    final Uri googleMapsUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      query: 'api=1&query=${location.latitude},${location.longitude}',
    );
    
    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir Google Maps')),
        );
      }
    }
  }

  void _openGoogleMaps() async {
    final Uri googleMapsUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      query: 'api=1&query=Saint-Louis+Sénégal+pharmacie',
    );
    
    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir Google Maps')),
        );
      }
    }
  }
}

// Simple LocationCard widget
class LocationCard extends StatelessWidget {
  final HealthLocation location;
  final VoidCallback onTap;
  final VoidCallback onMapTap;

  const LocationCard({
    super.key,
    required this.location,
    required this.onTap,
    required this.onMapTap,
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
              
              // Map button
              IconButton(
                onPressed: onMapTap,
                icon: const Icon(Icons.map, size: 16),
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
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
