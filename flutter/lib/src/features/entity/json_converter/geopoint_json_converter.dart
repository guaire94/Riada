import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class GeoPointJsonConverter extends JsonConverter<GeoPoint, GeoPoint> {
  const GeoPointJsonConverter();

  @override
  GeoPoint fromJson(GeoPoint json) {
    return json;
  }

  @override
  GeoPoint toJson(GeoPoint object) {
    return object;
  }
}
