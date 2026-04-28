import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/setting_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(
                color: AppColors.backgroundDark, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.backgroundDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('App Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SettingTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (val) =>
                    setState(() => _notificationsEnabled = val),
                activeColor: AppColors.primary,
              ),
            ),
            SettingTile(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              trailing: Switch(
                value: _darkModeEnabled,
                onChanged: (val) => setState(() => _darkModeEnabled = val),
                activeColor: AppColors.primary,
              ),
            ),
            const SizedBox(height: 30),
            const Text('Account',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SettingTile(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () {}),
            SettingTile(
                icon: Icons.security_outlined,
                title: 'Privacy & Security',
                onTap: () {}),
            const SettingTile(
                icon: Icons.language_outlined,
                title: 'Language',
                trailing: Text('English',
                    style: TextStyle(color: AppColors.grey))),
            const SizedBox(height: 30),
            const Text('Legal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SettingTile(
                icon: Icons.info_outline_rounded,
                title: 'Terms of Service',
                onTap: () {}),
            SettingTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {}),
            const SizedBox(height: 50),
            SettingTile(
              icon: Icons.delete_outline_rounded,
              title: 'Delete Account',
              onTap: () {},
              color: AppColors.error,
              showTrailing: false,
            ),
          ],
        ),
      ),
    );
  }
}
