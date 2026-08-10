import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class StatsOverviewCard extends StatelessWidget {
  final int totalPatients;
  final int totalAppointments;
  final double averageRating;

  const StatsOverviewCard({
    super.key,
    required this.totalPatients,
    required this.totalAppointments,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkGray.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppTheme.lightGray.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Statistiques d\'activité',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'Patients',
                  totalPatients.toString(),
                  Icons.people_outline,
                  AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Rendez-vous',
                  totalAppointments.toString(),
                  Icons.calendar_today_outlined,
                  AppTheme.healthGreen,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          _buildRatingItem(context),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const Spacer(),
              Icon(
                Icons.trending_up,
                color: color.withOpacity(0.6),
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.darkGray.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingItem(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.alertRed.withOpacity(0.05),
            AppTheme.alertRed.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.alertRed.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: AppTheme.alertRed,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.alertRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Note moyenne',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.darkGray.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              return Icon(
                index < averageRating.floor() ? Icons.star : Icons.star_border,
                color: AppTheme.alertRed,
                size: 16,
              );
            }),
          ),
        ],
      ),
    );
  }
}
