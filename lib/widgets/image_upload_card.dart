import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/constants/app_colors.dart';

class ImageUploadCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final XFile? imageFile;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final bool isLarge;

  const ImageUploadCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.imageFile,
    required this.onTap,
    required this.onRemove,
    required this.isLarge,
  });

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: isLarge ? 200 : 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: FileImage(File(imageFile!.path)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: isLarge ? 200 : 120,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: AppColors.primary.withOpacity(0.1), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: AppColors.primary, size: isLarge ? 30 : 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isLarge ? 16 : 12),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 5),
              Text(
                subtitle!,
                style:
                    const TextStyle(color: AppColors.grey, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
