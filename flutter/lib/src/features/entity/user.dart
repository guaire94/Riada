import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:riada/src/features/entity/json_converter/firestore_timestamp_json_converter.dart';
import 'package:riada/src/features/entity/json_converter/geopoint_json_converter.dart';
import 'package:riada/src/utils/constants.dart';

part 'user.g.dart';

@GeoPointJsonConverter()
@FirestoreTimestampJsonConverter()
@JsonSerializable()
class User {
  final String id;
  final String? nickName;
  List<String> favoriteSports;
  final String? mail;
  final String avatar;
  final GeoPoint? location;
  final Timestamp createdDate;

  User({
    required this.id,
    required this.nickName,
    required this.favoriteSports,
    required this.mail,
    required this.avatar,
    required this.location,
    required this.createdDate,
  });

  factory User.toDefault({
    required String id,
  }) =>
      User(
        id: id,
        nickName: null,
        favoriteSports: [],
        mail: null,
        avatar: Constants.defaultAvatar,
        createdDate: Timestamp.now(),
        location: null,
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
