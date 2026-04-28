import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/car_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final carProvider = Provider.of<CarProvider>(context, listen: false);
      if (authProvider.user?.role == 'seller' && authProvider.user?.userId != null) {
        carProvider.fetchMyListings(authProvider.user!.userId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, CarProvider>(
      builder: (context, authProvider, carProvider, _) {
        final user = authProvider.user;
        final isSeller = user?.role == 'seller';
        
        // Calculate seller stats from myListings
        final totalListings = carProvider.myListings.length;
        final activeListings = carProvider.myListings.where((l) => l.status == 'active').length;
        final soldListings = carProvider.myListings.where((l) => l.status == 'sold').length;

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: RefreshIndicator(
            onRefresh: () async {
              if (isSeller && user?.userId != null) {
                await carProvider.fetchMyListings(user!.userId!);
              }
              await authProvider.init(); // Refresh user info too
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.person, size: 60, color: AppColors.white),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          user?.username ?? 'Guest User',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user?.email ?? 'Sign in to explore more',
                          style: const TextStyle(color: AppColors.grey),
                        ),
                        
                        if (user != null) ...[
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              user.role.toUpperCase(),
                              style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],

                        const SizedBox(height: 30),
                        
                        // Stats Row - ONLY FOR SELLERS
                        if (isSeller)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem('Total', totalListings.toString()),
                              _buildStatItem('Active', activeListings.toString()),
                              _buildStatItem('Sold', soldListings.toString()),
                            ],
                          )
                        else if (user != null)
                          // For Buyers, show account info summary
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildInfoItem(Icons.phone_outlined, user.phone),
                              _buildInfoItem(Icons.location_on_outlined, user.city),
                            ],
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Menu Items
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Account Management',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.grey),
                        ),
                        const SizedBox(height: 15),
                        
                        if (isSeller) ...[
                          _buildMenuItem(Icons.add_circle_outline, 'Add New Listing', () {
                             Navigator.pushNamed(context, AppRoutes.post);
                          }),
                          _buildMenuItem(Icons.list_alt_rounded, 'Manage My Listings', () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coming soon: Listing Management View')));
                          }),
                        ],
                        
                        _buildMenuItem(Icons.favorite_outline_rounded, 'My Favorites', () {
                          Navigator.pushNamed(context, AppRoutes.favorites);
                        }),
                        
                        _buildMenuItem(Icons.settings_outlined, 'Settings', () {
                          Navigator.pushNamed(context, AppRoutes.settings);
                        }),
                        
                        _buildMenuItem(Icons.help_outline_rounded, 'Help & Support', () {}),
                        
                        const SizedBox(height: 20),
                        _buildMenuItem(Icons.logout_rounded, 'Logout', () async {
                          await authProvider.logout();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, AppRoutes.login);
                          }
                        }, color: AppColors.error),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: AppColors.grey, fontSize: 13)),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        tileColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (color ?? AppColors.primary).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color ?? AppColors.primary, size: 20),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color, fontSize: 15)),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.grey, size: 20),
      ),
    );
  }
}
