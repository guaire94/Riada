import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get onboarding_title => 'Welcome on Riada';

  @override
  String get onboarding_error => 'Impossible to load onboarding screen';
}
