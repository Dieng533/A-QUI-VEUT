import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/location_card.dart';

// Import conditionnel pour Google Maps
import 'package:google_maps_flutter/google_maps_flutter.dart' 
    if (dart.library.html) 'package:google_maps_flutter/google_maps_flutter_web.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  bool _isLoading = true;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  final List<HealthLocation> _healthLocations = [];

  final List<String> _filterOptions = [
    'Tous',
    'Hôpitaux',
    'Pharmacies',
    'Dispensaires',
    'Urgences',
  ];

  String _selectedFilter = 'Tous';

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationPermissionDenied();
          return;
        }
      }

      // Get current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      _generateMockHealthLocations();
      _addMarkersToMap();

    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorMessage('Impossible de récupérer votre position');
    }
  }

  void _generateMockHealthLocations() {
    // Mock health locations around Dakar
    _healthLocations.addAll([
      HealthLocation(
        id: '1',
        name: 'Hôpital Principal de Dakar',
        type: 'Hôpital',
        address: 'Avenue Pasteur, Dakar',
        distance: '2.3 km',
        rating: 4.2,
        phone: '+221 33 889 45 00',
        position: const LatLng(14.6928, -17.4467),
        isOpen: true,
      ),
      HealthLocation(
        id: '2',
        name: 'Pharmacie du Centenaire',
        type: 'Pharmacie',
        address: 'Boulevard de la Liberation, Dakar',
        distance: '1.1 km',
        rating: 4.5,
        phone: '+221 33 822 56 78',
        position: const LatLng(14.6928, -17.4367),
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
        position: const LatLng(14.6828, -17.4267),
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
        position: const LatLng(14.7528, -17.3867),
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
        position: const LatLng(14.7028, -17.4567),
        isOpen: true,
      ),
    ]);
  }

  void _addMarkersToMap() {
    _markers.clear();

    // Add health location markers
    for (final location in _healthLocations) {
      if (_selectedFilter == 'Tous' || location.type == _selectedFilter) {
        _markers.add(
          Marker(
            markerId: MarkerId(location.id),
            position: location.position,
            infoWindow: InfoWindow(
              title: location.name,
              snippet: '${location.type} • ${location.distance}',
            ),
            icon: _getMarkerIcon(location.type),
          ),
        );
      }
    }

    // Add current location marker
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: const InfoWindow(
            title: 'Votre position',
            snippet: 'Vous êtes ici',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
        ),
      );
    }

    setState(() {});
  }

  BitmapDescriptor _getMarkerIcon(String type) {
    switch (type) {
      case 'Hôpital':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'Pharmacie':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'Dispensaire':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      default:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    
    // Move camera to current location
    if (_currentPosition != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
            zoom: 13,
          ),
        ),
      );
    }
  }

  void _showLocationPermissionDenied() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission requise'),
        content: const Text(
          'Veuillez activer la localisation pour trouver les services de santé près de vous.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          CustomButton(
            text: 'Paramètres',
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openAppSettings();
            },
          ),
        ],
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.softRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
                        _addMarkersToMap();
                      },
                      backgroundColor: AppTheme.white,
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
        ),

        // Map
        Positioned.fill(
          child: _currentPosition != null
              ? GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    zoom: 13,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                )
              : Container(
                  color: AppTheme.lightGray,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),

        // Current Location Button
        Positioned(
          bottom: 140,
          right: 16,
          child: FadeInRight(
            duration: const Duration(milliseconds: 800),
            child: FloatingActionButton(
              onPressed: () async {
                if (_currentPosition != null && _mapController != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                        ),
                        zoom: 15,
                      ),
                    ),
                  );
                }
              },
              backgroundColor: AppTheme.white,
              child: Icon(
                Icons.my_location,
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
        ),

        // Health Locations List
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: Container(
              height: 120,
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
                  
                  // Locations List
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredLocations.length,
                      itemBuilder: (context, index) {
                        final location = _filteredLocations[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
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
        ),
      ],
    ),
  );
}
