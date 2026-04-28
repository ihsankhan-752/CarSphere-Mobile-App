import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/car_provider.dart';
import '../../providers/auth_provider.dart';

class PostListingScreen extends StatefulWidget {
  const PostListingScreen({super.key});

  @override
  State<PostListingScreen> createState() => _PostListingScreenState();
}

class _PostListingScreenState extends State<PostListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final PageController _pageController = PageController();
  
  int _currentStep = 0;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _companyController = TextEditingController();
  final _modelController = TextEditingController();
  final _priceController = TextEditingController();
  final _mileageController = TextEditingController();
  final _colorController = TextEditingController();
  
  XFile? _mainImage;
  XFile? _interiorImage;
  XFile? _engineImage;

  String _selectedFuelType = 'petrol';
  String _selectedTransmission = 'automatic';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _companyController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    _mileageController.dispose();
    _colorController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          if (type == 'main') _mainImage = image;
          else if (type == 'interior') _interiorImage = image;
          else if (type == 'engine') _engineImage = image;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      // Basic validation before moving to next step
      if (_currentStep == 0 && _mainImage == null) {
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please add a main thumbnail image.')),
         );
         return;
      }
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitListing();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitListing() async {
    final carProvider = Provider.of<CarProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      if (_mainImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least the main image.')),
        );
        return;
      }

      final data = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'company': _companyController.text.trim(),
        'model': _modelController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
        'mileage': int.tryParse(_mileageController.text.trim()) ?? 0,
        'fuelType': _selectedFuelType,
        'transmission': _selectedTransmission,
        'color': _colorController.text.trim(),
      };

      final token = authProvider.user?.token;
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to post a listing')),
        );
        return;
      }

      List<XFile> finalImages = [];
      if (_mainImage != null) finalImages.add(_mainImage!);
      if (_interiorImage != null) finalImages.add(_interiorImage!);
      if (_engineImage != null) finalImages.add(_engineImage!);

      final success = await carProvider.addListing(data, token, images: finalImages);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing posted successfully!'), backgroundColor: Colors.green),
        );
        _formKey.currentState!.reset();
        setState(() {
          _mainImage = null;
          _interiorImage = null;
          _engineImage = null;
          _currentStep = 0;
        });
        _pageController.jumpToPage(0);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(carProvider.error ?? 'Failed to post listing'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Post New Listing', style: TextStyle(color: AppColors.backgroundDark, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(
            child: Form(
              key: _formKey,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentStep = index);
                },
                children: [
                  _buildStep1Visuals(),
                  _buildStep2BasicDetails(),
                  _buildStep3Specifications(),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    String stepTitle = '';
    if (_currentStep == 0) stepTitle = 'VISUAL ASSETS';
    else if (_currentStep == 1) stepTitle = 'BASIC DETAILS';
    else if (_currentStep == 2) stepTitle = 'SPECIFICATIONS';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Step ${_currentStep + 1} of 3', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(stepTitle, style: const TextStyle(color: AppColors.grey, fontSize: 12, letterSpacing: 1.2)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: index <= _currentStep ? AppColors.primary : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1Visuals() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Capture the Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('High-quality photos increase buyer interest by up to 80%. Show your car from all angles.',
            style: TextStyle(color: AppColors.grey, fontSize: 14)),
          const SizedBox(height: 30),
          
          // Main Image Upload
          _buildImageUploadCard(
            title: 'Upload Photos',
            subtitle: 'Main thumbnail image',
            icon: Icons.camera_alt_outlined,
            imageFile: _mainImage,
            onTap: () => _showPickerOptions(context, 'main'),
            onRemove: () => setState(() => _mainImage = null),
            isLarge: true,
          ),
          
          const SizedBox(height: 15),
          
          // Sub Images Upload
          Row(
            children: [
              Expanded(
                child: _buildImageUploadCard(
                  title: 'INTERIOR',
                  icon: Icons.add_circle_outline,
                  imageFile: _interiorImage,
                  onTap: () => _showPickerOptions(context, 'interior'),
                  onRemove: () => setState(() => _interiorImage = null),
                  isLarge: false,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildImageUploadCard(
                  title: 'ENGINE',
                  icon: Icons.add_circle_outline,
                  imageFile: _engineImage,
                  onTap: () => _showPickerOptions(context, 'engine'),
                  onRemove: () => setState(() => _engineImage = null),
                  isLarge: false,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 30),
          
          // Pro Tip Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F2C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 24),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Pro Tip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Take photos in natural daylight and clear the interior for a professional showroom look.',
                        style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4)),
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

  Widget _buildStep2BasicDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Basic Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text('Provide general information about the car.', style: TextStyle(color: AppColors.grey)),
          const SizedBox(height: 30),
          
          _buildTextField('Listing Title', 'e.g. Pristine Lamborghini Aventador', controller: _titleController),
          const SizedBox(height: 15),
          _buildTextField('Car Brand/Company', 'e.g. Lamborghini', controller: _companyController),
          const SizedBox(height: 15),
          _buildTextField('Car Model', 'e.g. Aventador', controller: _modelController),
          const SizedBox(height: 15),
          _buildTextField('Color', 'e.g. Giallo Orion (Yellow)', controller: _colorController),
          const SizedBox(height: 15),
          _buildTextField('Description', 'Tell buyers more about your car...', controller: _descriptionController, maxLines: 4),
        ],
      ),
    );
  }

  Widget _buildStep3Specifications() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Specifications & Pricing', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text('Add technical details and set your asking price.', style: TextStyle(color: AppColors.grey)),
          const SizedBox(height: 30),
          
          Row(
            children: [
              Expanded(child: _buildTextField('Price (\$)', '500000', controller: _priceController, keyboardType: TextInputType.number)),
              const SizedBox(width: 15),
              Expanded(child: _buildTextField('Mileage (km)', '1200', controller: _mileageController, keyboardType: TextInputType.number)),
            ],
          ),
          const SizedBox(height: 15),
          _buildDropdownField('Fuel Type', ['petrol', 'diesel', 'electric', 'hybrid'], _selectedFuelType, (val) => setState(() => _selectedFuelType = val!)),
          const SizedBox(height: 15),
          _buildDropdownField('Transmission', ['automatic', 'manual'], _selectedTransmission, (val) => setState(() => _selectedTransmission = val!)),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final carProvider = Provider.of<CarProvider>(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: AppColors.grey),
                ),
                child: const Text('Back', style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 15),
          ],
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: carProvider.isLoading ? null : _nextStep,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: carProvider.isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(
                    _currentStep == 2 ? 'Post Listing' : 'Next Step \u2192', // Unicode arrow
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadCard({
    required String title,
    String? subtitle,
    required IconData icon,
    XFile? imageFile,
    required VoidCallback onTap,
    required VoidCallback onRemove,
    required bool isLarge,
  }) {
    if (imageFile != null) {
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: isLarge ? 200 : 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: FileImage(File(imageFile.path)),
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
          color: const Color(0xFFF5F7FA), // Light greyish blue
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 1),
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
              child: Icon(icon, color: AppColors.primary, size: isLarge ? 30 : 24),
            ),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isLarge ? 16 : 12)),
            if (subtitle != null) ...[
              const SizedBox(height: 5),
              Text(subtitle, style: const TextStyle(color: AppColors.grey, fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }

  void _showPickerOptions(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
              title: const Text('Pick from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, type);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, type);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String value, ValueChanged<String?> onChanged) {
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

  Widget _buildTextField(String label, String hint, {required TextEditingController controller, int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }
}
