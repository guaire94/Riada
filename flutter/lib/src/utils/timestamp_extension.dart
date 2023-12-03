import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';

extension TimestampExtension on Timestamp {
  String fromNow() {
    return Jiffy(this.toDate()).fromNow();
  }

  String dateDescription() {
    return Jiffy(this.toDate()).format("EEEE d MMMM");
  }
}

extension DateTimeExtension on DateTime {
  Timestamp toTimestamp() {
    return Timestamp.fromDate(this);
  }

  String get fullDate {
    return Jiffy(this).format('MMMM do yyyy, h:mm:ss a');
  }

  String get fromNow {
    return Jiffy(this).fromNow();
  }

  String dateDescription() {
    return Jiffy(this).format("EEEE d MMMM");
  }

  String get fullDateDescription {
    return Jiffy(this).format("yyyy/MM/dd - hh:mm");
  }
}

// MARK: - Static
DateTime tomorrow() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day + 1);
}

DateTime nextWeek() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day + 7);
}

DateTime nextYear() {
  final now = DateTime.now();
  return DateTime(now.year + 1, now.month, now.day);
}
