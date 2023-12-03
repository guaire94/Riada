import 'package:json_annotation/json_annotation.dart';

part 'sport.g.dart';

@JsonSerializable()
class Sport {
  final String id;
  final String name;

  const Sport({
    required this.id,
    required this.name,
  });

  factory Sport.fromJson(Map<String, dynamic> json) => _$SportFromJson(json);
  Map<String, dynamic> toJson() => _$SportToJson(this);
}
