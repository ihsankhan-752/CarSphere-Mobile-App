import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/car_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/utils/custom_msg.dart';
import 'widgets/post_progress_bar.dart';
import 'widgets/step1_visuals.dart';
import 'widgets/step2_basic_details.dart';
import 'widgets/step3_specifications.dart';
import 'widgets/post_bottom_bar.dart';

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

  Future<void> _pickImage(String type) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: AppColors.primary),
              title: const Text('Pick from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) _setImage(type, image);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined,
                  color: AppColors.primary),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.camera);
                if (image != null) _setImage(type, image);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _setImage(String type, XFile image) {
    setState(() {
      if (type == 'main') _mainImage = image;
      if (type == 'interior') _interiorImage = image;
      if (type == 'engine') _engineImage = image;
    });
  }

  void _removeImage(String type) {
    setState(() {
      if (type == 'main') _mainImage = null;
      if (type == 'interior') _interiorImage = null;
      if (type == 'engine') _engineImage = null;
    });
  }

  void _nextStep() {
    if (_currentStep < 2) {
      if (_currentStep == 0 && _mainImage == null) {
        showCustomMsg(context: context, msg: 'Please add a main thumbnail image.');
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
        showCustomMsg(context: context, msg: 'Please add at least the main image.');
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
        showCustomMsg(context: context, msg: 'Please login to post a listing');
        return;
      }

      List<XFile> finalImages = [];
      if (_mainImage != null) finalImages.add(_mainImage!);
      if (_interiorImage != null) finalImages.add(_interiorImage!);
      if (_engineImage != null) finalImages.add(_engineImage!);

      final success =
          await carProvider.addListing(data, token, images: finalImages);

      if (success && mounted) {
        showCustomMsg(
              context: context,
              msg: 'Listing posted successfully!',
              bgColor: Colors.green);
        _formKey.currentState!.reset();
        setState(() {
          _mainImage = null;
          _interiorImage = null;
          _engineImage = null;
          _currentStep = 0;
        });
        _pageController.jumpToPage(0);
      } else if (mounted) {
        showCustomMsg(
              context: context,
              msg: carProvider.error ?? 'Failed to post listing',
              bgColor: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Post New Listing',
            style: TextStyle(
                color: AppColors.backgroundDark,
                fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          PostProgressBar(currentStep: _currentStep),
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
                  Step1Visuals(
                    mainImage: _mainImage,
                    interiorImage: _interiorImage,
                    engineImage: _engineImage,
                    onPickImage: _pickImage,
                    onRemoveImage: _removeImage,
                  ),
                  Step2BasicDetails(
                    titleController: _titleController,
                    companyController: _companyController,
                    modelController: _modelController,
                    colorController: _colorController,
                    descriptionController: _descriptionController,
                  ),
                  Step3Specifications(
                    priceController: _priceController,
                    mileageController: _mileageController,
                    selectedFuelType: _selectedFuelType,
                    selectedTransmission: _selectedTransmission,
                    onFuelChanged: (val) =>
                        setState(() => _selectedFuelType = val!),
                    onTransmissionChanged: (val) =>
                        setState(() => _selectedTransmission = val!),
                  ),
                ],
              ),
            ),
          ),
          PostBottomBar(
            currentStep: _currentStep,
            onNext: _nextStep,
            onPrevious: _previousStep,
          ),
        ],
      ),
    );
  }
}
