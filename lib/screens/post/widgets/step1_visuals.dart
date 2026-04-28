import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../widgets/image_upload_card.dart';

class Step1Visuals extends StatelessWidget {
  final XFile? mainImage;
  final XFile? interiorImage;
  final XFile? engineImage;
  final Function(String) onPickImage;
  final Function(String) onRemoveImage;

  const Step1Visuals({
    super.key,
    required this.mainImage,
    required this.interiorImage,
    required this.engineImage,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Capture the Details',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
              'High-quality photos increase buyer interest by up to 80%. Show your car from all angles.',
              style: TextStyle(color: AppColors.grey, fontSize: 14)),
          const SizedBox(height: 30),
          ImageUploadCard(
            title: 'Upload Photos',
            subtitle: 'Main thumbnail image',
            icon: Icons.camera_alt_outlined,
            imageFile: mainImage,
            onTap: () => onPickImage('main'),
            onRemove: () => onRemoveImage('main'),
            isLarge: true,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ImageUploadCard(
                  title: 'INTERIOR',
                  icon: Icons.add_circle_outline,
                  imageFile: interiorImage,
                  onTap: () => onPickImage('interior'),
                  onRemove: () => onRemoveImage('interior'),
                  isLarge: false,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ImageUploadCard(
                  title: 'ENGINE',
                  icon: Icons.add_circle_outline,
                  imageFile: engineImage,
                  onTap: () => onPickImage('engine'),
                  onRemove: () => onRemoveImage('engine'),
                  isLarge: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F2C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline,
                    color: AppColors.primary, size: 24),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Pro Tip',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      SizedBox(height: 8),
                      Text(
                          'Take photos in natural daylight and clear the interior for a professional showroom look.',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
