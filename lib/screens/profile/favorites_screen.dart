import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/car_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/car_card.dart';
import '../../routes/app_routes.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('My Favorites', style: TextStyle(color: AppColors.backgroundDark, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.backgroundDark),
      ),
      body: Consumer2<CarProvider, AuthProvider>(
        builder: (context, carProvider, authProvider, _) {
          if (!authProvider.isLoggedIn) {
            return const Center(child: Text('Please login to view favorites'));
          }

          if (carProvider.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: AppColors.grey.withOpacity(0.3)),
                  const SizedBox(height: 20),
                  const Text('No favorites yet', style: TextStyle(color: AppColors.grey, fontSize: 18)),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go explore listings'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: carProvider.favorites.length,
            itemBuilder: (context, index) {
              final listing = carProvider.favorites[index];
              return CarCard(
                listing: listing,
                isFavorite: true,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.details,
                    arguments: listing,
                  );
                },
                onFavoriteTap: () {
                  carProvider.toggleFavorite(listing.id, authProvider.user!.token!);
                },
              );
            },
          );
        },
      ),
    );
  }
}
