import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  const User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.token = '',
  });

  final String id;
  final String firstname;
  final String lastname;
  final String email;
  @JsonKey(includeIfNull: false, defaultValue: '')
  final String token;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
