import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final VoidCallback onTap;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appointmentDate = DateTime.parse(appointment['date_heure'] ?? DateTime.now().toIso8601String());
    final isToday = _isToday(appointmentDate);
    final status = appointment['statut'] ?? 'en_attente';
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.darkGray.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isToday ? AppTheme.primaryBlue.withOpacity(0.3) : AppTheme.lightGray.withOpacity(0.3),
            width: isToday ? 2 : 1,
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
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getStatusIcon(status),
                    color: _getStatusColor(status),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment['patient_nom'] ?? 'Patient non spécifié',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDateTime(appointmentDate),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.darkGray.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isToday)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Aujourd\'hui',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatusChip(context, status),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.darkGray.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  String _formatDateTime(DateTime dateTime) {
    final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    final months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jui', 'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    
    return '${days[dateTime.weekday - 1]} ${dateTime.day} ${months[dateTime.month - 1]} à ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'en_attente':
        return Icons.pending;
      case 'confirme':
        return Icons.check_circle;
      case 'annule':
        return Icons.cancel;
      case 'termine':
        return Icons.done_all;
      default:
        return Icons.help_outline;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'en_attente':
        return AppTheme.alertRed;
      case 'confirme':
        return AppTheme.primaryBlue;
      case 'annule':
        return AppTheme.softRed;
      case 'termine':
        return AppTheme.healthGreen;
      default:
        return AppTheme.darkGray;
    }
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusText(status),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: _getStatusColor(status),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'en_attente':
        return 'En attente';
      case 'confirme':
        return 'Confirmé';
      case 'annule':
        return 'Annulé';
      case 'termine':
        return 'Terminé';
      default:
        return 'Inconnu';
    }
  }
}
