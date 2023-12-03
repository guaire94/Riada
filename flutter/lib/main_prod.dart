import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:riada/firebase/prod/firebase_options.dart';
import 'package:riada/src/app.dart';
import 'package:riada/src/factory/di.dart';
import 'package:riada/src/features/datasource/local/env_configuration_datasource.dart';
import 'package:riada/src/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: Constants.appName,
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.instance.setAutoInitEnabled(false);

  final PendingDynamicLinkData? initialDeepLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

  configureDependencies(env: EnvConfiguration.prod);

  runApp(MyApp(
    initialDeepLink: initialDeepLink,
  ));
}
