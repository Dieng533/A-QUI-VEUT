import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AvailabilityCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Map<String, dynamic>> availabilities;
  final bool isEditing;
  final Function(List<Map<String, dynamic>>) onSave;

  const AvailabilityCard({
    super.key,
    required this.title,
    required this.icon,
    required this.availabilities,
    required this.isEditing,
    required this.onSave,
  });

  @override
  State<AvailabilityCard> createState() => _AvailabilityCardState();
}

class _AvailabilityCardState extends State<AvailabilityCard> {
  late List<Map<String, dynamic>> _availabilities;
  late Map<String, List<TimeOfDay>> _dayAvailabilities;

  @override
  void initState() {
    super.initState();
    _availabilities = List.from(widget.availabilities);
    _initializeDayAvailabilities();
  }

  void _initializeDayAvailabilities() {
    _dayAvailabilities = {};
    final days = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    
    for (String day in days) {
      _dayAvailabilities[day] = [];
      
      // Extract availabilities for this day
      final dayAvailabilities = _availabilities.where((a) => a['jour'] == day).toList();
      for (var availability in dayAvailabilities) {
        final startTime = _parseTime(availability['heure_debut']);
        final endTime = _parseTime(availability['heure_fin']);
        if (startTime != null && endTime != null) {
          _dayAvailabilities[day]!.add(startTime);
          _dayAvailabilities[day]!.add(endTime);
        }
      }
    }
  }

  TimeOfDay? _parseTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;
    
    final parts = timeString.split(':');
    if (parts.length != 2) return null;
    
    try {
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    widget.icon,
                    color: AppTheme.primaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGray,
                    ),
                  ),
                ),
                if (widget.isEditing)
                  TextButton(
                    onPressed: _saveChanges,
                    child: Text(
                      'Enregistrer',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche']
                  .asMap()
                  .entries
                  .map((entry) {
                    final index = entry.key;
                    final day = entry.value;
                    return Column(
                      children: [
                        if (index > 0) const SizedBox(height: 16),
                        _buildDaySchedule(day),
                      ],
                    );
                  })
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySchedule(String day) {
    final dayTimes = _dayAvailabilities[day] ?? [];
    final isAvailable = dayTimes.isNotEmpty;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.mediumGray.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                day,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
              const Spacer(),
              if (widget.isEditing)
                Switch(
                  value: isAvailable,
                  onChanged: (value) {
                    setState(() {
                      if (value) {
                        _dayAvailabilities[day] = [
                          const TimeOfDay(hour: 9, minute: 0),
                          const TimeOfDay(hour: 17, minute: 0),
                        ];
                      } else {
                        _dayAvailabilities[day] = [];
                      }
                    });
                  },
                ),
            ],
          ),
          
          if (isAvailable) ...[
            const SizedBox(height: 12),
            if (widget.isEditing)
              _buildEditableTimeSlots(day, dayTimes)
            else
              _buildReadOnlyTimeSlots(dayTimes),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              'Non disponible',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkGray.withOpacity(0.5),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReadOnlyTimeSlots(List<TimeOfDay> times) {
    if (times.isEmpty) return const SizedBox.shrink();
    
    final timeSlots = <String>[];
    for (int i = 0; i < times.length; i += 2) {
      if (i + 1 < times.length) {
        timeSlots.add('${_formatTime(times[i])} - ${_formatTime(times[i + 1])}');
      }
    }
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: timeSlots.map((slot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryBlue.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            slot,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEditableTimeSlots(String day, List<TimeOfDay> times) {
    final timeSlots = <Pair<TimeOfDay, TimeOfDay>>[];
    
    for (int i = 0; i < times.length; i += 2) {
      if (i + 1 < times.length) {
        timeSlots.add(Pair(times[i], times[i + 1]));
      }
    }
    
    return Column(
      children: [
        ...timeSlots.asMap().entries.map((entry) {
          final index = entry.key;
          final slot = entry.value;
          return Column(
            children: [
              if (index > 0) const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppTheme.mediumGray.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _formatTime(slot.first),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.darkGray,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'à',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.darkGray.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppTheme.mediumGray.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _formatTime(slot.second),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.darkGray,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _removeTimeSlot(day, index),
                    icon: const Icon(Icons.remove_circle, color: AppTheme.softRed),
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
            ],
          );
        }).toList(),
        
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () => _addTimeSlot(day),
          icon: const Icon(Icons.add, size: 16),
          label: Text(
            'Ajouter un créneau',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _addTimeSlot(String day) {
    setState(() {
      final dayTimes = _dayAvailabilities[day] ?? [];
      dayTimes.addAll([
        const TimeOfDay(hour: 9, minute: 0),
        const TimeOfDay(hour: 17, minute: 0),
      ]);
      _dayAvailabilities[day] = dayTimes;
    });
  }

  void _removeTimeSlot(String day, int index) {
    setState(() {
      final dayTimes = _dayAvailabilities[day] ?? [];
      final startIndex = index * 2;
      if (startIndex + 1 < dayTimes.length) {
        dayTimes.removeRange(startIndex, startIndex + 2);
        _dayAvailabilities[day] = dayTimes;
      }
    });
  }

  void _saveChanges() {
    final updatedAvailabilities = <Map<String, dynamic>>[];
    
    _dayAvailabilities.forEach((day, times) {
      for (int i = 0; i < times.length; i += 2) {
        if (i + 1 < times.length) {
          updatedAvailabilities.add({
            'jour': day,
            'heure_debut': _formatTime(times[i]),
            'heure_fin': _formatTime(times[i + 1]),
            'disponible': true,
          });
        }
      }
    });
    
    widget.onSave(updatedAvailabilities);
  }
}

class Pair<T, U> {
  final T first;
  final U second;
  
  Pair(this.first, this.second);
}
