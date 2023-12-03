import 'dart:ui';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:riada/l10n/app_localizations.dart';
import 'package:riada/src/design_system/ds_theme.dart';
import 'package:riada/src/router/routes.dart';
import 'package:riada/src/utils/constants.dart';
import 'package:sizer/sizer.dart';

class MyApp extends StatefulWidget {
  final PendingDynamicLinkData? initialDeepLink;

  const MyApp({Key? key, this.initialDeepLink}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<MyApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    setIntlLocale();
    return MultiBlocProvider(
      providers: [],
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          title: Constants.appName,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('fr', ''),
          ],
          theme: dsTheme(),
          routerDelegate: _appRouter.delegate(),
          routeInformationParser: _appRouter.defaultRouteParser(),
        );
      }),
    );
  }

  void setIntlLocale() {
    Locale currentLocale = window.locale;
    Intl.defaultLocale = currentLocale.languageCode;
  }
}
