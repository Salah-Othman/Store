import 'package:TR/core/localization/app_localizations.dart';
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
    _settingsBox = Hive.box('settings_box');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.neutralColor,
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: GoogleFonts.notoSerif(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle(l10n.appearance),
          _buildSettingsCard([
            ValueListenableBuilder(
              valueListenable: _settingsBox.listenable(keys: ['isDarkMode']),
              builder: (context, Box box, _) {
                final isDark =
                    box.get('isDarkMode', defaultValue: false) as bool;
                return _buildSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: l10n.darkMode,
                  value: isDark,
                  onChanged: (val) => box.put('isDarkMode', val),
                );
              },
            ),
            _buildDivider(),
            ValueListenableBuilder(
              valueListenable: _settingsBox.listenable(keys: ['appLanguage']),
              builder: (context, Box box, _) {
                final languageCode =
                    box.get('appLanguage', defaultValue: 'en') as String;

                return _buildNavigationTile(
                  Icons.language_outlined,
                  l10n.language,
                  () => _showLanguageSheet(context, languageCode),
                  subtitle: l10n.languageName(languageCode),
                );
              },
            ),
          ]),
          const SizedBox(height: 24),
          _buildSectionTitle(l10n.notifications),
          _buildSettingsCard([
            ValueListenableBuilder(
              valueListenable: _settingsBox.listenable(
                keys: ['pushNotifications'],
              ),
              builder: (context, Box box, _) {
                final notificationsEnabled =
                    box.get('pushNotifications', defaultValue: true) as bool;

                return _buildSwitchTile(
                  icon: Icons.notifications_none_outlined,
                  title: l10n.pushNotifications,
                  subtitle: l10n.pushNotificationsSubtitle,
                  value: notificationsEnabled,
                  onChanged: (val) => box.put('pushNotifications', val),
                );
              },
            ),
          ]),
          const SizedBox(height: 24),
          _buildSectionTitle(l10n.supportAndAbout),
          _buildSettingsCard([
            _buildNavigationTile(Icons.help_outline, l10n.helpCenter, () {}),
            _buildDivider(),
            _buildNavigationTile(
              Icons.policy_outlined,
              l10n.privacyPolicy,
              () {},
            ),
            _buildDivider(),
            _buildNavigationTile(Icons.info_outline, l10n.aboutAtelier, () {}),
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

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(
        title,
        style: GoogleFonts.manrope(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style: GoogleFonts.manrope(fontSize: 12, color: Colors.grey[600]),
            ),
      trailing: Switch.adaptive(
        value: value,
        activeThumbColor: AppTheme.secondaryColor,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNavigationTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    String? subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(
        title,
        style: GoogleFonts.manrope(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style: GoogleFonts.manrope(fontSize: 12, color: Colors.grey[600]),
            ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }

  Future<void> _showLanguageSheet(
    BuildContext context,
    String currentLanguageCode,
  ) async {
    final l10n = AppLocalizations.of(context);

    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  l10n.chooseLanguage,
                  style: GoogleFonts.notoSerif(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: Icon(
                  currentLanguageCode == 'en'
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: AppTheme.secondaryColor,
                ),
                title: Text(l10n.english),
                onTap: () {
                  _settingsBox.put('appLanguage', 'en');
                  Navigator.pop(sheetContext);
                },
              ),
              ListTile(
                leading: Icon(
                  currentLanguageCode == 'ar'
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: AppTheme.secondaryColor,
                ),
                title: Text(l10n.arabic),
                onTap: () {
                  _settingsBox.put('appLanguage', 'ar');
                  Navigator.pop(sheetContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDivider() =>
      Divider(height: 1, indent: 55, color: Colors.grey[100]);
}
