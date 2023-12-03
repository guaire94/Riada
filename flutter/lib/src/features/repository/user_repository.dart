import 'package:injectable/injectable.dart';
import 'package:riada/src/features/datasource/exceptions/user_not_logged_exception.dart';
import 'package:riada/src/features/datasource/remote/auth_datasource.dart';
import 'package:riada/src/features/datasource/remote/user_datasource.dart';
import 'package:riada/src/features/entity/sport.dart';
import 'package:riada/src/features/entity/user.dart';

@injectable
class UserRepository {
  // MARK: - Dependencies
  final AuthDataSource _authDataSource;
  final UserDataSource _userDataSource;

  // MARK: - LifeCycle
  UserRepository({
    required AuthDataSource authDataSource,
    required UserDataSource userDataSource,
  })  : _authDataSource = authDataSource,
        _userDataSource = userDataSource,
        super();

  // MARK: - Public
  Future<User> getUser(String userId) {
    return _userDataSource.getUser(userId);
  }

  Future<User> getCurrentUser() {
    final user = _authDataSource.getUser();
    if (user == null) {
      throw UserNotLoggedException();
    } else {
      return _userDataSource.getUser(user.uid);
    }
  }

  void updateFavorites(List<Sport> sports) {
    _userDataSource.updateFavorites(sports);
  }
}
