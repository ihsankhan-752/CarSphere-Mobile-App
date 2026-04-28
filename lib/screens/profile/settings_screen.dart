import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

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
        title: const Text('Settings', style: TextStyle(color: AppColors.backgroundDark, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.backgroundDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('App Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildSettingTile(
              Icons.notifications_outlined,
              'Notifications',
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (val) => setState(() => _notificationsEnabled = val),
                activeColor: AppColors.primary,
              ),
            ),
            _buildSettingTile(
              Icons.dark_mode_outlined,
              'Dark Mode',
              trailing: Switch(
                value: _darkModeEnabled,
                onChanged: (val) => setState(() => _darkModeEnabled = val),
                activeColor: AppColors.primary,
              ),
            ),
            const SizedBox(height: 30),
            const Text('Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildSettingTile(Icons.person_outline, 'Edit Profile', onTap: () {}),
            _buildSettingTile(Icons.security_outlined, 'Privacy & Security', onTap: () {}),
            _buildSettingTile(Icons.language_outlined, 'Language', trailing: const Text('English', style: TextStyle(color: AppColors.grey))),
            const SizedBox(height: 30),
            const Text('Legal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildSettingTile(Icons.info_outline_rounded, 'Terms of Service', onTap: () {}),
            _buildSettingTile(Icons.privacy_tip_outlined, 'Privacy Policy', onTap: () {}),
            const SizedBox(height: 50),
            _buildSettingTile(
              Icons.delete_outline_rounded,
              'Delete Account',
              onTap: () {},
              color: AppColors.error,
              showTrailing: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, {Widget? trailing, VoidCallback? onTap, Color? color, bool showTrailing = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        onTap: onTap,
        tileColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        leading: Icon(icon, color: color ?? AppColors.primary),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
        trailing: trailing ?? (showTrailing ? const Icon(Icons.chevron_right_rounded, color: AppColors.grey) : null),
      ),
    );
  }
}
