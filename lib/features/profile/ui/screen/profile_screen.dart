import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/core/utils/responsive_helper.dart';
import 'package:TR/features/address/ui/screen/saved_address.dart';
import 'package:TR/features/admin/logic/cubit/admin_cubit.dart';
import 'package:TR/features/admin/ui/screen/admin_dashboard_screen.dart';
import 'package:TR/features/auth/logic/cubit/auth_cubit.dart';
import 'package:TR/features/orders_history/ui/screen/order_history_screen.dart';
import 'package:TR/features/settings/ui/screen/setting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: Text(
          l10n.myProfile,
          style: GoogleFonts.notoSerif(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: isDesktop ? 40.h : 20.h),
            _buildProfileHeader(context, isDesktop: isDesktop),
            SizedBox(height: isDesktop ? 50.h : 30.h),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 450 : (isTablet ? 600 : double.infinity),
              ),
              child: _buildMenuSection(context, isDesktop: isDesktop),
            ),
            SizedBox(height: 20.h),
            Text(
              l10n.version,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, {required bool isDesktop}) {
    final l10n = AppLocalizations.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName;
    final email = user?.email;
    final avatarSize = isDesktop ? 100.0 : 60.0;
    final iconSize = isDesktop ? 80.0 : 60.0;
    final badgeSize = isDesktop ? 28.0 : 18.0;

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: avatarSize,
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.person, size: iconSize, color: Colors.white),
            ),
            CircleAvatar(
              radius: badgeSize,
              backgroundColor: AppTheme.secondaryColor,
              child: Icon(
                Icons.verified_user,
                size: badgeSize,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          displayName?.isNotEmpty == true ? displayName! : l10n.signedInUser,
          style: GoogleFonts.notoSerif(
            fontSize: isDesktop ? 28.sp : 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          email ?? l10n.guestSessionId('8821'),
          style: GoogleFonts.manrope(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context, {required bool isDesktop}) {
    final l10n = AppLocalizations.of(context);
    final currentUser = FirebaseAuth.instance.currentUser;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final dividerColor = Theme.of(context).dividerColor;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 80.w : 16.w),
      decoration: BoxDecoration(
        color: surfaceColor,
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
              _profileTile(
                Icons.shopping_bag_outlined,
                l10n.myOrders,
                color: textColor,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderHistoryScreen(),
                    ),
                  );
                },
                isDesktop: isDesktop,
              ),
              _divider(color: dividerColor),
              _profileTile(
                Icons.location_on_outlined,
                l10n.shippingAddresses,
                color: textColor,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavedAddress(),
                    ),
                  );
                },
                isDesktop: isDesktop,
              ),
              if (isAdmin) ...[
                _divider(color: dividerColor),
                _profileTile(
                  Icons.admin_panel_settings_outlined,
                  l10n.adminDashboard,
                  color: textColor,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminDashboardScreen(),
                      ),
                    );
                  },
                  isDesktop: isDesktop,
                ),
              ],
              _divider(color: dividerColor),
              _profileTile(
                Icons.settings_outlined,
                l10n.settings,
                color: textColor,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                isDesktop: isDesktop,
              ),
              _divider(color: dividerColor),
              _profileTile(
                Icons.help_outline,
                l10n.helpCenter,
                color: textColor,
                () {},
                isDesktop: isDesktop,
              ),
              _divider(color: dividerColor),
              _profileTile(
                Icons.logout,
                l10n.logout,
                () async {
                  await context.read<AuthCubit>().signOut();
                },
                color: AppTheme.secondaryColor,
                isDesktop: isDesktop,
              ),
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
    required bool isDesktop,
  }) {
    final iconColor = color ?? AppTheme.primaryColor;
    return ListTile(
      leading: Icon(icon, color: iconColor, size: isDesktop ? 28.sp : null),
      title: Text(
        title,
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w600,
          color: iconColor,
          fontSize: isDesktop ? 18.sp : null,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: isDesktop ? 20.sp : 16),
      onTap: onTap,
    );
  }

  Widget _divider({Color? color}) =>
      Divider(height: 1, indent: 50, color: color ?? Colors.grey[100]);
}
