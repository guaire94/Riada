import 'package:riada/src/utils/exceptions.dart';

class LoginFailedException implements RiadaException {
  @override
  String get message => 'Login Failed';
}
