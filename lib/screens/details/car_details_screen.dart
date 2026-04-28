import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/listing_model.dart';
import '../../providers/car_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/spec_item_card.dart';
import '../../core/utils/custom_msg.dart';

class CarDetailsScreen extends StatefulWidget {
  final ListingModel listing;

  const CarDetailsScreen({super.key, required this.listing});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  final String _sellerPhone = "+923001234567";

  Future<void> _makeCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: _sellerPhone,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openWhatsApp() async {
    final String message =
        "Hi, I am interested in your ${widget.listing.fullName} listed on CarSphere.";
    final Uri whatsappUri = Uri.parse(
        "https://wa.me/$_sellerPhone?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  void _shareListing() {
    final String shareText =
        "Check out this ${widget.listing.fullName} on CarSphere!\n\n"
        "Price: ${widget.listing.formattedPrice}\n"
        "Mileage: ${widget.listing.mileage} km\n"
        "Condition: ${widget.listing.status}\n\n"
        "Download CarSphere to see more!";

    Share.share(shareText,
        subject: "Car Listing: ${widget.listing.fullName}");
  }

  @override
  Widget build(BuildContext context) {
    final carProvider = Provider.of<CarProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final bool isFav = carProvider.isFavorite(widget.listing.id);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.listing.images.isNotEmpty
                  ? PageView.builder(
                      itemCount: widget.listing.images.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          widget.listing.images[index],
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Container(
                      color: AppColors.lightGrey,
                      child: const Icon(Icons.image_not_supported_outlined,
                          size: 80, color: AppColors.grey),
                    ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  if (authProvider.isLoggedIn) {
                    carProvider.toggleFavorite(
                        widget.listing.id, authProvider.user!.token!);
                  } else {
                    showCustomMsg(
                          context: context,
                          msg: 'Please login to add to favorites');
                  }
                },
                icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : AppColors.white),
              ),
              IconButton(
                onPressed: _shareListing,
                icon: const Icon(Icons.share_outlined,
                    color: AppColors.white),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.listing.company,
                              style: const TextStyle(
                                  fontSize: 16, color: AppColors.grey),
                            ),
                            Text(
                              widget.listing.model,
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.backgroundDark),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        widget.listing.formattedPrice,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.listing.status.toUpperCase(),
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Car Specifications',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SpecItemCard(
                            icon: Icons.speed,
                            label: 'Mileage',
                            value: '${widget.listing.mileage} km'),
                        const SizedBox(width: 15),
                        SpecItemCard(
                            icon: Icons.settings,
                            label: 'Type',
                            value: widget.listing.transmission),
                        const SizedBox(width: 15),
                        SpecItemCard(
                            icon: Icons.local_gas_station,
                            label: 'Fuel',
                            value: widget.listing.fuelType),
                        const SizedBox(width: 15),
                        SpecItemCard(
                            icon: Icons.palette,
                            label: 'Color',
                            value: widget.listing.color),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Description',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.listing.description,
                    style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.grey,
                        height: 1.5),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'whatsapp_btn',
            onPressed: _openWhatsApp,
            backgroundColor: Colors.green,
            child: const Icon(Icons.chat_bubble, color: Colors.white),
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            heroTag: 'call_btn',
            onPressed: _makeCall,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.call, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
