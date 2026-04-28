import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SpecItemCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const SpecItemCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.grey),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.backgroundDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
