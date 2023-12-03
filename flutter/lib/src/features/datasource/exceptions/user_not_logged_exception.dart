import 'package:riada/src/utils/exceptions.dart';

class UserNotLoggedException implements RiadaException {
  @override
  String get message => 'Login Failed';
}
