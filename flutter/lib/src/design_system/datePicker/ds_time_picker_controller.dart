import 'package:flutter/material.dart';

class DSTimePickerController {
  TimeOfDay? _time;

  TimeOfDay? get time => _time;

  String get content {
    if (_time != null) {
      return _time!.hour.toString() + ":" + _time!.minute.toString();
    }

    return "";
  }

  set time(TimeOfDay? value) {
    _time = value;
  }
}
