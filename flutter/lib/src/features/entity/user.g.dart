// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      nickName: json['nickName'] as String?,
      favoriteSports: (json['favoriteSports'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      mail: json['mail'] as String?,
      avatar: json['avatar'] as String,
      location: _$JsonConverterFromJson<GeoPoint, GeoPoint>(
          json['location'], const GeoPointJsonConverter().fromJson),
      createdDate: const FirestoreTimestampJsonConverter()
          .fromJson(json['createdDate'] as Timestamp),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'nickName': instance.nickName,
      'favoriteSports': instance.favoriteSports,
      'mail': instance.mail,
      'avatar': instance.avatar,
      'location': _$JsonConverterToJson<GeoPoint, GeoPoint>(
          instance.location, const GeoPointJsonConverter().toJson),
      'createdDate':
          const FirestoreTimestampJsonConverter().toJson(instance.createdDate),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
