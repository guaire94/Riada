import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:injectable/injectable.dart';
import 'package:riada/src/features/datasource/remote/auth_datasource.dart';

@injectable
class AuthRepository {
  // MARK: - Dependencies
  final AuthDataSource _authDataSource;

  // MARK: - LifeCycle
  AuthRepository({
    required AuthDataSource authDataSource,
  })  : _authDataSource = authDataSource,
        super();

  // MARK: - Public
  Auth.User? getUser() {
    return _authDataSource.getUser();
  }

  Future signOut() async {
    await _authDataSource.signOut();
  }

  Future deleteAccount() async {
    await _authDataSource.deleteAccount();
  }

  Future<String> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await _authDataSource.signInWithEmailPassword(
      email: email,
      password: password,
    );
  }

  Future<String> signInAnonymously() async {
    return await _authDataSource.signInAnonymously();
  }
}
