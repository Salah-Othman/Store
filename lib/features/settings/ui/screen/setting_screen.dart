import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final subtitleColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: GoogleFonts.notoSerif(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          _buildSectionTitle(l10n.appearance, textColor),
          _buildSettingsCard(surfaceColor, [
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
                  textColor: textColor,
                  subtitleColor: subtitleColor,
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
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                );
              },
            ),
          ]),
          SizedBox(height: 24.h),
          _buildSectionTitle(l10n.notifications, textColor),
          _buildSettingsCard(surfaceColor, [
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
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                );
              },
            ),
          ]),
          SizedBox(height: 24.h),
          _buildSectionTitle(l10n.supportAndAbout, textColor),
          _buildSettingsCard(surfaceColor, [
            _buildNavigationTile(Icons.help_outline, l10n.helpCenter, () {}, textColor: textColor, subtitleColor: subtitleColor),
            _buildDivider(),
            _buildNavigationTile(
              Icons.policy_outlined,
              l10n.privacyPolicy,
              () {},
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            _buildDivider(),
            _buildNavigationTile(Icons.info_outline, l10n.aboutTR, () {}, textColor: textColor, subtitleColor: subtitleColor),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, bottom: 8.h),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: textColor.withValues(alpha: 0.5),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(Color surfaceColor, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
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
    required Color textColor,
    required Color subtitleColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: GoogleFonts.manrope(fontWeight: FontWeight.w500, color: textColor),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style: GoogleFonts.manrope(fontSize: 12.sp, color: subtitleColor),
            ),
      trailing: Switch.adaptive(
        value: value,
        activeTrackColor: AppTheme.darkNeutral,
        activeThumbColor: AppTheme.whiteColor,

        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNavigationTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    String? subtitle,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: GoogleFonts.manrope(fontWeight: FontWeight.w500, color: textColor),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style: GoogleFonts.manrope(fontSize: 12.sp, color: subtitleColor),
            ),
      trailing: Icon(Icons.arrow_forward_ios, size: 14.sp),
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
        final textColor = Theme.of(sheetContext).colorScheme.onSurface;

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  l10n.chooseLanguage,
                  style: GoogleFonts.notoSerif(fontWeight: FontWeight.bold, color: textColor),
                ),
              ),
              ListTile(
                leading: Icon(
                  currentLanguageCode == 'en'
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: AppTheme.secondaryColor,
                ),
                title: Text(l10n.english, style: GoogleFonts.manrope(color: textColor)),
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
                title: Text(l10n.arabic, style: GoogleFonts.manrope(color: textColor)),
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

  Widget _buildDivider() {
    final dividerColor = Theme.of(context).dividerColor;
    return Divider(height: 1, indent: 55, color: dividerColor);
  }
}
