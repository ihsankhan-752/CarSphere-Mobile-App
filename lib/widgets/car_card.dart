import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/models/listing_model.dart';

class CarCard extends StatelessWidget {
  final ListingModel listing;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const CarCard({
    super.key,
    required this.listing,
    this.isFavorite = false,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: listing.images.isNotEmpty
                      ? Image.network(
                          listing.images.first,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 180,
                            color: AppColors.lightGrey,
                            child: const Icon(Icons.error),
                          ),
                        )
                      : Container(
                          height: 180,
                          width: double.infinity,
                          color: AppColors.lightGrey,
                          child: const Icon(Icons.image_not_supported_outlined, size: 40, color: AppColors.grey),
                        ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : AppColors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      listing.status.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          listing.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.backgroundDark,
                          ),
                        ),
                      ),
                      Text(
                        listing.formattedPrice,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.speed, size: 14, color: AppColors.grey),
                      const SizedBox(width: 5),
                      Text(
                        '${listing.mileage} km',
                        style: const TextStyle(color: AppColors.grey, fontSize: 14),
                      ),
                      const SizedBox(width: 15),
                      const Icon(Icons.settings_outlined, size: 14, color: AppColors.grey),
                      const SizedBox(width: 5),
                      Text(
                        listing.transmission,
                        style: const TextStyle(color: AppColors.grey, fontSize: 14),
                      ),
                      const SizedBox(width: 15),
                      const Icon(Icons.local_gas_station_outlined, size: 14, color: AppColors.grey),
                      const SizedBox(width: 5),
                      Text(
                        listing.fuelType,
                        style: const TextStyle(color: AppColors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
