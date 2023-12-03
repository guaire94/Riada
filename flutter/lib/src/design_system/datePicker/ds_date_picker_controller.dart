import 'package:intl/intl.dart';

class DSDatePickerController {
  DateTime? _date;

  DateTime? get date => _date;

  String get content {
    if (_date != null) {
      final result = DateFormat('dd/MM/yyyy').format(_date!);
      return result;
    }
    return "";
  }

  set date(DateTime? value) {
    _date = value;
  }
}
