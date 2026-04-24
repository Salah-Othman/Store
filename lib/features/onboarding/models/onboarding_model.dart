import 'package:TR/core/localization/app_localizations.dart';

class OnboardingModel {
  final String image;

  OnboardingModel({required this.image});

  String getTitle(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return l10n.onboardingTitle1;
      case 1:
        return l10n.onboardingTitle2;
      case 2:
        return l10n.onboardingTitle3;
      default:
        return '';
    }
  }

  String getDesc(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return l10n.onboardingDesc1;
      case 1:
        return l10n.onboardingDesc2;
      case 2:
        return l10n.onboardingDesc3;
      default:
        return '';
    }
  }
}