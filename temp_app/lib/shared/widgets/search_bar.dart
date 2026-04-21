import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    this.onTap,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.lightGray,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.mediumGray.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: AppTheme.darkGray,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: controller != null
                  ? TextField(
                      controller: controller,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.darkGray,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  : Text(
                      hintText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.darkGray,
                      ),
                    ),
            ),
            if (onTap != null)
              Icon(
                Icons.tune,
                color: AppTheme.primaryBlue,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
