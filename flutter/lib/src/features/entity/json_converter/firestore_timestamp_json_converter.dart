import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class FirestoreTimestampJsonConverter
    extends JsonConverter<Timestamp, Timestamp> {
  const FirestoreTimestampJsonConverter();

  @override
  Timestamp fromJson(Timestamp timestamp) {
    return timestamp;
  }

  @override
  Timestamp toJson(Timestamp timestamp) {
    return timestamp;
  }
}
