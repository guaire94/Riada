import 'app_localizations.dart';

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get onboarding_title => 'Bienvenue sur Riada';

  @override
  String get onboarding_error => 'Impossible de charger l\'onboarding';
}
