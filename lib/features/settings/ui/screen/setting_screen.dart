import 'package:TR/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Box _settingsBox;

  @override
  void initState() {
    super.initState();
    // التأكد من الوصول للـ Box المفتوح في الـ main
    _settingsBox = Hive.box('settings_box');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutralColor,
      appBar: AppBar(
        title: Text("Settings", style: GoogleFonts.notoSerif(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle("Appearance"),
          _buildSettingsCard([
            ValueListenableBuilder(
              valueListenable: _settingsBox.listenable(keys: ['isDarkMode']),
              builder: (context, Box box, _) {
                final isDark = box.get('isDarkMode', defaultValue: false);
                return _buildSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: "Dark Mode",
                  value: isDark,
                  onChanged: (val) => box.put('isDarkMode', val),
                );
              },
            ),
          ]),
          
          const SizedBox(height: 24),
          _buildSectionTitle("Notifications"),
          _buildSettingsCard([
            _buildSwitchTile(
              icon: Icons.notifications_none_outlined,
              title: "Push Notifications",
              value: true, // يمكن ربطها بـ Hive لاحقاً
              onChanged: (val) {},
            ),
          ]),

          const SizedBox(height: 24),
          _buildSectionTitle("Support & About"),
          _buildSettingsCard([
            _buildNavigationTile(Icons.help_outline, "Help Center", () {}),
            _buildDivider(),
            _buildNavigationTile(Icons.policy_outlined, "Privacy Policy", () {}),
            _buildDivider(),
            _buildNavigationTile(Icons.info_outline, "About Atelier", () {}),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({required IconData icon, required String title, required bool value, required Function(bool) onChanged}) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title, style: GoogleFonts.manrope(fontWeight: FontWeight.w500)),
      trailing: Switch.adaptive(
        value: value,
        activeColor: AppTheme.secondaryColor,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNavigationTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title, style: GoogleFonts.manrope(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }

  Widget _buildDivider() => Divider(height: 1, indent: 55, color: Colors.grey[100]);
}