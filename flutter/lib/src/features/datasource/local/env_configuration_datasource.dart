import 'package:injectable/injectable.dart';

enum EnvConfiguration { staging, prod }

@Singleton()
class EnvConfigurationDataSource {
  // MARK: - Dependencies
  final EnvConfiguration _configuration;

  // MARK: - LifeCycle
  EnvConfigurationDataSource({required EnvConfiguration configuration})
      : _configuration = configuration;

  // MARK: - Public
  EnvConfiguration get configuration => _configuration;
}
