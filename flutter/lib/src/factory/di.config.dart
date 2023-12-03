// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:riada/src/features/datasource/local/env_configuration_datasource.dart'
    as _i5;
import 'package:riada/src/features/datasource/remote/auth_datasource.dart'
    as _i3;
import 'package:riada/src/features/datasource/remote/sport_datasource.dart'
    as _i6;
import 'package:riada/src/features/datasource/remote/user_datasource.dart'
    as _i8;
import 'package:riada/src/features/presentation/onboarding/bloc/onboarding_bloc.dart'
    as _i10;
import 'package:riada/src/features/repository/auth_repository.dart' as _i4;
import 'package:riada/src/features/repository/sport_repository.dart' as _i7;
import 'package:riada/src/features/repository/user_repository.dart' as _i9;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.AuthDataSource>(() => _i3.AuthDataSource());
    gh.factory<_i4.AuthRepository>(
        () => _i4.AuthRepository(authDataSource: gh<_i3.AuthDataSource>()));
    gh.singleton<_i5.EnvConfigurationDataSource>(_i5.EnvConfigurationDataSource(
        configuration: gh<_i5.EnvConfiguration>()));
    gh.factory<_i6.SportDataSource>(() => _i6.SportDataSource());
    gh.factory<_i7.SportRepository>(
        () => _i7.SportRepository(sportDataSource: gh<_i6.SportDataSource>()));
    gh.factory<_i8.UserDataSource>(() => _i8.UserDataSource());
    gh.factory<_i9.UserRepository>(() => _i9.UserRepository(
          authDataSource: gh<_i3.AuthDataSource>(),
          userDataSource: gh<_i8.UserDataSource>(),
        ));
    gh.factory<_i10.OnBoardingBloc>(() => _i10.OnBoardingBloc(
          authRepository: gh<_i4.AuthRepository>(),
          userRepository: gh<_i9.UserRepository>(),
          sportRepository: gh<_i7.SportRepository>(),
        ));
    return this;
  }
}
