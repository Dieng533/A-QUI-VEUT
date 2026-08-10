import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SpecialtyCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<String> specialties;
  final bool isEditing;
  final Function(List<String>) onSave;

  const SpecialtyCard({
    super.key,
    required this.title,
    required this.icon,
    required this.specialties,
    required this.isEditing,
    required this.onSave,
  });

  @override
  State<SpecialtyCard> createState() => _SpecialtyCardState();
}

class _SpecialtyCardState extends State<SpecialtyCard> {
  late List<String> _specialties;
  late TextEditingController _newSpecialtyController;

  @override
  void initState() {
    super.initState();
    _specialties = List.from(widget.specialties);
    _newSpecialtyController = TextEditingController();
  }

  @override
  void dispose() {
    _newSpecialtyController.dispose();
    super.dispose();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Specialties list
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _specialties.asMap().entries.map((entry) {
                    final index = entry.key;
                    final specialty = entry.value;
                    
                    return _buildSpecialtyChip(specialty, index);
                  }).toList(),
                ),
                
                // Add new specialty
                if (widget.isEditing) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _newSpecialtyController,
                          decoration: InputDecoration(
                            hintText: 'Ajouter une spécialité',
                            filled: true,
                            fillColor: AppTheme.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppTheme.mediumGray.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppTheme.mediumGray.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppTheme.primaryBlue,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _addSpecialty,
                        icon: const Icon(Icons.add_circle),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: AppTheme.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtyChip(String specialty, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.medical_services,
            size: 16,
            color: AppTheme.primaryBlue,
          ),
          const SizedBox(width: 6),
          Text(
            specialty,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (widget.isEditing) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => _removeSpecialty(index),
              child: Icon(
                Icons.close,
                size: 16,
                color: AppTheme.softRed,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _addSpecialty() {
    final newSpecialty = _newSpecialtyController.text.trim();
    if (newSpecialty.isNotEmpty && !_specialties.contains(newSpecialty)) {
      setState(() {
        _specialties.add(newSpecialty);
        _newSpecialtyController.clear();
      });
    }
  }

  void _removeSpecialty(int index) {
    setState(() {
      _specialties.removeAt(index);
    });
  }

  void _saveChanges() {
    widget.onSave(_specialties);
  }
}
