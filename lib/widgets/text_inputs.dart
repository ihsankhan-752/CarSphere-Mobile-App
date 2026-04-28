import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class AuthTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool? isPassword;
  const AuthTextInput({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.backgroundDark,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: isPassword ?? false,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.grey, size: 20),
            hintText: hint,
            filled: true,
            fillColor: AppColors.backgroundLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorStyle: const TextStyle(height: 0.8),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your ${label.toLowerCase()}';
            }
            if (label.toLowerCase().contains('email')) {
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email';
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}
