import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_data.dart';
import '../../providers/car_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/car_card.dart';
import '../../routes/app_routes.dart';
import '../../core/utils/custom_msg.dart';

class DiscoveryView extends StatefulWidget {
  const DiscoveryView({super.key});

  @override
  State<DiscoveryView> createState() => _DiscoveryViewState();
}

class _DiscoveryViewState extends State<DiscoveryView> {
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final carProvider = Provider.of<CarProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      carProvider.fetchListings();
      final token = authProvider.user?.token;
      if (token != null) {
        carProvider.fetchFavorites(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.grey,
              ),
            ),
            Text(
              'CarSphere',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: AppColors.backgroundDark,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 15, left: 5),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, color: AppColors.white, size: 20),
            ),
          ),
        ],
      ),
      body: Consumer<CarProvider>(
        builder: (context, carProvider, child) {
          if (carProvider.isLoading && carProvider.listings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              await carProvider.fetchListings();
              final token = authProvider.user?.token;
              if (token != null) {
                await carProvider.fetchFavorites(token);
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.search),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: AppColors.grey),
                          SizedBox(width: 10),
                          Text(
                            'Search your dream car...',
                            style: TextStyle(
                                color: AppColors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: AppData.carCategories.length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedCategoryIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(
                                () => _selectedCategoryIndex = index);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.lightGrey,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              AppData.carCategories[index],
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.grey,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Trending Listings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.backgroundDark,
                        ),
                      ),
                      TextButton(
                        onPressed: () => carProvider.fetchListings(),
                        child: const Text(
                          'See All',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  carProvider.listings.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                Icon(Icons.car_rental_outlined,
                                    size: 60,
                                    color:
                                        AppColors.grey.withOpacity(0.5)),
                                const SizedBox(height: 10),
                                const Text('No listings available yet.',
                                    style: TextStyle(color: AppColors.grey)),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: carProvider.listings.length,
                          itemBuilder: (context, index) {
                            final listing = carProvider.listings[index];
                            final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);
                            return CarCard(
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
                                final token = authProvider.user?.token;
                                if (token != null) {
                                  carProvider.toggleFavorite(
                                      listing.id, token);
                                } else {
                                  showCustomMsg(
                                      context: context,
                                      msg: 'Please login to add to favorites');
                                }
                              },
                            );
                          },
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
