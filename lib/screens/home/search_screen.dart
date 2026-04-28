import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/car_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/car_card.dart';
import '../../routes/app_routes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  
  // Filter States
  String? _selectedCompany;
  String? _selectedFuelType;
  String? _selectedTransmission;
  RangeValues _priceRange = const RangeValues(0, 500000);
  
  final List<String> _companies = ['All', 'Toyota', 'Honda', 'Tesla', 'BMW', 'Mercedes', 'Audi', 'Ford', 'Nissan', 'Hyundai'];
  final List<String> _fuelTypes = ['All', 'petrol', 'diesel', 'electric', 'hybrid'];
  final List<String> _transmissions = ['All', 'automatic', 'manual'];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    final Map<String, String> filters = {};
    
    if (_searchController.text.isNotEmpty) {
      filters['search'] = _searchController.text;
    }
    
    if (_selectedCompany != null && _selectedCompany != 'All') {
      filters['company'] = _selectedCompany!;
    }
    
    if (_selectedFuelType != null && _selectedFuelType != 'All') {
      filters['fuelType'] = _selectedFuelType!;
    }
    
    if (_selectedTransmission != null && _selectedTransmission != 'All') {
      filters['transmission'] = _selectedTransmission!;
    }
    
    filters['minPrice'] = _priceRange.start.round().toString();
    filters['maxPrice'] = _priceRange.end.round().toString();

    Provider.of<CarProvider>(context, listen: false).fetchListings(filters: filters);
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.backgroundDark),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                
                // Price Range
                const Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 500000,
                  divisions: 50,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.lightGrey,
                  labels: RangeLabels(
                    '\$${_priceRange.start.round()}',
                    '\$${_priceRange.end.round()}',
                  ),
                  onChanged: (values) {
                    setModalState(() => _priceRange = values);
                    setState(() {});
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${_priceRange.start.round()}', style: const TextStyle(color: AppColors.grey)),
                    Text('\$${_priceRange.end.round()}', style: const TextStyle(color: AppColors.grey)),
                  ],
                ),
                const SizedBox(height: 25),

                // Company Dropdown
                _buildFilterDropdown(
                  label: 'Brand / Company',
                  value: _selectedCompany,
                  items: _companies,
                  onChanged: (val) {
                    setModalState(() => _selectedCompany = val);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),

                // Fuel Type
                _buildFilterDropdown(
                  label: 'Fuel Type',
                  value: _selectedFuelType,
                  items: _fuelTypes,
                  onChanged: (val) {
                    setModalState(() => _selectedFuelType = val);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),

                // Transmission
                _buildFilterDropdown(
                  label: 'Transmission',
                  value: _selectedTransmission,
                  items: _transmissions,
                  onChanged: (val) {
                    setModalState(() => _selectedTransmission = val);
                    setState(() {});
                  },
                ),

                const Spacer(),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setModalState(() {
                            _selectedCompany = null;
                            _selectedFuelType = null;
                            _selectedTransmission = null;
                            _priceRange = const RangeValues(0, 500000);
                          });
                          setState(() {});
                          _applyFilters();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text('Reset', style: TextStyle(color: AppColors.primary)),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _applyFilters();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGrey),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value ?? items[0],
              isExpanded: true,
              items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Explore', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar & Filter Icon
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search brand, model...',
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: _showFilterSheet,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: Consumer<CarProvider>(
              builder: (context, carProvider, _) {
                if (carProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (carProvider.listings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 80, color: AppColors.grey.withOpacity(0.5)),
                        const SizedBox(height: 20),
                        const Text('No cars match your filters', style: TextStyle(color: AppColors.grey, fontSize: 16)),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _selectedCompany = null;
                              _selectedFuelType = null;
                              _selectedTransmission = null;
                              _priceRange = const RangeValues(0, 500000);
                            });
                            _applyFilters();
                          },
                          child: const Text('Clear All Filters'),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => _applyFilters(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: carProvider.listings.length,
                    itemBuilder: (context, index) {
                      final listing = carProvider.listings[index];
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: CarCard(
                          listing: listing,
                          isFavorite: carProvider.isFavorite(listing.id),
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              AppRoutes.details, 
                              arguments: listing,
                            );
                          },
                          onFavoriteTap: () {
                            if (authProvider.isLoggedIn) {
                              carProvider.toggleFavorite(listing.id, authProvider.user!.token!);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please login to add to favorites')),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
