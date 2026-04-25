import 'package:TR/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  late Box _settingsBox;

  Future<void> init() async {
    _settingsBox = Hive.box('settings_box');
    _loadSettings();
  }

  void initTheme(BuildContext context) {
    final isDesktop = context.isDesktop;
    if (state.isDesktop != isDesktop) {
      emit(state.copyWith(isDesktop: isDesktop));
    }
  }

  void _loadSettings() {
    final isDarkMode = _settingsBox.get('isDarkMode', defaultValue: false) as bool;
    final appLanguage = _settingsBox.get('appLanguage', defaultValue: 'en') as String;
    final pushNotifications = _settingsBox.get('pushNotifications', defaultValue: true) as bool;

    emit(state.copyWith(
      isDarkMode: isDarkMode,
      appLanguage: appLanguage,
      pushNotifications: pushNotifications,
    ));
  }

  void toggleDarkMode(bool value) {
    _settingsBox.put('isDarkMode', value);
    emit(state.copyWith(isDarkMode: value));
  }

  void setLanguage(String value) {
    _settingsBox.put('appLanguage', value);
    emit(state.copyWith(appLanguage: value));
  }

  void togglePushNotifications(bool value) {
    _settingsBox.put('pushNotifications', value);
    emit(state.copyWith(pushNotifications: value));
  }
}