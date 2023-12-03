import 'package:riada/src/utils/exceptions.dart';

class NoDataAvailableException implements RiadaException {
  @override
  String get message => 'No data Available';
}
