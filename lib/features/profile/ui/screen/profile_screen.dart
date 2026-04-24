import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/address/ui/screen/adrress_screen.dart';
import 'package:TR/features/address/ui/screen/saved_address.dart';
import 'package:TR/features/admin/ui/screen/admin_dashboard_screen.dart';
import 'package:TR/features/auth/logic/cubit/auth_cubit.dart';
import 'package:TR/features/orders_history/ui/screen/order_history_screen.dart';
import 'package:TR/features/settings/ui/screen/setting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/app_sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.neutralColor,
      appBar: AppBar(
        title: Text(
          l10n.myProfile,
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
            _buildProfileHeader(context),
            const SizedBox(height: 30),
            _buildMenuSection(context),
            const SizedBox(height: 20),
            Text(
              l10n.version,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName;
    final email = user?.email;

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
              child: const Icon(
                Icons.verified_user,
                size: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          displayName?.isNotEmpty == true ? displayName! : l10n.signedInUser,
          style: GoogleFonts.notoSerif(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          email ?? l10n.guestSessionId('8821'),
          style: GoogleFonts.manrope(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          final userData = snapshot.data?.data();
          final isAdmin =
              userData?['role'] == 'admin' || userData?['isAdmin'] == true;

          return Column(
            children: [
              _profileTile(Icons.shopping_bag_outlined, l10n.myOrders, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrderHistoryScreen(),
                  ),
                );
              }),
              _divider(),
              _profileTile(
                Icons.location_on_outlined,
                l10n.shippingAddresses,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavedAddress(),
                    ),
                  );
                },
              ),
              if (isAdmin) ...[
                _divider(),
                _profileTile(
                  Icons.admin_panel_settings_outlined,
                  l10n.adminDashboard,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminDashboardScreen(),
                      ),
                    );
                  },
                ),
              ],
              _divider(),
              _profileTile(Icons.settings_outlined, l10n.settings, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              }),
              _divider(),
              _profileTile(Icons.help_outline, l10n.helpCenter, () {}),
              _divider(),
              _profileTile(Icons.logout, l10n.logout, () async {
                await context.read<AuthCubit>().signOut();
              }, color: AppTheme.secondaryColor),
            ],
          );
        },
      ),
    );
  }

  Widget _profileTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
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
