import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../widgets/custom_form_field.dart';

class Step2BasicDetails extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController companyController;
  final TextEditingController modelController;
  final TextEditingController colorController;
  final TextEditingController descriptionController;

  const Step2BasicDetails({
    super.key,
    required this.titleController,
    required this.companyController,
    required this.modelController,
    required this.colorController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Basic Details',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text('Provide general information about the car.',
              style: TextStyle(color: AppColors.grey)),
          const SizedBox(height: 30),
          CustomFormField(
              label: 'Listing Title',
              hint: 'e.g. Pristine Lamborghini Aventador',
              controller: titleController),
          const SizedBox(height: 15),
          CustomFormField(
              label: 'Car Brand/Company',
              hint: 'e.g. Lamborghini',
              controller: companyController),
          const SizedBox(height: 15),
          CustomFormField(
              label: 'Car Model',
              hint: 'e.g. Aventador',
              controller: modelController),
          const SizedBox(height: 15),
          CustomFormField(
              label: 'Color',
              hint: 'e.g. Giallo Orion (Yellow)',
              controller: colorController),
          const SizedBox(height: 15),
          CustomFormField(
              label: 'Description',
              hint: 'Tell buyers more about your car...',
              controller: descriptionController,
              maxLines: 4),
        ],
      ),
    );
  }
}
