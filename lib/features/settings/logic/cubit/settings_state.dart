part of 'settings_cubit.dart';

class SettingsState {
  final bool isDarkMode;
  final String appLanguage;
  final bool pushNotifications;
  final bool isDesktop;

  SettingsState({
    this.isDarkMode = false,
    this.appLanguage = 'en',
    this.pushNotifications = true,
    this.isDesktop = false,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    String? appLanguage,
    bool? pushNotifications,
    bool? isDesktop,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      appLanguage: appLanguage ?? this.appLanguage,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      isDesktop: isDesktop ?? this.isDesktop,
    );
  }
}