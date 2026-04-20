import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/address/ui/screen/adrress_screen.dart';
import 'package:TR/features/orders_history/ui/screen/order_history_screen.dart';
import 'package:TR/features/settings/ui/screen/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/app_sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutralColor,
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: GoogleFonts.notoSerif(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // 1. Header: صورة المستخدم والاسم
            _buildProfileHeader(),

            const SizedBox(height: 30),

            // 2. القائمة التفاعلية (Menu Options)
            _buildMenuSection(context),

            const SizedBox(height: 20),

            // 3. نسخة التطبيق أو زر تسجيل الخروج (مستقبلاً)
            Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.person, size: 60, color: Colors.white),
            ),
            CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.secondaryColor,
              child: const Icon(Icons.edit, size: 18, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          "Guest User", // يتغير عند إضافة الـ Auth
          style: GoogleFonts.notoSerif(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Guest-Session-ID: #8821",
          style: GoogleFonts.manrope(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _profileTile(Icons.shopping_bag_outlined, "My Orders", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
            );
          }),
          _divider(),
          _profileTile(Icons.location_on_outlined, "Shipping Addresses", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddressScreen()),
            );
          }),
          _divider(),
          _profileTile(Icons.settings_outlined, "Settings", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          }),
          _divider(),
          _profileTile(Icons.help_outline, "Help Center", () {}),
          _divider(),
          _profileTile(
            Icons.logout,
            "LogOut",
            () {
              // هنا نوجه المستخدم لعمل Account
            },
            isLast: true,
            color: AppTheme.secondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _profileTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isLast = false,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppTheme.primaryColor),
      title: Text(
        title,
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w600,
          color: color ?? AppTheme.primaryColor,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _divider() => Divider(height: 1, indent: 50, color: Colors.grey[100]);
}
