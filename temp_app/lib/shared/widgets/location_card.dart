import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/theme/app_theme.dart';
import 'custom_button.dart';

class HealthLocation {
  final String id;
  final String name;
  final String type;
  final String address;
  final String distance;
  final double rating;
  final String phone;
  final LatLng position;
  final bool isOpen;

  HealthLocation({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.distance,
    required this.rating,
    required this.phone,
    required this.position,
    required this.isOpen,
  });
}

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
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.mediumGray.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _getTypeColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getTypeIcon(),
                      size: 16,
                      color: _getTypeColor(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      location.type,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _getTypeColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Name
              Text(
                location.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 4),
              
              // Distance
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: AppTheme.darkGray,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    location.distance,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkGray,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Rating and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location.rating.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: location.isOpen
                          ? AppTheme.secondaryGreen.withOpacity(0.1)
                          : AppTheme.softRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      location.isOpen ? 'Ouvert' : 'Fermé',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: location.isOpen
                            ? AppTheme.secondaryGreen
                            : AppTheme.softRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Action Button
              CustomButton(
                text: 'Itinéraire',
                onPressed: onTap,
                type: ButtonType.outlined,
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (location.type) {
      case 'Hôpital':
        return AppTheme.softRed;
      case 'Pharmacie':
        return AppTheme.secondaryGreen;
      case 'Dispensaire':
        return Colors.orange;
      default:
        return AppTheme.primaryBlue;
    }
  }

  IconData _getTypeIcon() {
    switch (location.type) {
      case 'Hôpital':
        return Icons.local_hospital;
      case 'Pharmacie':
        return Icons.local_pharmacy;
      case 'Dispensaire':
        return Icons.medical_services;
      default:
        return Icons.location_on;
    }
  }
}


