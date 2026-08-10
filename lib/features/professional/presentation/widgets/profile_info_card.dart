import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileInfoCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Map<String, dynamic>> fields;
  final bool isEditing;
  final Function(Map<String, String>) onSave;

  const ProfileInfoCard({
    super.key,
    required this.title,
    required this.icon,
    required this.fields,
    required this.isEditing,
    required this.onSave,
  });

  @override
  State<ProfileInfoCard> createState() => _ProfileInfoCardState();
}

class _ProfileInfoCardState extends State<ProfileInfoCard> {
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {};
    for (var field in widget.fields) {
      _controllers[field['label']] = TextEditingController(text: field['value'] ?? '');
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
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
          
          // Fields
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: widget.fields.asMap().entries.map((entry) {
                final index = entry.key;
                final field = entry.value;
                final controller = _controllers[field['label']];
                
                return Column(
                  children: [
                    if (index > 0) const SizedBox(height: 16),
                    _buildField(field, controller!),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(Map<String, dynamic> field, TextEditingController controller) {
    final isEditable = field['editable'] ?? false;
    final isMultiline = field['multiline'] ?? false;
    
    if (!widget.isEditing || !isEditable) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field['label'],
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.darkGray.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.lightGray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.mediumGray.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              controller.text.isNotEmpty ? controller.text : 'Non renseigné',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: controller.text.isNotEmpty 
                    ? AppTheme.darkGray 
                    : AppTheme.darkGray.withOpacity(0.5),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field['label'],
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.darkGray.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: isMultiline ? 3 : 1,
          decoration: InputDecoration(
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
      ],
    );
  }

  void _saveChanges() {
    final updatedData = <String, String>{};
    
    for (var field in widget.fields) {
      if (field['editable'] == true) {
        updatedData[field['label']] = _controllers[field['label']]?.text ?? '';
      }
    }
    
    widget.onSave(updatedData);
  }
}
