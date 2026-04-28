import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_data.dart';
import '../../../../widgets/custom_form_field.dart';

class Step3Specifications extends StatelessWidget {
  final TextEditingController priceController;
  final TextEditingController mileageController;
  final String selectedFuelType;
  final String selectedTransmission;
  final ValueChanged<String?> onFuelChanged;
  final ValueChanged<String?> onTransmissionChanged;

  const Step3Specifications({
    super.key,
    required this.priceController,
    required this.mileageController,
    required this.selectedFuelType,
    required this.selectedTransmission,
    required this.onFuelChanged,
    required this.onTransmissionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Specifications & Pricing',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text('Add technical details and set your asking price.',
              style: TextStyle(color: AppColors.grey)),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                  child: CustomFormField(
                      label: 'Price (\$)',
                      hint: '500000',
                      controller: priceController,
                      keyboardType: TextInputType.number)),
              const SizedBox(width: 15),
              Expanded(
                  child: CustomFormField(
                      label: 'Mileage (km)',
                      hint: '1200',
                      controller: mileageController,
                      keyboardType: TextInputType.number)),
            ],
          ),
          const SizedBox(height: 15),
          _buildDropdownField(
            label: 'Fuel Type',
            items: AppData.fuelTypes.where((e) => e != 'All').toList(),
            value: selectedFuelType,
            onChanged: onFuelChanged,
          ),
          const SizedBox(height: 15),
          _buildDropdownField(
            label: 'Transmission',
            items: AppData.transmissions.where((e) => e != 'All').toList(),
            value: selectedTransmission,
            onChanged: onTransmissionChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item.toUpperCase()),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
